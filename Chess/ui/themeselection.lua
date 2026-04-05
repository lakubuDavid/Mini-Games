local Button = require("widgets.button")
local common = require("lib.common")
local assets = require("assets")
local GameState = require("gamestate")
local UIManager = require("ui.uimanager")

ThemeSelection = {
  buttons = {},
  boardButtons = {},
  pieceButtons = {},
  selectionType = nil,
  allButtons = {}
}

function ThemeSelection:new()
  local instance = {
    buttons = {},
    boardButtons = {},
    pieceButtons = {},
    selectionType = nil,
    allButtons = {}
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function ThemeSelection:createButtons()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  self.boardButtons = {}
  self.pieceButtons = {}
  self.allButtons = {}

  local startX = screenW / 2 - 200
  local startY = screenH / 2 - 100

  for i, board in ipairs(assets.AVAILABLE_BOARDS) do
    local btn = Button:new(board.name, function()
      assets.setBoard(i)
    end)
    btn:setPosition(startX + ((i - 1) % 5) * 85, startY + math.floor((i - 1) / 5) * 50)
    btn.backgroundColor = i == assets.currentBoard and common.Color(100, 200, 100, 255) or common.Color(200, 200, 200, 255)
    self.boardButtons[i] = btn
    self.allButtons[#self.allButtons + 1] = btn
  end

  local pieceStartY = startY + 120
  for i, pieces in ipairs(assets.AVAILABLE_PIECES) do
    local btn = Button:new(pieces.name, function()
      assets.setPieces(i)
    end)
    btn:setPosition(startX + ((i - 1) % 2) * 120, pieceStartY + math.floor((i - 1) / 2) * 50)
    btn.backgroundColor = i == assets.currentPieces and common.Color(100, 200, 100, 255) or common.Color(200, 200, 200, 255)
    self.pieceButtons[i] = btn
    self.allButtons[#self.allButtons + 1] = btn
  end

  local backBtn = Button:new("Back", function()
    GameState.set(GameState.MENU)
  end)
  backBtn:setPosition(screenW / 2 - backBtn.size.w / 2, screenH / 2 + 200)
  self.buttons[#self.buttons + 1] = backBtn
  self.allButtons[#self.allButtons + 1] = backBtn

  UIManager:setButtons(self.allButtons)
end

function ThemeSelection:mousepressed(x, y, button)
  local handled = false
  
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      UIManager:setButtons(self.allButtons)
      handled = true
    end
  end

  for i, btn in ipairs(self.boardButtons) do
    if btn:mousepressed(x, y, button) then
      self:refreshButtonColors()
      UIManager:setButtons(self.allButtons)
      handled = true
    end
  end

  for i, btn in ipairs(self.pieceButtons) do
    if btn:mousepressed(x, y, button) then
      self:refreshButtonColors()
      UIManager:setButtons(self.allButtons)
      handled = true
    end
  end
  return handled
end

function ThemeSelection:mousemoved(x, y, dx, dy)
  for _, btn in ipairs(self.buttons) do
    btn:mousemoved(x, y, dx, dy)
  end
  for _, btn in ipairs(self.boardButtons) do
    btn:mousemoved(x, y, dx, dy)
  end
  for _, btn in ipairs(self.pieceButtons) do
    btn:mousemoved(x, y, dx, dy)
  end
end

function ThemeSelection:mousereleased(x, y, button)
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
  for _, btn in ipairs(self.boardButtons) do
    btn:mousereleased(x, y, button)
  end
  for _, btn in ipairs(self.pieceButtons) do
    btn:mousereleased(x, y, button)
  end
end

function ThemeSelection:keypressed(key)
  if key == "escape" then
    GameState.set(GameState.MENU)
  elseif key == "left" or key == "a" then
    local current = UIManager.selectedIndex
    if current > 1 then
      UIManager:moveSelection(-1)
    end
  elseif key == "right" or key == "d" then
    local current = UIManager.selectedIndex
    if current < #self.allButtons then
      UIManager:moveSelection(1)
    end
  else
    UIManager:keypressed(key)
  end
end

function ThemeSelection:refreshButtonColors()
  for i, _ in ipairs(self.boardButtons) do
    self.boardButtons[i].backgroundColor = i == assets.currentBoard and common.Color(100, 200, 100, 255) or common.Color(200, 200, 200, 255)
  end
  for i, _ in ipairs(self.pieceButtons) do
    self.pieceButtons[i].backgroundColor = i == assets.currentPieces and common.Color(100, 200, 100, 255) or common.Color(200, 200, 200, 255)
  end
end

function ThemeSelection:update(dt)
end

function ThemeSelection:draw()
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()

  love.graphics.setFont(assets.FONT)
  love.graphics.setColor(common.unwrap(common.Color(0, 0, 0, 255)))
  love.graphics.printf("Select Board", 0, screenH / 2 - 140, screenW, "center")

  for _, btn in ipairs(self.boardButtons) do
    btn:draw()
  end

  love.graphics.printf("Select Pieces", 0, screenH / 2 - 20, screenW, "center")

  for _, btn in ipairs(self.pieceButtons) do
    btn:draw()
  end

  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end
end

return ThemeSelection