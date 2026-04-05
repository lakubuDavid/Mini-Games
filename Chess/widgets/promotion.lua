local Button = require("widgets.button")
local common = require("lib.common")

PromotionUI = {
  visible = false,
  position = { x = 0, y = 0 },
  promotingPawn = nil,
  promotionRow = 0,
  buttons = {},
  backgroundColor = common.Color(0, 0, 0, 150)
}

function PromotionUI:new()
  local instance = {
    visible = false,
    position = { x = 0, y = 0 },
    promotingPawn = nil,
    promotionRow = 0,
    buttons = {},
    backgroundColor = common.Color(0, 0, 0, 150)
  }
  setmetatable(instance, self)
  self.__index = self
  return instance
end

function PromotionUI:show(pawn, row, boardOffset, cellSize)
  self.visible = true
  self.promotingPawn = pawn
  self.promotionRow = row

  self.buttons = {}

  local pieceTypes = { "queen", "rook", "bishop", "knight" }
  local buttonWidth = 80
  local buttonHeight = 40
  local totalWidth = #pieceTypes * buttonWidth
  local startX = boardOffset.x + (pawn.grid_coordinates.col - 1) * cellSize - totalWidth / 2 + cellSize / 2
  local startY = boardOffset.y + (row - 1) * cellSize

  for i, pieceType in ipairs(pieceTypes) do
    local btn = Button:new(pieceType, function()
      self:promote(pieceType)
    end)
    btn:setPosition(startX + (i - 1) * buttonWidth, startY)
    btn.backgroundColor = common.Color(255, 255, 255, 255)
    self.buttons[#self.buttons + 1] = btn
  end
end

function PromotionUI:promote(pieceType)
  if not self.promotingPawn then
    return
  end

  local BehaviourRegistry = require("behaviours.registry")

  self.promotingPawn.type = pieceType
  self.promotingPawn.quad = nil

  local quads = require("pieces.piece").getQuadsForSide(self.promotingPawn.side)
  self.promotingPawn.quad = quads[pieceType]

  local board = self.promotingPawn.behaviour and self.promotingPawn.behaviour.board or nil
  self.promotingPawn.behaviour = BehaviourRegistry.create(self.promotingPawn, board)

  print("Promoted to: " .. pieceType)
  require("lib.knife.event").dispatch("pawnPromoted", self.promotingPawn, pieceType)

  self:hide()
end

function PromotionUI:hide()
  self.visible = false
  self.promotingPawn = nil
  self.buttons = {}
end

function PromotionUI:mousepressed(x, y, button)
  if not self.visible then
    return false
  end
  for _, btn in ipairs(self.buttons) do
    if btn:mousepressed(x, y, button) then
      return true
    end
  end
  return false
end

function PromotionUI:mousemoved(x, y, dx, dy)
  if not self.visible then
    return
  end
  for _, btn in ipairs(self.buttons) do
    btn:mousemoved(x, y, dx, dy)
  end
end

function PromotionUI:mousereleased(x, y, button)
  if not self.visible then
    return
  end
  for _, btn in ipairs(self.buttons) do
    btn:mousereleased(x, y, button)
  end
end

function PromotionUI:draw()
  if not self.visible then
    return
  end

  love.graphics.setColor(common.unwrap(self.backgroundColor))
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  for _, btn in ipairs(self.buttons) do
    btn:draw()
  end
end

return PromotionUI