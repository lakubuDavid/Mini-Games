local Strings = require("lib.strings")
local Saves = {
}

local FEN_PIECE_MAP = {
  p = "pawn",
  n = "knight",
  r = "rook",
  b = "bishop",
  k = "king",
  q = "queen"
}
local PIECE_FEN_MAP = {
  pawn = "p",
  knight = "n",
  rook = "r",
  bishop = "b",
  king = "k",
  queen = "q",
}
function Saves.load()
  -- CHANGEME: Just for testing should later use love.filesystem
  local file = io.open("game.fen", "r")

  assert(file, [[ [Saves::FenLoader] Cannot open file "game.fen" ]])

  local fen = file:read("a")
  local grid, turn = Saves.gridFromFEN(fen)

  file:close()

  return grid, turn
end

function Saves.save(grid, turn)
  local file = io.open("game.fen","w+")

  assert(file, [[ [Saves::FenSaver] Cannot open file "game.fen" ]])

  local fen = Saves.gridToFEN(grid, turn)
  file:write(fen)

  file:close()
end

function Saves.gridToFEN(grid, turn)
  local fen = ""
  for rowIdx, row in ipairs(grid) do
    local whiteSpacesCount = 0
    -- Iterate through all 8 columns explicitly to handle nil values
    for col = 1, 8 do
      local piece = row[col]
      if not piece then
        whiteSpacesCount = whiteSpacesCount + 1
      else
        if whiteSpacesCount > 0 then
          fen = fen .. whiteSpacesCount
          whiteSpacesCount = 0
        end
        local fenChar = PIECE_FEN_MAP[piece.type]
        if piece.side == "white" then
          fen = fen .. fenChar:upper()
        else
          fen = fen .. fenChar:lower()
        end
      end
    end
    -- Add remaining empty spaces at end of row
    if whiteSpacesCount > 0 then
      fen = fen .. whiteSpacesCount
    end
    -- Add row separator (except after last row)
    if rowIdx < 8 then
      fen = fen .. "/"
    end
  end
  -- Add turn (who moves next): w for white, b for black
  fen = fen .. " " .. (turn == "white" and "w" or "b")
  -- Add castling rights, en passant, halfmove, fullmove (simplified)
  fen = fen .. " KQkq - 0 1"
  return fen
end

function Saves.gridFromFEN(fen)
  local fenS = Strings:new(fen):trim()
  print("Loaded FEN String", fenS:trimmed())
  local positions, turn, castling, enPassant, halfMove, fullMove = fenS:trimmed():usplit(" ")
  print(positions, turn, castling, enPassant, halfMove, fullMove)

  -- Convert turn from FEN format (w/b) to our format (white/black)
  -- Note: usplit returns Strings objects, so we need to access .str
  local turnStr = (type(turn) == "table" and turn.str) or turn
  local turnValue = turnStr == "w" and "white" or "black"
  print("Turn parsed: " .. turnStr .. " -> " .. turnValue)

  local grid = {}
  for row = 1, 8 do
    table.insert(grid, {})
    for col = 1, 8 do
      table.insert(grid[row], nil)
    end
  end

  local fenRows = positions:split("/")

  for row, fenRow in ipairs(fenRows) do
    print("row #" .. row, " ", fenRow)
    local col = 1

    for char in fenRow:chars() do
      if char:isNumeric() then
        col = col + tonumber(char.str)
      else
        local newPiece = { type = "", side = "" }
        newPiece.type = FEN_PIECE_MAP[char:lower().str]
        newPiece.side = char:isUpperChar() and "white" or "black"
        grid[row][col] = newPiece
        col = col + 1
      end
    end

    -- while (col <= 8) do
    --   if col > #fenRow then break end
    --   local char = fenRow:charAt(charIdx)
    --   charIdx = charIdx +1
    -- end
  end

  return grid, turnValue
end

return Saves
