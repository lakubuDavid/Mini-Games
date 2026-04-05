-- [[
-- King Moves
-- ]]

local Base = require("behaviours.base")

local KingBehaviour = Base:new()

KingBehaviour.CASTLING_ROW = {
  white = 1,
  black = 8
}

KingBehaviour.CASTLING_KING_POS = {
  white = { col = 5, row = 1 },
  black = { col = 5, row = 8 }
}

function KingBehaviour:new(piece, board)
  local instance = Base:new(piece)

  instance.board = board
  instance.castleRow = KingBehaviour.CASTLING_ROW[piece.side]
  instance.kingStartPos = KingBehaviour.CASTLING_KING_POS[piece.side]

  setmetatable(instance, self)
  self.__index = self
  return instance
end

function KingBehaviour:possibleMoves(grid_coord)
  local moves = {}

  local offsets = {
    { col = 0, row = -1 }, { col = 1, row = -1 }, { col = 1, row = 0 },
    { col = 1, row = 1 }, { col = 0, row = 1 }, { col = -1, row = 1 },
    { col = -1, row = 0 }, { col = -1, row = -1 }
  }

  for _, offset in ipairs(offsets) do
    local newCol = grid_coord.col + offset.col
    local newRow = grid_coord.row + offset.row
    if newCol >= 1 and newCol <= 8 and newRow >= 1 and newRow <= 8 then
      moves[#moves + 1] = { col = newCol, row = newRow }
    end
  end

  if self.board and grid_coord.col == self.kingStartPos.col and grid_coord.row == self.castleRow then
    if not self.piece.hasMoved then
      local rookLeft = self.board.grid[self.castleRow] and self.board.grid[self.castleRow][1]
      if rookLeft and rookLeft.type == "rook" and not rookLeft.hasMoved then
        local clearLeft = true
        for c = 2, 4 do
          if self.board.grid[self.castleRow][c] then
            clearLeft = false
            break
          end
        end
        if clearLeft then
          moves[#moves + 1] = { col = 3, row = self.castleRow, isCastling = true, castlingType = "queen" }
        end
      end

      local rookRight = self.board.grid[self.castleRow] and self.board.grid[self.castleRow][8]
      if rookRight and rookRight.type == "rook" and not rookRight.hasMoved then
        local clearRight = true
        for c = 6, 7 do
          if self.board.grid[self.castleRow][c] then
            clearRight = false
            break
          end
        end
        if clearRight then
          moves[#moves + 1] = { col = 7, row = self.castleRow, isCastling = true, castlingType = "king" }
        end
      end
    end
  end

  return { moves }
end

function KingBehaviour:validMoves(grid, possible_moves)
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

return KingBehaviour