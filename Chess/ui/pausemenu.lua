local Button = require("widgets.button")
local common = require("lib.common")
local assets = require("assets")
local GameState = require("gamestate")
local UIManager = require("ui.uimanager")

PauseMenu = {
  buttons = {},
  title = "Paused"
}

function PauseMenu:new()
  local instance = {
    buttons = {},
    title = "Paused"
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function PauseMenu:createButtons()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  self.buttons = {}

  local resumeBtn = Button:new("Resume", function()
    GameState.set(GameState.PLAYING)
  end)
  resumeBtn:setPosition(screenW / 2 - resumeBtn.size.w / 2, screenH / 2 - 40)
  self.buttons[#self.buttons + 1] = resumeBtn

  local quitBtn = Button:new("Main Menu", function()
    GameState.set(GameState.MENU)
  end)
  quitBtn:setPosition(screenW / 2 - quitBtn.size.w / 2, screenH / 2 + 40)
  self.buttons[#self.buttons + 1] = quitBtn

  UIManager:setButtons(self.buttons)
end

function PauseMenu:mousepressed(x, y, button)
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      UIManager:setButtons(self.buttons)
      return true
    end
  end
  return false
end

function PauseMenu:mousemoved(x, y, dx, dy)
  for _, btn in ipairs(self.buttons) do
    btn:mousemoved(x, y, dx, dy)
  end
end

function PauseMenu:mousereleased(x, y, button)
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
end

function PauseMenu:keypressed(key)
  if key == "escape" or key == "p" then
    GameState.set(GameState.PLAYING)
  else
    UIManager:keypressed(key)
  end
end

function PauseMenu:update(dt)
end

function PauseMenu:draw()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  love.graphics.setColor(common.unwrap(common.Color(0, 0, 0, 150)))
  love.graphics.rectangle("fill", 0, 0, screenW, screenH)

  love.graphics.setFont(assets.FONT)
  love.graphics.setColor(common.unwrap(common.Color(255, 255, 255, 255)))
  love.graphics.printf(self.title, 0, screenH / 2 - 120, screenW, "center")

  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end
end

return PauseMenu