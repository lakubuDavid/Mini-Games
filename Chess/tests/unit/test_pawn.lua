-- [[
-- Pawn Unit Tests
-- ]]

local TestRunner = require("tests.test_runner")
local PawnBehaviour = require("behaviours.pawn")

local function createMockPiece(side, gridPos)
  return {
    side = side,
    type = "pawn",
    gridPos = gridPos,
    grid_coordinates = { col = 1, row = 1 }
  }
end

local function createEmptyGrid()
  local grid = {}
  for row = 1, 8 do
    grid[row] = {}
    for col = 1, 8 do
      grid[row][col] = nil
    end
  end
  return grid
end

local function setGridPiece(grid, col, row, piece)
  grid[row][col] = piece
end

local runner = TestRunner:new()

-- Test: White pawn forward movement
runner:test("White pawn at row 2 can move forward 1 square", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  assert(#valid >= 1, "Expected at least 1 move")
  local found = false
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 3 then found = true end
  end
  assert(found, "Expected move to row 3")
end)

runner:test("White pawn at row 2 can move forward 2 squares", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundSingle = false
  local foundDouble = false
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 3 then foundSingle = true end
    if m.col == 1 and m.row == 4 then foundDouble = true end
  end
  assert(foundSingle, "Expected move to row 3")
  assert(foundDouble, "Expected double move to row 4")
end)

runner:test("White pawn cannot move backward", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundBackward = false
  for _, m in ipairs(valid) do
    if m.row < 2 then foundBackward = true end
  end
  assert(not foundBackward, "Should not move backward")
end)

-- Test: Black pawn forward movement
runner:test("Black pawn at row 7 can move forward 1 square", function()
  local piece = createMockPiece("black", "a7")
  piece.grid_coordinates = { col = 1, row = 7 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local found = false
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 6 then found = true end
  end
  assert(found, "Expected move to row 6")
end)

runner:test("Black pawn at row 7 can move forward 2 squares", function()
  local piece = createMockPiece("black", "a7")
  piece.grid_coordinates = { col = 1, row = 7 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundSingle = false
  local foundDouble = false
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 6 then foundSingle = true end
    if m.col == 1 and m.row == 5 then foundDouble = true end
  end
  assert(foundSingle, "Expected move to row 6")
  assert(foundDouble, "Expected double move to row 5")
end)

runner:test("Black pawn at row 6 can only move 1 square", function()
  local piece = createMockPiece("black", "a6")
  piece.grid_coordinates = { col = 1, row = 6 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  assert(#valid == 1, "Should only have 1 valid move (not first move)")
  assert(valid[1].row == 5, "Should only move to row 5")
end)

-- Test: Pawn blocking
runner:test("White pawn blocked by piece cannot move forward", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local blocker = createMockPiece("black", "a3")
  setGridPiece(grid, 1, 3, blocker)
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local blocked = true
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 3 then blocked = false end
  end
  assert(blocked, "Forward move should be blocked")
end)

-- Test: Pawn captures
runner:test("White pawn can capture enemy to the right", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local enemy = createMockPiece("black", "b3")
  setGridPiece(grid, 2, 3, enemy)
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundCapture = false
  for _, m in ipairs(valid) do
    if m.col == 2 and m.row == 3 then foundCapture = true end
  end
  assert(foundCapture, "Should be able to capture at b3")
end)

runner:test("White pawn can capture enemy to the left", function()
  local piece = createMockPiece("white", "b2")
  piece.grid_coordinates = { col = 2, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local enemy = createMockPiece("black", "a3")
  setGridPiece(grid, 1, 3, enemy)
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundCapture = false
  for _, m in ipairs(valid) do
    if m.col == 1 and m.row == 3 then foundCapture = true end
  end
  assert(foundCapture, "Should be able to capture at a3")
end)

runner:test("White pawn cannot capture own piece", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local friend = createMockPiece("white", "b3")
  setGridPiece(grid, 2, 3, friend)
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundCapture = false
  for _, m in ipairs(valid) do
    if m.col == 2 and m.row == 3 then foundCapture = true end
  end
  assert(not foundCapture, "Should not capture own piece")
end)

-- Test: Non-first-move pawn
runner:test("White pawn at row 3 can only move 1 square", function()
  local piece = createMockPiece("white", "a3")
  piece.grid_coordinates = { col = 1, row = 3 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  assert(#valid == 1, "Should only have 1 valid move (not first move)")
  assert(valid[1].row == 4, "Should only move to row 4")
end)

-- Test: Edge cases
runner:test("White pawn at row 8 cannot move forward", function()
  local piece = createMockPiece("white", "a8")
  piece.grid_coordinates = { col = 1, row = 8 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  assert(#valid == 0, "Pawn at edge should have no moves")
end)

runner:test("Black pawn at row 1 cannot move forward", function()
  local piece = createMockPiece("black", "a1")
  piece.grid_coordinates = { col = 1, row = 1 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  assert(#valid == 0, "Pawn at edge should have no moves")
end)

runner:test("Pawn cannot move diagonally to empty square", function()
  local piece = createMockPiece("white", "a2")
  piece.grid_coordinates = { col = 1, row = 2 }
  local behaviour = PawnBehaviour:new(piece)
  local grid = createEmptyGrid()
  
  local possible = behaviour:possibleMoves(piece.grid_coordinates)
  local valid = behaviour:validMoves(grid, possible)
  
  local foundDiag = false
  for _, m in ipairs(valid) do
    if m.col ~= 1 then foundDiag = true end
  end
  assert(not foundDiag, "Should not move diagonally to empty square")
end)

print("=== Pawn Behaviour Tests ===")
print("")
runner:run()

return runner