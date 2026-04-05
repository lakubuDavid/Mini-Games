-- [[
-- Knight Moves
-- ]]

local Base = require("behaviours.base")

local KnightBehaviour = Base:new()

function KnightBehaviour:new(piece)
  local instance = Base:new(piece)

  setmetatable(instance, self)
  self.__index = self
  return instance
end

function KnightBehaviour:possibleMoves(grid_coord)
  local moves = {}

  local offsets = {
    { col = 2, row = -1 }, { col = 2, row = 1 },
    { col = -2, row = -1 }, { col = -2, row = 1 },
    { col = 1, row = -2 }, { col = 1, row = 2 },
    { col = -1, row = -2 }, { col = -1, row = 2 }
  }

  for _, offset in ipairs(offsets) do
    local newCol = grid_coord.col + offset.col
    local newRow = grid_coord.row + offset.row
    if newCol >= 1 and newCol <= 8 and newRow >= 1 and newRow <= 8 then
      moves[#moves + 1] = { col = newCol, row = newRow }
    end
  end

  return { moves }
end

function KnightBehaviour:validMoves(grid, possible_moves)
  local validMoves = {}
  local moves = possible_moves[1]

  for _, move in ipairs(moves) do
    local pieceAtTarget = grid[move.row] and grid[move.row][move.col]
    if not pieceAtTarget or pieceAtTarget.side ~= self.piece.side then
      validMoves[#validMoves + 1] = move
    end
  end

  return validMoves
end

return KnightBehaviour