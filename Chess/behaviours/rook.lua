-- [[
-- Rook Moves
-- ]]

local Base = require("behaviours.base")

local RookBehaviour = Base:new()

function RookBehaviour:new(piece)
  local instance = Base:new(piece)

  setmetatable(instance, self)
  self.__index = self
  return instance
end

function RookBehaviour:possibleMoves(grid_coord)
  local axis = {}

  local rightMoves = {}
  for c = grid_coord.col + 1, 8 do
    rightMoves[#rightMoves + 1] = { col = c, row = grid_coord.row }
  end
  axis[#axis + 1] = rightMoves

  local leftMoves = {}
  for c = grid_coord.col - 1, 1, -1 do
    leftMoves[#leftMoves + 1] = { col = c, row = grid_coord.row }
  end
  axis[#axis + 1] = leftMoves

  local upMoves = {}
  for r = grid_coord.row - 1, 1, -1 do
    upMoves[#upMoves + 1] = { col = grid_coord.col, row = r }
  end
  axis[#axis + 1] = upMoves

  local downMoves = {}
  for r = grid_coord.row + 1, 8 do
    downMoves[#downMoves + 1] = { col = grid_coord.col, row = r }
  end
  axis[#axis + 1] = downMoves

  return axis
end

function RookBehaviour:validMoves(grid, possible_moves)
  local validMoves = {}

  for _, axis in ipairs(possible_moves) do
    for _, move in ipairs(axis) do
      local pieceAtTarget = grid[move.row] and grid[move.row][move.col]
      if not pieceAtTarget then
        validMoves[#validMoves + 1] = move
      else
        if pieceAtTarget.side ~= self.piece.side then
          validMoves[#validMoves + 1] = move
        end
        break
      end
    end
  end

  return validMoves
end

return RookBehaviour