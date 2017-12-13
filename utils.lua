local utils = {
  is_box_clicked = function(x, y, w, h, mouse_x, mouse_y)
    return (
        mouse_x<x+w-1
      ) and (
        mouse_y<y+h-1
      ) and (
        mouse_y>y
      ) and (
        mouse_x>x
      )
  end
}
return utils
