-- [[
-- Behaviour Registry
-- Maps piece types to their behaviour modules
-- ]]

local BehaviourRegistry = {
  pawn = require("behaviours.pawn"),
  rook = require("behaviours.rook"),
  knight = require("behaviours.knight"),
  bishop = require("behaviours.bishop"),
  queen = require("behaviours.queen"),
  king = require("behaviours.king")
}

function BehaviourRegistry.create(piece, board)
  local behaviourClass = BehaviourRegistry[piece.type]
  if behaviourClass then
    if piece.type == "pawn" and board then
      return behaviourClass:new(piece, board)
    end
    return behaviourClass:new(piece)
  end
  return nil
end

return BehaviourRegistry