-- Test file for Saves.gridToFEN function
local Saves = require("saves")

print("=== Testing Saves.gridToFEN ===\n")

-- Helper function to create an empty 8x8 grid
local function createEmptyGrid()
  local grid = {}
  for row = 1, 8 do
    table.insert(grid, {})
    for col = 1, 8 do
      table.insert(grid[row], nil)
    end
  end
  return grid
end

-- Helper function to set a piece on the grid
local function setPiece(grid, row, col, type, side)
  grid[row][col] = {
    type = type,
    side = side
  }
end

-- Helper to run a test
local function runTest(name, grid, expected)
  local result = gridToFEN(grid)
  local pass = result == expected
  print("Test: " .. name)
  print("Result:   '" .. (result or "nil") .. "'")
  print("Expected: '" .. expected .. "'")
  print("Status: " .. (pass and "✓ PASS" or "✗ FAIL") .. "\n")
  return pass
end

local passCount = 0
local testCount = 0

-- Test 1: Empty grid
testCount = testCount + 1
if runTest("Empty grid", createEmptyGrid(), "8/8/8/8/8/8/8/8") then
  passCount = passCount + 1
end

-- Test 2: Starting position
do
  local grid = createEmptyGrid()
  -- White pieces (bottom, row 8 and 7)
  setPiece(grid, 8, 1, "rook", "white")
  setPiece(grid, 8, 2, "knight", "white")
  setPiece(grid, 8, 3, "bishop", "white")
  setPiece(grid, 8, 4, "queen", "white")
  setPiece(grid, 8, 5, "king", "white")
  setPiece(grid, 8, 6, "bishop", "white")
  setPiece(grid, 8, 7, "knight", "white")
  setPiece(grid, 8, 8, "rook", "white")
  
  for col = 1, 8 do
    setPiece(grid, 7, col, "pawn", "white")
  end
  
  for col = 1, 8 do
    setPiece(grid, 2, col, "pawn", "black")
  end
  
  setPiece(grid, 1, 1, "rook", "black")
  setPiece(grid, 1, 2, "knight", "black")
  setPiece(grid, 1, 3, "bishop", "black")
  setPiece(grid, 1, 4, "queen", "black")
  setPiece(grid, 1, 5, "king", "black")
  setPiece(grid, 1, 6, "bishop", "black")
  setPiece(grid, 1, 7, "knight", "black")
  setPiece(grid, 1, 8, "rook", "black")
  
  testCount = testCount + 1
  if runTest("Starting chess position", grid, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR") then
    passCount = passCount + 1
  end
end

-- Test 3: Single white pawn on e4
do
  local grid = createEmptyGrid()
  setPiece(grid, 5, 5, "pawn", "white")
  
  testCount = testCount + 1
  if runTest("Single white pawn on e4", grid, "8/8/8/8/4P3/8/8/8") then
    passCount = passCount + 1
  end
end

-- Test 4: Single black pawn on e5
do
  local grid = createEmptyGrid()
  setPiece(grid, 4, 5, "pawn", "black")
  
  testCount = testCount + 1
  if runTest("Single black pawn on e5", grid, "8/8/8/4p3/8/8/8/8") then
    passCount = passCount + 1
  end
end

-- Test 5: Mixed pieces
do
  local grid = createEmptyGrid()
  setPiece(grid, 1, 1, "king", "black")
  setPiece(grid, 1, 8, "king", "white")
  setPiece(grid, 5, 4, "queen", "white")
  setPiece(grid, 5, 5, "pawn", "black")
  
  testCount = testCount + 1
  if runTest("Mixed pieces (white and black)", grid, "k6K/8/8/8/3Qp3/8/8/8") then
    passCount = passCount + 1
  end
end

-- Test 6: All white piece types
do
  local grid = createEmptyGrid()
  setPiece(grid, 1, 1, "pawn", "white")
  setPiece(grid, 1, 2, "knight", "white")
  setPiece(grid, 1, 3, "bishop", "white")
  setPiece(grid, 1, 4, "rook", "white")
  setPiece(grid, 1, 5, "queen", "white")
  setPiece(grid, 1, 6, "king", "white")
  
  testCount = testCount + 1
  if runTest("All white piece types", grid, "PNBRQK2/8/8/8/8/8/8/8") then
    passCount = passCount + 1
  end
end

-- Test 7: All black piece types
do
  local grid = createEmptyGrid()
  setPiece(grid, 1, 1, "pawn", "black")
  setPiece(grid, 1, 2, "knight", "black")
  setPiece(grid, 1, 3, "bishop", "black")
  setPiece(grid, 1, 4, "rook", "black")
  setPiece(grid, 1, 5, "queen", "black")
  setPiece(grid, 1, 6, "king", "black")
  
  testCount = testCount + 1
  if runTest("All black piece types", grid, "pnbrqk2/8/8/8/8/8/8/8") then
    passCount = passCount + 1
  end
end

-- Test 8: Alternating pieces and empty squares
do
  local grid = createEmptyGrid()
  setPiece(grid, 1, 1, "pawn", "white")
  setPiece(grid, 1, 3, "pawn", "white")
  setPiece(grid, 1, 5, "pawn", "white")
  
  testCount = testCount + 1
  if runTest("Alternating empty and filled squares", grid, "P1P1P3/8/8/8/8/8/8/8") then
    passCount = passCount + 1
  end
end

print("=== gridToFEN Tests Complete ===")
print("Passed: " .. passCount .. "/" .. testCount)
