-- [[
-- A ChessPieceBehaviour is responsible fo returning a list of possible moves for a piece
-- Should be an inherited class
-- ]]

ChessPieceBehaviour = {}

function ChessPieceBehaviour:new(piece)
  local instance =  {}
  instance.piece = piece
  setmetatable(instance,self)
  self.__index = self
  return instance
  
end

-- Shoudl return an ordered list of axis which are an ordered list of possible moves
-- For example a rook can move on four axis
-- Each axis as a list of possible moves
-- The sub lists shoould be ordered so that for pieces moving straight for example like a rook
-- If there are 4 possible moves in a straight axis but a pieces blocks him at the second position, all moves after should be considered as invalid
-- It should not include out of bound (outside of the grid move)
-- A move wwill be defined as a table of the final grid position {x,y}
function ChessPieceBehaviour:possibleMoves(grid_coord) end
-- Is respponsibl now for eliminating invalid moves
function ChessPieceBehaviour:validMoves(grid, possible_moves) end

function ChessPieceBehaviour:getMoves(grid)
  local possible_moves = self:possibleMoves(self.piece.grid_coordinates)
  return self:validMoves(grid, possible_moves)
end

return ChessPieceBehaviour
