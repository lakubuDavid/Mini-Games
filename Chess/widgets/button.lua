local common = require("lib.common")
local assets = require("assets")

Button = {
  position = { x = 0, y = 0 },
  size = { w = 0, h = 0 },
  text = "",
  font = nil,
  padding = { x = 10, y = 5 },
  backgroundColor = common.Color(200, 200, 200, 255),
  textColor = common.Color(0, 0, 0, 255),
  border = { width = 1, color = common.Color(0, 0, 0, 255) },
  onClick = function() end,
  isHovered = false,
  isPressed = false,
  isSelected = false,
  selectedColor = common.Color(100, 150, 255, 255)
}

function Button:new(text, onClick)
  local instance = {
    position = { x = 0, y = 0 },
    text = text or "",
    onClick = onClick or function() end,
    font = assets.FONT or love.graphics.newFont(16),
    padding = { x = 10, y = 5 },
    backgroundColor = common.Color(200, 200, 200, 255),
    textColor = common.Color(0, 0, 0, 255),
    border = { width = 1, color = common.Color(0, 0, 0, 255) },
    isHovered = false,
    isPressed = false,
    isSelected = false,
    selectedColor = common.Color(100, 150, 255, 255)
  }
  setmetatable(instance, self)
  self.__index = self
  instance:computeSize()
  return instance
end

function Button:computeSize()
  local textWidth = self.font:getWidth(self.text)
  local textHeight = self.font:getHeight()
  self.size.w = textWidth + (self.padding.x * 2)
  self.size.h = textHeight + (self.padding.y * 2)
end

function Button:setPosition(x, y)
  self.position.x = x
  self.position.y = y
end

function Button:setSelected(selected)
  self.isSelected = selected
end

function Button:select()
  self.isSelected = true
end

function Button:deselect()
  self.isSelected = false
  self.isPressed = false
end

function Button:activate()
  self.isPressed = true
  self.onClick()
  self.isPressed = false
end

function Button:containsPoint(x, y)
  return x >= self.position.x 
    and x <= self.position.x + self.size.w
    and y >= self.position.y 
    and y <= self.position.y + self.size.h
end

function Button:mousepressed(x, y, button)
  if button == 1 and self:containsPoint(x, y) then
    self.isPressed = true
    self.onClick()
    return true
  end
  return false
end

function Button:mousereleased(x, y, button)
  self.isPressed = false
end

function Button:mousemoved(x, y, dx, dy)
  self.isHovered = self:containsPoint(x, y)
end

function Button:update(dt)
end

function Button:draw()
  local x = self.position.x
  local y = self.position.y
  local w = self.size.w
  local h = self.size.h

  local bgColor
  if self.isSelected then
    bgColor = self.selectedColor
  elseif self.isPressed then
    bgColor = common.Color(150, 150, 150, 255)
  elseif self.isHovered then
    bgColor = common.Color(180, 180, 180, 255)
  else
    bgColor = self.backgroundColor
  end
  love.graphics.setColor(common.unwrap(bgColor))
  love.graphics.rectangle("fill", x, y, w, h)

  if self.border and self.border.width > 0 then
    if self.isSelected then
      love.graphics.setColor(common.unwrap(common.Color(50, 100, 200, 255)))
    else
      love.graphics.setColor(common.unwrap(self.border.color))
    end
    love.graphics.setLineWidth(self.border.width)
    love.graphics.rectangle("line", x, y, w, h)
  end

  love.graphics.setFont(self.font)
  love.graphics.setColor(common.unwrap(self.textColor))
  love.graphics.printf(self.text, x + self.padding.x, y + self.padding.y, w - self.padding.x * 2, "center")

  love.graphics.setColor(1, 1, 1, 1)
end

return Button