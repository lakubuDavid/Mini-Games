assets = {}

assets.AVAILABLE_BOARDS = {
  { name = "Plain 1", file = "board_plain_01.png" },
  { name = "Plain 2", file = "board_plain_02.png" },
  { name = "Plain 3", file = "board_plain_03.png" },
  { name = "Plain 4", file = "board_plain_04.png" },
  { name = "Plain 5", file = "board_plain_05.png" },
  { name = "Persp 1", file = "board_persp_01.png" },
  { name = "Persp 2", file = "board_persp_02.png" },
  { name = "Persp 3", file = "board_persp_03.png" },
  { name = "Persp 4", file = "board_persp_04.png" },
  { name = "Persp 5", file = "board_persp_05.png" },
}

assets.AVAILABLE_PIECES = {
  { name = "Classic", black = "BlackPieces.png", white = "WhitePieces.png" },
  { name = "Wood", black = "BlackPieces_Wood.png", white = "WhitePieces_Wood.png" },
  { name = "Simplified", black = "BlackPieces_Simplified.png", white = "WhitePieces_Simplified.png" },
  { name = "Wood Simplified", black = "BlackPieces_WoodSimplified.png", white = "WhitePieces_WoodSimplified.png" },
}

assets.currentBoard = 5
assets.currentPieces = 2

function assets.loadAssets()
  local board = assets.AVAILABLE_BOARDS[assets.currentBoard]
  assets.CHESS_BOARD = love.graphics.newImage("content/img/boards/" .. board.file)

  local pieces = assets.AVAILABLE_PIECES[assets.currentPieces]
  assets.CHESS_PIECES = {
    black = love.graphics.newImage("content/img/16x16 pieces/" .. pieces.black),
    white = love.graphics.newImage("content/img/16x16 pieces/" .. pieces.white)
  }

  assets.FONT = love.graphics.newFont("content/fonts/friendlyscribbles.ttf", 16)
end

function assets.setBoard(index)
  if index >= 1 and index <= #assets.AVAILABLE_BOARDS then
    assets.currentBoard = index
    assets.CHESS_BOARD = love.graphics.newImage("content/img/boards/" .. assets.AVAILABLE_BOARDS[index].file)
  end
end

function assets.setPieces(index)
  if index >= 1 and index <= #assets.AVAILABLE_PIECES then
    assets.currentPieces = index
    local pieces = assets.AVAILABLE_PIECES[index]
    assets.CHESS_PIECES = {
      black = love.graphics.newImage("content/img/16x16 pieces/" .. pieces.black),
      white = love.graphics.newImage("content/img/16x16 pieces/" .. pieces.white)
    }
  end
end

function assets.getBoardName()
  return assets.AVAILABLE_BOARDS[assets.currentBoard].name
end

function assets.getPiecesName()
  return assets.AVAILABLE_PIECES[assets.currentPieces].name
end

return assets