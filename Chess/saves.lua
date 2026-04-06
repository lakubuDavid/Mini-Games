local Strings = require("lib.strings")
local Saves = {
}

local FEN_PIECE_MAP = {
  pawn = "p",
  knight = "k",
  rook = "r",
  bishop = "b",
  king = "k",
  queen = "q",
}
function Saves.load()
end

function Saves.save()
end

function gridToFEN(grid)
end

function Saves.gridFromFEN(fen)
  local fenS = Strings:new(fen)

  local positions,turn,castling,enPassant,halfMove,fullMove = fenS:usplit(" ")
  print(positions,turn,castling,enPassant,halfMove,fullMove)

  
  local grid = {}
  for row = 1, 8 do
    table.insert(grid, {})
    for col = 1, 8 do
      table.insert(grid[row], nil)
    end
  end

  local fenRows = positions:split("/")

  for row, fenRow in ipairs(fenRows) do
    for col=1,8 do
      local char = fenRow.str[col]
      print("char ",char,fenRow.str)
      end
    print("row #" .. row, " ", fenRow)
  end

  return grid
end

return Saves
