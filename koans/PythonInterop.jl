module PythonInterop

using PyCall

export py_sinpi

function __init__()
  py"""
  import numpy as np


  def sinpi(x):
    return np.sin(np.pi * x)


  def pyfib(n, fib):
    if n < 2:
      return n
    else:
      return fib(n - 1, pyfib) + fib(n - 2, pyfib)
  """
end

@doc raw"""
    py_sinpi(x)

``\sin(\pi x)`` via [numpy](https://numpy.org).
"""
py_sinpi(x) =
  py"sinpi"(x)

get_pyfib() =
  py"pyfib"

#=
This fibonacci function is a bit different of what is usually done,
it expects to receive the function it will call to do its recursion.
The general idea is to do something like this: jlfib -> pyfib -> jlfib -> ...
=#
jlfib(n, fib) =
  n < 2 ? n : fib(n - 1, fib) + fib(n - 2, fib)

end
