module HighOrderFunctionKoans

round_list(list) =
  map(round, list)

apply_fn(f, x) =
  f(x, 5)

add_n(list, n) =
  map(x -> x + n, list)

remove_multiples(list, n) =
  filter(x -> x % n ≠ 0, list)

end
