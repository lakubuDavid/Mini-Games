-- [[
-- Game
-- ]]

local assets = require("assets")
local Board = require("board")
local UI = require("ui")
local GameState = require("gamestate")
local Saves = require("saves")
local SaveLoadMenu = require("widgets.saveload")
local luis = require("luis.init")("luis/widgets")
local Event = require("lib.knife.event")

Game = {
  board = nil,
  ui = nil,
  pieces = {},
  whose_turn = "w",
  saveLoadMenu = nil
}

function Game:new(copy)
  instance = copy or {}
  setmetatable(instance, self)
  self.__index = Game
  return instance
end

function Game.init(self)
  assets.loadAssets()

  luis.baseWidth = love.graphics.getWidth()
  luis.baseHeight = love.graphics.getHeight()
  luis.updateScale()

  self.board = Board:new()
  self.board:init()

  self.ui = UI:new()
  self.ui:init()

  self.saveLoadMenu = SaveLoadMenu:new()
  self:_setupSaveLoadCallbacks()

  self:createMainMenu()
  Event.on("turnChanged", function(newTurn, oldTurn)
    self.whose_turn = newTurn
  end)
end

function Game:createMainMenu()
   if luis.layerExists("menu") then
     luis.removeLayer("menu")
   end
   
   luis.newLayer("menu")
   luis.setCurrentLayer("menu")
  
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()
  local centerX = math.floor(screenW / 2 / luis.gridSize)
  local centerY = math.floor(screenH / 2 / luis.gridSize)

   local titleLabel = luis.newLabel("Chess", 15, 4, centerY - 10, centerX - 7, "center")
   luis.createElement("menu", "Label", titleLabel)

   local playBtn = luis.newButton("Play", 5, 2, function()
     local screenW = love.graphics.getWidth()
     local screenH = love.graphics.getHeight()
     local boardSize = self.board:getSize()
     local offsetX = (screenW - boardSize.w) / 2
     local offsetY = (screenH - boardSize.h) / 2
     self.board:setOffset(offsetX, offsetY)
     GameState.set(GameState.PLAYING)
   end, nil, centerY - 3, centerX - 2)
   luis.createElement("menu", "Button", playBtn)

   local themeBtn = luis.newButton("Themes", 5, 2, function()
     self:createThemeSelection()
   end, nil, centerY + 1, centerX - 2)
   luis.createElement("menu", "Button", themeBtn)

   local quitBtn = luis.newButton("Quit", 5, 2, function()
     love.event.quit()
   end, nil, centerY + 5, centerX - 2)
   luis.createElement("menu", "Button", quitBtn)
end

function Game:createPauseMenu()
    if luis.layerExists("pause") then
      luis.removeLayer("pause")
    end
    
    luis.newLayer("pause")
    luis.setCurrentLayer("pause")
   
   local screenW = love.graphics.getWidth()
   local screenH = love.graphics.getHeight()
   local centerX = math.floor(screenW / 2 / luis.gridSize)
   local centerY = math.floor(screenH / 2 / luis.gridSize)

    local titleLabel = luis.newLabel("Paused", 10, 4, centerY - 10, centerX - 5, "center")
    luis.createElement("pause", "Label", titleLabel)

    local resumeBtn = luis.newButton("Resume", 5, 2, function()
      luis.removeLayer("pause")
      GameState.set(GameState.PLAYING)
    end, nil, centerY - 3, centerX - 2)
    luis.createElement("pause", "Button", resumeBtn)

    local saveBtn = luis.newButton("Save Game", 5, 2, function()
      self.saveLoadMenu:showSaveDialog()
    end, nil, centerY + 1, centerX - 2)
    luis.createElement("pause", "Button", saveBtn)

    local loadBtn = luis.newButton("Load Game", 5, 2, function()
      self.saveLoadMenu:showLoadDialog()
    end, nil, centerY + 5, centerX - 2)
    luis.createElement("pause", "Button", loadBtn)

    local menuBtn = luis.newButton("Main Menu", 5, 2, function()
      luis.removeLayer("pause")
      self:createMainMenu()
      GameState.set(GameState.MENU)
    end, nil, centerY + 9, centerX - 2)
    luis.createElement("pause", "Button", menuBtn)
end

function Game:createThemeSelection()
  if luis.layerExists("menu") then
    luis.removeLayer("menu")
  end
  
  luis.newLayer("themes")
  luis.setCurrentLayer("themes")
  
  local screenW = love.graphics.getWidth()
  local screenH = love.graphics.getHeight()
  local centerX = math.floor(screenW / 2 / luis.gridSize)
  local centerY = math.floor(screenH / 2 / luis.gridSize)

   local boardLabel = luis.newLabel("Select Board", 12, 2, centerY - 12, centerX - 6, "center")
   luis.createElement("themes", "Label", boardLabel)

   local startX = centerX - 10
   local startY = centerY - 8

   for i, board in ipairs(assets.AVAILABLE_BOARDS) do
     local btn = luis.newButton(board.name, 4, 1.5, function()
       assets.setBoard(i)
     end, nil, startY + math.floor((i - 1) / 5) * 2, startX + ((i - 1) % 5) * 5)
     if i == assets.currentBoard then
       btn:setColor({0.2, 0.8, 0.2, 1})
     end
     luis.createElement("themes", "Button", btn)
   end

   local piecesLabel = luis.newLabel("Select Pieces", 12, 2, centerY + 1, centerX - 6, "center")
   luis.createElement("themes", "Label", piecesLabel)

   local pieceStartY = centerY + 4
   for i, pieces in ipairs(assets.AVAILABLE_PIECES) do
     local btn = luis.newButton(pieces.name, 5, 1.5, function()
       assets.setPieces(i)
     end, nil, pieceStartY + math.floor((i - 1) / 2) * 2, startX + ((i - 1) % 2) * 7)
     if i == assets.currentPieces then
       btn:setColor({0.2, 0.8, 0.2, 1})
     end
     luis.createElement("themes", "Button", btn)
   end

   local backBtn = luis.newButton("Back", 4, 2, function()
     luis.removeLayer("themes")
     self:createMainMenu()
     GameState.set(GameState.MENU)
   end, nil, centerY + 14, centerX - 2)
   luis.createElement("themes", "Button", backBtn)
end

function Game.update(self, dt)
  luis.update(dt)

  if GameState.is(GameState.PLAYING) then
    self.board:update(dt)
    self.ui:update(dt)
  end
end

function Game.resize(self, w, h)
  luis.baseWidth = w
  luis.baseHeight = h
  luis.updateScale()
  
  if GameState.is(GameState.PLAYING) then
    local board_size = self.board:getSize()
    local offsetX = (w - board_size.w) / 2
    local offsetY = (h - board_size.h) / 2
    self.board:setOffset(offsetX, offsetY)
  end
end

function Game.mousepressed(self, x, y, button)
  -- Handle save/load menu if visible
  if self.saveLoadMenu and self.saveLoadMenu.visible then
    self.saveLoadMenu:mousepressed(x, y, button)
    return
  end

  if GameState.is(GameState.PLAYING) then
    if button == 2 then
      self:createPauseMenu()
      GameState.set(GameState.PAUSED)
      return
    end
    self.board:mousepressed(x, y, button)
  else
    luis.mousepressed(x, y, button)
  end
end

function Game.mousereleased(self, x, y, button)
  if GameState.is(GameState.PLAYING) then
    self.board:mousereleased(x, y, button)
  else
    luis.mousereleased(x, y, button)
  end
end

function Game.mousemoved(self, x, y, dx, dy)
  if GameState.is(GameState.PLAYING) then
    self.board:mousemoved(x, y, dx, dy)
  end
  if luis.mousemoved then
    luis.mousemoved(x, y, dx, dy)
  end
end

function Game.keypressed(self, key)
  luis.keypressed(key)

  -- Handle save/load menu escape key
  if self.saveLoadMenu and self.saveLoadMenu.visible then
    if key == "escape" then
      self.saveLoadMenu:hide()
    end
    return
  end
  
  if GameState.is(GameState.PLAYING) then
    if key == "escape" or key == "p" then
      self:createPauseMenu()
      GameState.set(GameState.PAUSED)
    end
  end
end

function Game:_setupSaveLoadCallbacks()
  self.saveLoadMenu:setSaveCallback(function(slotNumber)
    print("[Game] Saving game to slot " , slotNumber)
    -- Convert board grid to saveable grid format
    local saveGrid = {}
    for row = 1, 8 do
      saveGrid[row] = {}
      for col = 1, 8 do
        local piece = self.board.grid[row][col]
        if piece then
          saveGrid[row][col] = {
            type = piece.type,
            side = piece.side
          }
        else
          saveGrid[row][col] = nil
        end
      end
    end
    -- Save using SaveLoadMenu's save function
    print("sllot",slotNumber)
    self.saveLoadMenu:saveGameToSlot(saveGrid,self.whose_turn, slotNumber)
    print("[Game] Game saved successfully to slot " .. slotNumber)
  end)

  self.saveLoadMenu:setLoadCallback(function(slotNumber, grid)
    print("[Game] Loading game from slot " .. slotNumber)
    if grid then
      -- Reset board with loaded grid
      self.board:reset()
      self.board:init(grid)
      print("[Game] Game loaded and board initialized")
      GameState.set(GameState.PLAYING)
    end
  end)

  self.saveLoadMenu:setCancelCallback(function()
    print("[Game] Save/load cancelled")
  end)
end

function Game:draw()
  if GameState.is(GameState.PLAYING) then
    self.board:draw()
    self.board:drawOverlay()
    self.ui:draw()
  elseif GameState.is(GameState.PAUSED) then
    self.board:draw()
    self.board:drawOverlay()
    self.ui:draw()
    luis.draw()
  elseif GameState.is(GameState.MENU) or GameState.is(GameState.THEMES) then
    luis.draw()
  end
  
  -- Draw save/load menu on top of everything
  if self.saveLoadMenu then
    self.saveLoadMenu:draw()
  end
end

return Game
