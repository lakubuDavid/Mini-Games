-- Save/Load Menu UI Component
-- Provides UI for saving and loading chess games using FEN notation
local SaveLoadMenu = {}

function SaveLoadMenu:new()
  local instance = {
    visible = false,
    mode = nil, -- "save" or "load"
    selectedFile = nil,
    inputText = "",
    saveSlots = {},
    scrollOffset = 0,
    maxVisibleSlots = 5,
    callbacks = {
      onSave = nil,      -- Called when save slot selected: function(slotNumber, grid, turn)
      onLoad = nil,      -- Called when load slot selected: function(slotNumber, grid, turn)
      onCancel = nil     -- Called when menu closed
    }
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function SaveLoadMenu:setSaveCallback(callback)
  self.callbacks.onSave = callback
end

function SaveLoadMenu:setLoadCallback(callback)
  self.callbacks.onLoad = callback
end

function SaveLoadMenu:setCancelCallback(callback)
  self.callbacks.onCancel = callback
end

function SaveLoadMenu:loadSaveSlots()
  -- Load available save files
  self.saveSlots = {}
  for i = 1, 10 do
    local exists = love.filesystem.getInfo("saves/game_" .. i .. ".fen") ~= nil
    table.insert(self.saveSlots, {
      slot = i,
      name = exists and ("Game " .. i) or "[Empty]",
      exists = exists
    })
  end
end

function SaveLoadMenu:showSaveDialog()
  self.visible = true
  self.mode = "save"
  self.inputText = ""
  self:loadSaveSlots()
end

function SaveLoadMenu:showLoadDialog()
  self.visible = true
  self.mode = "load"
  self:loadSaveSlots()
end

function SaveLoadMenu:hide()
  self.visible = false
  if self.callbacks.onCancel then
    self.callbacks.onCancel()
  end
end

function SaveLoadMenu:saveGameToSlot(grid, turn, slotNumber)
  -- Ensure saves directory exists
  love.filesystem.createDirectory("saves")
  print("saving to slot",slotNumber)
  
  local filename = "saves/game_" .. slotNumber .. ".fen"
  local Saves = require("saves")
  
  -- Convert grid to FEN and save (including turn)
  local fen = Saves.gridToFEN(grid, turn)
  love.filesystem.write(filename, fen)
  
  print("[SaveLoadMenu] Game saved to " .. filename)
end

function SaveLoadMenu:loadGameFromSlot(slotNumber)
  local filename = "saves/game_" .. slotNumber .. ".fen"
  
  -- Check if file exists
  if not love.filesystem.getInfo(filename) then
    print("[SaveLoadMenu] File not found: " .. filename)
    return nil, nil
  end
  
  -- Load FEN and convert to grid
  local Saves = require("saves")
  local fen = love.filesystem.read(filename)
  local grid, turn = Saves.gridFromFEN(fen)
  
  print("[SaveLoadMenu] Game loaded from " .. filename)
  return grid, turn
end

function SaveLoadMenu:mousepressed(x, y, button)
  if not self.visible then
    return
  end
  
  -- Dialog position
  local dialogWidth = 400
  local dialogHeight = 500
  local dialogX = (love.graphics.getWidth() - dialogWidth) / 2
  local dialogY = (love.graphics.getHeight() - dialogHeight) / 2
  
  -- Check if click is within dialog
  if x < dialogX or x > dialogX + dialogWidth or y < dialogY or y > dialogY + dialogHeight then
    self:hide()
    return
  end
  
  -- Calculate which slot was clicked (if any)
  local slotY = dialogY + 120
  local slotClickRadius = 30
  
  for i = 1, math.min(5, #self.saveSlots) do
    if y >= slotY and y < slotY + slotClickRadius then
      local slot = self.saveSlots[i]
      if self.mode == "save" then
        -- Trigger save callback with slot number (will be passed grid and turn from game.lua)
        if self.callbacks.onSave then
          self.callbacks.onSave(slot.slot)
        end
      elseif self.mode == "load" and slot.exists then
        -- Load and trigger callback with grid and turn
        local grid, turn = self:loadGameFromSlot(slot.slot)
        if grid and self.callbacks.onLoad then
          self.callbacks.onLoad(slot.slot, grid, turn)
        end
      end
      self:hide()
      return
    end
    slotY = slotY + 30
  end
end

function SaveLoadMenu:update(dt)
  -- Animation/state updates if needed
end

function SaveLoadMenu:draw()
  if not self.visible then
    return
  end
  
  -- Draw semi-transparent background
  love.graphics.setColor(0, 0, 0, 0.7)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(1, 1, 1, 1)
  
  -- Draw dialog box
  local dialogWidth = 400
  local dialogHeight = 500
  local dialogX = (love.graphics.getWidth() - dialogWidth) / 2
  local dialogY = (love.graphics.getHeight() - dialogHeight) / 2
  
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.rectangle("fill", dialogX, dialogY, dialogWidth, dialogHeight)
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.rectangle("line", dialogX, dialogY, dialogWidth, dialogHeight)
  
  -- Draw title
  love.graphics.setColor(1, 1, 1)
  local title = self.mode == "save" and "Save Game" or "Load Game"
  love.graphics.printf(title, dialogX, dialogY + 20, dialogWidth, "center")
  
  -- Draw save slots or input
  if self.mode == "save" then
    self:_drawSaveDialog(dialogX, dialogY, dialogWidth, dialogHeight)
  else
    self:_drawLoadDialog(dialogX, dialogY, dialogWidth, dialogHeight)
  end
end

function SaveLoadMenu:_drawSaveDialog(x, y, w, h)
  -- Draw instruction
  love.graphics.printf("Click a slot to save your game:", x + 20, y + 70, w - 40, "left")
  
  -- Draw slot list (simplified)
  local slotY = y + 120
  for i = 1, math.min(5, #self.saveSlots) do
    local slot = self.saveSlots[i]
    local slotText = "Slot " .. i .. ": " .. slot.name
    love.graphics.printf(slotText, x + 30, slotY, w - 60, "left")
    slotY = slotY + 30
  end
  
  -- Draw buttons
  love.graphics.printf("Press ESC to cancel", x + 20, y + h - 40, w - 40, "center")
end

function SaveLoadMenu:_drawLoadDialog(x, y, w, h)
  -- Draw instruction
  love.graphics.printf("Click a slot to load your game:", x + 20, y + 70, w - 40, "left")
  
  -- Draw slot list
  local slotY = y + 120
  for i = 1, math.min(5, #self.saveSlots) do
    local slot = self.saveSlots[i]
    if slot.exists then
      local slotText = "Slot " .. i .. ": " .. slot.name
      love.graphics.printf(slotText, x + 30, slotY, w - 60, "left")
      slotY = slotY + 30
    end
  end
  
  -- Draw instructions
  love.graphics.printf("Press ESC to cancel", x + 20, y + h - 40, w - 40, "center")
end

return SaveLoadMenu
