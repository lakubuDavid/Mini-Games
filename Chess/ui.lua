local assets = require("assets")
local common = require("lib.common")
local Event = require("lib.knife.event")

local UI = {
  captured_pieces = {
    white = {},
    black = {}
  },
  current_turn = "white",
  text_color = common.Colors.WHITE
}

function UI:new(copy)
  instance = copy or {}
  setmetatable(instance, self)
  self.__index = UI
  return instance
end

function UI:init()
  self.captured_pieces = {
    white = {},
    black = {}
  }
  self.current_turn = "white"

  Event.on("turnChanged", function(newTurn, oldTurn)
    self.current_turn = newTurn
  end)

  Event.on("pieceCaptured", function(side, pieceType)
    table.insert(self.captured_pieces[side], pieceType)
  end)
end

function UI:draw()
  love.graphics.setFont(assets.FONT)

  love.graphics.setColor(common.colors.unwrap(self.text_color))
  love.graphics.print("Turn: " .. self.current_turn, 10, 10)

  local captured_y = 40
  love.graphics.print("Captured by White:", 10, captured_y)
  local captured_black_y = captured_y + 20
  for i, piece in ipairs(self.captured_pieces.black) do
    love.graphics.print(piece, 10 + (i - 1) * 60, captured_black_y)
  end

  local captured_by_white_y = captured_black_y + 30
  love.graphics.print("Captured by Black:", 10, captured_by_white_y)
  local captured_white_y = captured_by_white_y + 20
  for i, piece in ipairs(self.captured_pieces.white) do
    love.graphics.print(piece, 10 + (i - 1) * 60, captured_white_y)
  end

  love.graphics.setColor(1, 1, 1, 1)
end

function UI:update(dt)
end

return UI
