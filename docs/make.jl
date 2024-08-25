push!(LOAD_PATH, "./koans/")

using Documenter, PythonInterop
# using Documenter.Remotes: GitHub

makedocs(
  sitename="JuliaKoans",
  remotes=nothing,
  # repo=GitHub("yurrriq", "julia_koans"),
  modules=[PythonInterop],
)
