-- Test file for save/load functionality
-- Tests the workflow of saving a game and loading it back

print("=== Testing Save/Load Functionality ===\n")

local Saves = require("saves")
local ChessPiece = require("pieces.piece")
local BehaviourRegistry = require("behaviours.registry")

print("Test 1: Create a simple board grid with some pieces")
local testGrid = {}
for row = 1, 8 do
  table.insert(testGrid, {})
  for col = 1, 8 do
    table.insert(testGrid[row], nil)
  end
end

-- Add some pieces
testGrid[1][1] = { type = "rook", side = "white" }
testGrid[1][5] = { type = "king", side = "white" }
testGrid[8][1] = { type = "rook", side = "black" }
testGrid[8][5] = { type = "king", side = "black" }
testGrid[2][5] = { type = "pawn", side = "white" }
testGrid[7][5] = { type = "pawn", side = "black" }

print("Created test grid with:")
print("  - White: King on e1, Rook on a1, Pawn on e2")
print("  - Black: King on e8, Rook on a8, Pawn on e7")

print("Test 2: Convert grid to FEN notation (with turn)")
local fen_white = Saves.gridToFEN(testGrid, "white")
local fen_black = Saves.gridToFEN(testGrid, "black")
print("FEN Output (white turn): " .. fen_white)
print("FEN Output (black turn): " .. fen_black)
print("Expected pattern: R3K3/4P3/8/8/8/8/4p3/r3k3 {w|b} KQkq - 0 1")
local fenMatchWhite = fen_white:match("R3K3/4P3/8/8/8/8/4p3/r3k3 w KQkq %- 0 1") ~= nil
local fenMatchBlack = fen_black:match("R3K3/4P3/8/8/8/8/4p3/r3k3 b KQkq %- 0 1") ~= nil
print("Status (white): " .. (fenMatchWhite and "✓ PASS" or "✗ FAIL"))
print("Status (black): " .. (fenMatchBlack and "✓ PASS" or "✗ FAIL"))

print("\nTest 3: Convert FEN back to grid and extract turn")
local recoveredGrid, recoveredTurn = Saves.gridFromFEN(fen_white)
print("Recovered grid created with turn: " .. (recoveredTurn or "nil"))
print("Expected turn: white")
print("Status: " .. (recoveredTurn == "white" and "✓ PASS" or "✗ FAIL"))

-- Verify the grid
local success = true
for row = 1, 8 do
  for col = 1, 8 do
    local orig = testGrid[row][col]
    local recovered = recoveredGrid[row][col]
    if (orig == nil) ~= (recovered == nil) then
      success = false
      print("Mismatch at [" .. row .. "][" .. col .. "]")
    elseif orig and recovered then
      if orig.type ~= recovered.type or orig.side ~= recovered.side then
        success = false
        print("Piece mismatch at [" .. row .. "][" .. col .. "]")
      end
    end
  end
end
print("Grid verification: " .. (success and "✓ PASS - All pieces recovered correctly" or "✗ FAIL - Grid mismatch"))

print("\nTest 4: Save grid to file slot (with turn)")
do
  local Saves = require("saves")
  love.filesystem.createDirectory("saves")
  
  -- Create a test grid
  local saveGrid = {}
  for row = 1, 8 do
    table.insert(saveGrid, {})
    for col = 1, 8 do
      table.insert(saveGrid[row], nil)
    end
  end
  
  saveGrid[1][4] = { type = "queen", side = "white" }
  saveGrid[1][5] = { type = "king", side = "white" }
  saveGrid[8][4] = { type = "queen", side = "black" }
  saveGrid[8][5] = { type = "king", side = "black" }
  
  local fen = Saves.gridToFEN(saveGrid, "white")
  love.filesystem.write("saves/test_slot.fen", fen)
  
  print("Test game saved to: saves/test_slot.fen")
  print("FEN with turn: " .. fen)
  print("File exists: " .. (love.filesystem.getInfo("saves/test_slot.fen") and "✓ YES" or "✗ NO"))
end

print("\nTest 5: Load grid from file slot (extract turn)")
do
  local Saves = require("saves")
  
  local fen = love.filesystem.read("saves/test_slot.fen")
  print("FEN loaded: " .. fen)
  
  local grid, turn = Saves.gridFromFEN(fen)
  print("Grid loaded successfully with turn: " .. (turn or "nil"))
  
  -- Verify key pieces
  local tests = {
    { row = 1, col = 4, type = "queen", side = "white" },
    { row = 1, col = 5, type = "king", side = "white" },
    { row = 8, col = 4, type = "queen", side = "black" },
    { row = 8, col = 5, type = "king", side = "black" },
  }
  
  local allCorrect = true
  for _, test in ipairs(tests) do
    local piece = grid[test.row][test.col]
    if not piece or piece.type ~= test.type or piece.side ~= test.side then
      allCorrect = false
      print("  ✗ Piece mismatch at [" .. test.row .. "][" .. test.col .. "]")
    else
      print("  ✓ " .. test.side .. " " .. test.type .. " at correct position")
    end
  end
  
  print("Turn extracted: " .. (turn == "white" and "✓ PASS (white)" or "✗ FAIL (expected white)"))
  print("Status: " .. (allCorrect and "✓ PASS" or "✗ FAIL"))
end

print("\n=== Save/Load Tests Complete ===")
