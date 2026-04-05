UIManager = {
  selectedIndex = 1,
  buttons = {}
}

function UIManager:setButtons(buttons)
  self.buttons = buttons
  self.selectedIndex = 1
  self:updateSelection()
end

function UIManager:moveSelection(direction)
  if #self.buttons == 0 then return end
  
  self.buttons[self.selectedIndex]:deselect()
  self.selectedIndex = self.selectedIndex + direction
  
  if self.selectedIndex < 1 then
    self.selectedIndex = #self.buttons
  elseif self.selectedIndex > #self.buttons then
    self.selectedIndex = 1
  end
  
  self:updateSelection()
end

function UIManager:updateSelection()
  if self.buttons[self.selectedIndex] then
    self.buttons[self.selectedIndex]:select()
  end
end

function UIManager:activateSelected()
  if self.buttons[self.selectedIndex] then
    self.buttons[self.selectedIndex]:activate()
  end
end

function UIManager:keypressed(key)
  if key == "up" or key == "w" then
    self:moveSelection(-1)
  elseif key == "down" or key == "s" then
    self:moveSelection(1)
  elseif key == "return" or key == "space" then
    self:activateSelected()
  end
end

return UIManager