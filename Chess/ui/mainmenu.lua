local Button = require("widgets.button")
local common = require("lib.common")
local assets = require("assets")
local GameState = require("gamestate")
local UIManager = require("ui.uimanager")

MainMenu = {
  buttons = {},
  title = "Chess"
}

function MainMenu:new()
  local instance = {
    buttons = {},
    title = "Chess"
  }
  setmetatable(instance, self)
  self.__index = self
  instance:createButtons()
  return instance
end

function MainMenu:createButtons()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  local startBtn = Button:new("Play", function()
    GameState.set(GameState.PLAYING)
  end)
  startBtn:setPosition(screenW / 2 - startBtn.size.w / 2, screenH / 2 - 40)
  self.buttons[#self.buttons + 1] = startBtn

  local themeBtn = Button:new("Themes", function()
    GameState.set(GameState.THEMES)
  end)
  themeBtn:setPosition(screenW / 2 - themeBtn.size.w / 2, screenH / 2 + 20)
  self.buttons[#self.buttons + 1] = themeBtn

  local quitBtn = Button:new("Quit", function()
    love.event.quit()
  end)
  quitBtn:setPosition(screenW / 2 - quitBtn.size.w / 2, screenH / 2 + 80)
  self.buttons[#self.buttons + 1] = quitBtn

  UIManager:setButtons(self.buttons)
end

function MainMenu:mousepressed(x, y, button)
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      UIManager:setButtons(self.buttons)
      return true
    end
  end
  return false
end

function MainMenu:mousemoved(x, y, dx, dy)
  for _, btn in ipairs(self.buttons) do
    btn:mousemoved(x, y, dx, dy)
  end
end

function MainMenu:mousereleased(x, y, button)
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
end

function MainMenu:keypressed(key)
  if key == "escape" then
    love.event.quit()
  else
    UIManager:keypressed(key)
  end
end

function MainMenu:update(dt)
end

function MainMenu:draw()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  love.graphics.setFont(assets.FONT)
  love.graphics.setColor(common.unwrap(common.Color(0, 0, 0, 255)))
  love.graphics.printf(self.title, 0, screenH / 2 - 120, screenW, "center")

  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end
end

return MainMenu