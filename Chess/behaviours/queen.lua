-- [[
-- Queen Moves
-- ]]

local Base = require("behaviours.base")

local QueenBehaviour = Base:new()

function QueenBehaviour:new(piece)
  local instance = Base:new(piece)

  setmetatable(instance, self)
  self.__index = self
  return instance
end

function QueenBehaviour:possibleMoves(grid_coord)
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

  local function addDiagonalMoves(colOffset, rowOffset)
    local moves = {}
    local c = grid_coord.col + colOffset
    local r = grid_coord.row + rowOffset
    while c >= 1 and c <= 8 and r >= 1 and r <= 8 do
      moves[#moves + 1] = { col = c, row = r }
      c = c + colOffset
      r = r + rowOffset
    end
    return moves
  end

  axis[#axis + 1] = addDiagonalMoves(1, -1)
  axis[#axis + 1] = addDiagonalMoves(1, 1)
  axis[#axis + 1] = addDiagonalMoves(-1, -1)
  axis[#axis + 1] = addDiagonalMoves(-1, 1)

  return axis
end

function QueenBehaviour:validMoves(grid, possible_moves)
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

return QueenBehaviour