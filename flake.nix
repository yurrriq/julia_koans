{
  description = "Julia kōans";

  inputs = {
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.05";
    nix-vscode-extensions = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks-nix = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
      url = "github:cachix/git-hooks.nix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = { config, pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          overlays = [
            (
              _final: prev: {
                treefmt = prev.treefmt1;
              }
            )
          ];
          inherit system;
        };

        devShells.default = with pkgs; let
          python-env = python3.buildEnv.override
            {
              extraLibs = [
                python3Packages.numpy
              ];
            };
          julia-env = julia.withPackages.override
            {
              extraLibs = [
                python-env
              ];
            } [
            "Documenter"
            "PythonCall"
            "Test"
          ];
        in
        mkShell {
          FONTCONFIG_FILE = makeFontsConf {
            fontDirectories = [
              julia-mono
            ];
          };

          inputsFrom = [
            config.pre-commit.devShell
          ];

          env = {
            PYTHONPATH = "${python-env}/lib/python${lib.versions.majorMinor (lib.getVersion python3)}/site-packages";
          };

          nativeBuildInputs = [
            julia-env
            nixpkgs-fmt
            python-env
            (
              vscode-with-extensions.override {
                vscode = vscodium;
                vscodeExtensions = with inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace; [
                  editorconfig.editorconfig
                  jnoortheen.nix-ide
                  julialang.language-julia
                  mkhl.direnv
                  tuttieee.emacs-mcx
                ];
              }
            )
          ];
        };

        pre-commit.settings.hooks = {
          editorconfig-checker.enable = true;
          treefmt.enable = true;
        };

        treefmt = {
          projectRootFile = ./flake.nix;
          programs = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier = {
              enable = true;
              excludes = [
                "docs/build/**"
              ];
            };
          };
        };
      };
    };
}
