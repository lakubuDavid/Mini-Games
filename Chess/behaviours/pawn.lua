-- [[
-- Pawn Moves
-- ]]

local Base = require("behaviours.base")

local PawnBehaviour = Base:new()

PawnBehaviour.DIRECTION = {
  white = 1,   -- white moves toward row 8 (bottom of screen)
  black = -1   -- black moves toward row 1 (top of screen)
}

PawnBehaviour.FIRST_MOVE_ROW = {
  white = 2,  -- white starts at row 2
  black = 7   -- black starts at row 7
}

PawnBehaviour.EN_PASSANT_ROW = {
  white = 5,  -- white can capture en passant when enemy pawn is on row 5
  black = 4   -- black can capture en passant when enemy pawn is on row 4
}

function PawnBehaviour:new(piece, board)
  local instance = Base:new(piece)

  instance.board = board
  instance.direction = PawnBehaviour.DIRECTION[piece.side]
  instance.firstMoveRow = PawnBehaviour.FIRST_MOVE_ROW[piece.side]
  instance.enPassantRow = PawnBehaviour.EN_PASSANT_ROW[piece.side]
  instance.isFirstMove = (piece.grid_coordinates.row == instance.firstMoveRow)

  setmetatable(instance, self)
  self.__index = self
  return instance
end

function PawnBehaviour:setFirstMove(value)
  self.isFirstMove = value
end

function PawnBehaviour:possibleMoves(grid_coord)
  local col = grid_coord.col
  local row = grid_coord.row
  local direction = self.direction

  local forwardRow = row + direction
  local captureRow = row + direction

  local forwardMoves = {}
  local captureMoves = {}

  if forwardRow >= 1 and forwardRow <= 8 then
    forwardMoves[#forwardMoves + 1] = { col = col, row = forwardRow }

    if self.isFirstMove then
      local doubleForwardRow = row + (direction * 2)
      if doubleForwardRow >= 1 and doubleForwardRow <= 8 then
        forwardMoves[#forwardMoves + 1] = { col = col, row = doubleForwardRow }
      end
    end
  end

  if captureRow >= 1 and captureRow <= 8 then
    local captureLeftCol = col - 1
    local captureRightCol = col + 1

    if captureLeftCol >= 1 then
      captureMoves[#captureMoves + 1] = { col = captureLeftCol, row = captureRow }
    end
    if captureRightCol <= 8 then
      captureMoves[#captureMoves + 1] = { col = captureRightCol, row = captureRow }
    end
  end

  if self.board and row == self.enPassantRow and self.board.lastMove then
    local lastMove = self.board.lastMove
    if lastMove.piece and lastMove.piece.type == "pawn" 
       and lastMove.piece.side ~= self.piece.side
       and lastMove.isDoublePawnPush then
      local enPassantCol = lastMove.to.col
      if enPassantCol == col - 1 or enPassantCol == col + 1 then
        captureMoves[#captureMoves + 1] = { 
          col = enPassantCol, 
          row = row + direction,
          isEnPassant = true,
          captureRow = lastMove.to.row
        }
      end
    end
  end

  return { forwardMoves, captureMoves }
end

function PawnBehaviour:validMoves(grid, possible_moves)
  local validMoves = {}

  local forwardMoves = possible_moves[1]
  local captureMoves = possible_moves[2]

  if forwardMoves then
    for _, move in ipairs(forwardMoves) do
      local pieceAtTarget = grid[move.row] and grid[move.row][move.col]
      if not pieceAtTarget then
        validMoves[#validMoves + 1] = move
      end
    end
  end

  if captureMoves then
    for _, move in ipairs(captureMoves) do
      local pieceAtTarget = grid[move.row] and grid[move.row][move.col]
      if move.isEnPassant then
        local captureRow = move.captureRow
        local pieceAtCaptureSquare = grid[captureRow] and grid[captureRow][move.col]
        if pieceAtCaptureSquare and pieceAtCaptureSquare.side ~= self.piece.side then
          validMoves[#validMoves + 1] = move
        end
      elseif pieceAtTarget and pieceAtTarget.side ~= self.piece.side then
        validMoves[#validMoves + 1] = move
      end
    end
  end

  return validMoves
end

return PawnBehaviour
