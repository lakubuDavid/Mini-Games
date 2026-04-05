-- [[
-- Board Movement Tests
-- Tests that pieces are moved properly on the board
-- ]]

if not love then
  love = {
    graphics = {
      newQuad = function() return {} end,
      newImage = function() return {} end
    }
  }
end

local assets = require("assets")
assets.loadAssets()
local TestRunner = require("tests.test_runner")
local Board = require("board")

local runner = TestRunner:new()

runner:test("Board initializes with 32 pieces", function()
  local board = Board:new()
  board:init()
  assert(#board.pieces == 32, "Expected 32 pieces, got " .. #board.pieces)
end)

runner:test("Board grid has pieces at correct starting positions", function()
  local board = Board:new()
  board:init()
  
  for col = 1, 8 do
    local piece = board.grid[2][col]
    assert(piece ~= nil, "Expected piece at row 2, col " .. col)
    assert(piece.type == "pawn", "Expected pawn")
    assert(piece.side == "white", "Expected white piece")
  end
  
  for col = 1, 8 do
    local piece = board.grid[7][col]
    assert(piece ~= nil, "Expected piece at row 7, col " .. col)
    assert(piece.type == "pawn", "Expected pawn")
    assert(piece.side == "black", "Expected black piece")
  end
end)

runner:test("Pawn can move forward and update grid", function()
  local board = Board:new()
  board:init()
  
  local pawn = board.grid[2][1]
  assert(pawn ~= nil, "Pawn should exist at a2")
  
  local from = { row = 2, col = 1 }
  local to = { row = 3, col = 1 }
  
  local result = board:movePiece(from, to)
  assert(result == true, "Move should succeed")
  
  assert(board.grid[2][1] == nil, "Old position should be empty")
  assert(board.grid[3][1] == pawn, "New position should have the pawn")
  assert(pawn.grid_coordinates.row == 3, "Pawn row should be updated")
  assert(pawn.grid_coordinates.col == 1, "Pawn col should be unchanged")
end)

runner:test("Invalid move is rejected", function()
  local board = Board:new()
  board:init()
  
  local pawn = board.grid[2][1]
  
  local from = { row = 2, col = 1 }
  local to = { row = 8, col = 8 }
  
  local result = board:movePiece(from, to)
  assert(result == false, "Invalid move should be rejected")
  
  assert(board.grid[2][1] == pawn, "Pawn should still be at original position")
end)

runner:test("Move to out of bounds is rejected", function()
  local board = Board:new()
  board:init()
  
  local pawn = board.grid[2][1]
  
  local from = { row = 2, col = 1 }
  local to = { row = 0, col = 1 }
  
  local result = board:movePiece(from, to)
  assert(result == false, "Out of bounds move should be rejected")
  
  assert(board.grid[2][1] == pawn, "Pawn should still be at original position")
end)

runner:test("isValidMove returns true for valid moves", function()
  local board = Board:new()
  board:init()
  
  local pawn = board.grid[2][1]
  
  assert(board:isValidMove(pawn, 3, 1) == true, "Forward move should be valid")
  assert(board:isValidMove(pawn, 4, 1) == true, "Double forward should be valid")
end)

runner:test("isValidMove returns false for invalid moves", function()
  local board = Board:new()
  board:init()
  
  local pawn = board.grid[2][1]
  
  assert(board:isValidMove(pawn, 8, 8) == false, "Invalid move should return false")
  assert(board:isValidMove(pawn, 1, 1) == false, "Backward move should be invalid")
end)

print("")
print("=== Board Movement Tests ===")
print("")
runner:run()

return runner