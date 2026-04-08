-- Simple test for FEN loading from a string variable
local Saves = require("...saves")

-- FEN string for starting position
local fenString = "8/5k2/3p4/1p1Pp2p/pP2Pp1P/P4P1K/8/8 b - - 99 50"

local PIECE_FEN_MAP = {
  pawn = "p",
  knight = "n",
  rook = "r",
  bishop = "b",
  king = "k",
  queen = "q",
}
print("Testing FEN Loading")
print("==================")
print("")
print("FEN String: " .. fenString)
print("")

-- Test loading from FEN string
local grid = Saves.gridFromFEN(fenString)

print("Grid loaded successfully!")
print("Grid structure:")
for row = 1, 8 do
  if grid[row] then
    print("  Row " .. row .. ": " .. #grid[row] .. " columns")
  end
end

print("")
print("Full Grid:")
print("  A B C D E F G H")
for row = 1, 8 do
  io.write(row .. " ")
  for col = 1, 8 do
    local piece = grid[row][col]
    if piece then
      io.write(
        (piece.side == "white" and
          PIECE_FEN_MAP[piece.type]:upper() or
          PIECE_FEN_MAP[piece.type]:lower()
        ) .. " ")
    else
      io.write(". ")
    end
  end
  print(row)
end
print("  A B C D E F G H")


print("")
print("Test complete!")
