module DestructuringKoans

function add_separately(x, y)
  x_re, x_im = reim(x)
  y_re, y_im = reim(y)
  x_re + y_re, x_im + y_im
end

add_coordinates((x1, y1), (x2, y2)) =
  x1 + x2, y1 + y2

end
