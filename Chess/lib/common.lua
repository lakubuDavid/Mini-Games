local common = {
  colors = {}
}

common.Colors = {
  WHITE = { r = 255, g = 255, b = 255 },
  BLACK = { r = 0, g = 0, b = 0 },
  RED = { r = 255, g = 0, b = 0 },
  GREEN = { r = 0, g = 255, b = 0 },
  BLUE = { r = 0, g = 0, b = 255 },
  YELLOW = { r = 255, g = 255, b = 0 },
  CYAN = { r = 0, g = 255, b = 255 },
  MAGENTA = { r = 255, g = 0, b = 255 },
  ORANGE = { r = 255, g = 165, b = 0 },
  PURPLE = { r = 128, g = 0, b = 128 },
  PINK = { r = 255, g = 192, b = 203 },
  GRAY = { r = 128, g = 128, b = 128 },
  DARK_GRAY = { r = 64, g = 64, b = 64 },
  LIGHT_GRAY = { r = 192, g = 192, b = 192 },
  -- colors= {}
}

function common.colors.rgba(r, g, b, a)
  return {
    r = (r or 0) / 255,
    g = (g or 0) / 255,
    b = (b or 0) / 255,
    a = (a or 255) / 255
  }
end


function common.colors.opacity(color, alpha)
  local c = common.colors.rgba(color.r * 255, color.g * 255, color.b * 255, 255)
  c.a = alpha / 255
  return c
end

function common.colors.mix(color1, color2, t)
  t = t or 0.5
  return {
    r = color1.r + (color2.r - color1.r) * t,
    g = color1.g + (color2.g - color1.g) * t,
    b = color1.b + (color2.b - color1.b) * t
  }
end

function common.colors.unwrap(color, alpha)
  return (color.r or 1), (color.g or 1), (color.b or 1), (color.a or alpha or 1)
end

function common.Color(r, g, b, a)
  return common.colors.rgba(r, g, b, a)
end

function common.unwrap(color, alpha)
  return common.colors.unwrap(color, alpha)
end

return common
