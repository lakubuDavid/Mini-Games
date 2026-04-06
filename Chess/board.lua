local assets = require("assets")
local common = require("lib.common")
local ChessPiece = require("pieces.piece")
local BehaviourRegistry = require("behaviours.registry")
local Event = require("lib.knife.event")
local PromotionUI = require("widgets.promotion")

local BOARD_SCALE = 3
local CELLS_OFFSET = { x = 18 * (BOARD_SCALE / 2), y = 18 * (BOARD_SCALE / 2) }

Board = {
  img = assets.CHESS_BOARD,
  board_offset = { x = 120, y = 120 },
  scale = { sx = BOARD_SCALE, sy = BOARD_SCALE },
  CELL_SIZE = 16 * BOARD_SCALE,
  pieces = {},
  grid = {},
  selected_piece = nil,
  turn = "white",
  lastMove = nil,
  promotionUI = nil,
  cursor_overlay = {
    visible = false,
    grid_positon = { x = 0, y = 0 },
    color = common.Color(255, 230, 210, 100)
  },
  move_overlay_color = common.Color(100, 200, 100, 150),
  capture_overlay_color = common.Color(200, 100, 100, 150)
}

local STARTING_POSITION = {
  white = {
    { type = "rook",   col = 1 },
    { type = "knight", col = 2 },
    { type = "bishop", col = 3 },
    { type = "queen",  col = 4 },
    { type = "king",   col = 5 },
    { type = "bishop", col = 6 },
    { type = "knight", col = 7 },
    { type = "rook",   col = 8 },
  },
  black = {
    { type = "rook",   col = 1 },
    { type = "knight", col = 2 },
    { type = "bishop", col = 3 },
    { type = "queen",  col = 4 },
    { type = "king",   col = 5 },
    { type = "bishop", col = 6 },
    { type = "knight", col = 7 },
    { type = "rook",   col = 8 },
  }
}

local function createGridPosition(col, row)
  return string.char(96 + col) .. row
end

local function getRenderPosition(col, row, cellSize, offsetX, offsetY)
  return {
    x = (col - 1) * cellSize + offsetX + CELLS_OFFSET.x,
    y = (row - 1) * cellSize + offsetY + CELLS_OFFSET.y
  }
end

function Board:isValidMove(piece, toRow, toCol)
  local vmoves = piece.behaviour:getMoves(self.grid)
  for _, move in ipairs(vmoves) do
    if move.col == toCol and move.row == toRow then
      return true, move
    end
  end
  return false, nil
end

function Board:new(copy)
  instance = copy or {}
  setmetatable(instance, self)
  self.__index = Board
  return instance
end

function Board:init(loadedGrid)
  self.grid = {}
  self.pieces = {}

  for row = 1, 8 do
    self.grid[row] = {}
    for col = 1, 8 do
      self.grid[row][col] = nil
    end
  end

  -- If a loaded grid is provided, populate pieces from it
  if loadedGrid then
    self:_populatePiecesFromGrid(loadedGrid)
  else
    -- Initialize starting position
    for col = 1, 8 do
      local whitePawn = ChessPiece:new("white", "pawn")
      whitePawn.gridPos = createGridPosition(col, 2)
      whitePawn.grid_coordinates = { col = col, row = 2 }
      whitePawn.position = getRenderPosition(col, 2, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
      whitePawn.behaviour = BehaviourRegistry.create(whitePawn, self)
      whitePawn:init()
      self.pieces[#self.pieces + 1] = whitePawn
      self.grid[2][col] = whitePawn

      local blackPawn = ChessPiece:new("black", "pawn")
      blackPawn.gridPos = createGridPosition(col, 7)
      blackPawn.grid_coordinates = { col = col, row = 7 }
      blackPawn.position = getRenderPosition(col, 7, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
      blackPawn.behaviour = BehaviourRegistry.create(blackPawn, self)
      blackPawn:init()
      self.pieces[#self.pieces + 1] = blackPawn
      self.grid[7][col] = blackPawn
    end

    for _, pieceData in ipairs(STARTING_POSITION.white) do
      local piece = ChessPiece:new("white", pieceData.type)
      piece.gridPos = createGridPosition(pieceData.col, 1)
      piece.grid_coordinates = { col = pieceData.col, row = 1 }
      piece.position = getRenderPosition(pieceData.col, 1, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
      piece.behaviour = BehaviourRegistry.create(piece, self)
      piece:init()
      self.pieces[#self.pieces + 1] = piece
      self.grid[1][pieceData.col] = piece
    end

    for _, pieceData in ipairs(STARTING_POSITION.black) do
      local piece = ChessPiece:new("black", pieceData.type)
      piece.gridPos = createGridPosition(pieceData.col, 8)
      piece.grid_coordinates = { col = pieceData.col, row = 8 }
      piece.position = getRenderPosition(pieceData.col, 8, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
      piece.behaviour = BehaviourRegistry.create(piece, self)
      piece:init()
      self.pieces[#self.pieces + 1] = piece
      self.grid[8][pieceData.col] = piece
    end
  end

  self.promotionUI = PromotionUI:new()

  Event.on("pawnPromotion", function(pawn, row)
    self.promotionUI:show(pawn, row, self.board_offset, self.CELL_SIZE)
  end)
end

-- Helper function to populate pieces from a loaded grid (from Saves)
function Board:_populatePiecesFromGrid(loadedGrid)
  for row = 1, 8 do
    for col = 1, 8 do
      local pieceData = loadedGrid[row][col]
      if pieceData then
        local piece = ChessPiece:new(pieceData.side, pieceData.type)
        piece.gridPos = createGridPosition(col, row)
        piece.grid_coordinates = { col = col, row = row }
        piece.position = getRenderPosition(col, row, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
        piece.behaviour = BehaviourRegistry.create(piece, self)
        piece:init()
        self.pieces[#self.pieces + 1] = piece
        self.grid[row][col] = piece
      end
    end
  end
end

function Board:reset()
  self.pieces = {}
  self.grid = {}
  self:init()
end

function Board:update(dt)
  for _, piece in ipairs(self.pieces) do
    piece:update(dt)
  end
end

function Board:getGridCoordinate(x, y)
  local relativeX = x - self.board_offset.x - CELLS_OFFSET.x + 6
  local relativeY = y - self.board_offset.y - CELLS_OFFSET.y + 6

  local col = math.floor(relativeX / self.CELL_SIZE) + 1
  local row = math.floor(relativeY / self.CELL_SIZE) + 1

  if col < 1 or col > 8 or row < 1 or row > 8 then
    return nil
  end

  return { col = col, row = row, piece = self.grid[row][col] }
end

function Board:getPiece(row, col)
  return self.grid[row][col]
end

-- From and To should be grid coordinates
function Board:movePiece(from, to)
  if from.row < 1 or from.row > 8 or from.col < 1 or from.col > 8 then
    return false
  end
  if to.row < 1 or to.row > 8 or to.col < 1 or to.col > 8 then
    return false
  end

  local piece = self.grid[from.row][from.col]
  if not piece then
    return false
  end

  local isValid, moveData = self:isValidMove(piece, to.row, to.col)
  if not isValid then
    return false
  end

  local capturedPiece = self.grid[to.row][to.col]
  local enPassantCapture = nil

  if moveData and moveData.isEnPassant then
    enPassantCapture = self.grid[moveData.captureRow][to.col]
    capturedPiece = enPassantCapture
  end

  self.grid[from.row][from.col] = nil
  self.grid[to.row][to.col] = piece

  piece.grid_coordinates.col = to.col
  piece.grid_coordinates.row = to.row

  local targetPos = getRenderPosition(to.col, to.row, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
  piece:moveTo(to.col, to.row, targetPos.x, targetPos.y, function()
    piece.hasMoved = true

    self.lastMove = {
      piece = piece,
      from = from,
      to = to,
      isDoublePawnPush = (piece.type == "pawn" and math.abs(to.row - from.row) == 2)
    }

    if enPassantCapture then
      print("Captured (en passant): " .. enPassantCapture.side .. " " .. enPassantCapture.type)
      Event.dispatch("pieceCaptured", enPassantCapture.side, enPassantCapture.type)
      for i, p in ipairs(self.pieces) do
        if p == enPassantCapture then
          table.remove(self.pieces, i)
          break
        end
      end
      self.grid[moveData.captureRow][to.col] = nil
    elseif capturedPiece then
      print("Captured: " .. capturedPiece.side .. " " .. capturedPiece.type)
      Event.dispatch("pieceCaptured", capturedPiece.side, capturedPiece.type)
      for i, p in ipairs(self.pieces) do
        if p == capturedPiece then
          table.remove(self.pieces, i)
          break
        end
      end
    end

    if moveData and moveData.isCastling then
      local rookFrom, rookTo
      if moveData.castlingType == "queen" then
        rookFrom = { col = 1, row = to.row }
        rookTo = { col = to.col + 1, row = to.row }
      else
        rookFrom = { col = 8, row = to.row }
        rookTo = { col = to.col - 1, row = to.row }
      end
      local rook = self.grid[rookFrom.row][rookFrom.col]
      if rook then
        self.grid[rookFrom.row][rookFrom.col] = nil
        self.grid[rookTo.row][rookTo.col] = rook
        rook.grid_coordinates.col = rookTo.col
        rook.grid_coordinates.row = rookTo.row
        local rookPos = getRenderPosition(rookTo.col, rookTo.row, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
        rook:moveTo(rookTo.col, rookTo.row, rookPos.x, rookPos.y)
        rook.hasMoved = true
      end
      print("Castling: " .. moveData.castlingType)
      Event.dispatch("castling", piece.side, moveData.castlingType)
    end

    if piece.type == "pawn" and (to.row == 1 or to.row == 8) then
      print("Pawn promotion at " .. to.col .. "," .. to.row)
      Event.dispatch("pawnPromotion", piece, to.row)
    end

    if piece.behaviour and piece.behaviour.setFirstMove then
      piece.behaviour:setFirstMove(false)
    end
  end)

  return true
end

function Board:mousepressed(x, y, button)
  if self.promotionUI and self.promotionUI.visible then
    self.promotionUI:mousepressed(x, y, button)
    return
  end

  if button == 1 then
    local coord = self:getGridCoordinate(x, y)
    if coord then
      if coord.piece then
        local piece = coord.piece
        if self.selected_piece and piece ~= self.selected_piece then
          if self:isValidMove(self.selected_piece, coord.row, coord.col) then
            local moved = self:movePiece(self.selected_piece.grid_coordinates, { row = coord.row, col = coord.col })
            if moved then
              local oldTurn = self.turn
              self.turn = self.turn == "white" and "black" or "white"
              Event.dispatch("turnChanged", self.turn, oldTurn)
            end
          end
          self.selected_piece.selected = false
          self.selected_piece = nil
        elseif piece.side ~= self.turn then
          return
        elseif self.selected_piece then
          if self.selected_piece == piece then
            self.selected_piece.selected = false
            self.selected_piece = nil
          else
            self.selected_piece.selected = false
            self.selected_piece = piece
            piece.selected = true
          end
        else
          self.selected_piece = piece
          piece.selected = true
        end
      else
        if self.selected_piece then
          if self:isValidMove(self.selected_piece, coord.row, coord.col) then
            local moved = self:movePiece(self.selected_piece.grid_coordinates, { row = coord.row, col = coord.col })
            if moved then
              local oldTurn = self.turn
              self.turn = self.turn == "white" and "black" or "white"
              Event.dispatch("turnChanged", self.turn, oldTurn)
            end
          end
          self.selected_piece.selected = false
          self.selected_piece = nil
        end
      end
    else
      if self.selected_piece then
        self.selected_piece.selected = false
        self.selected_piece = nil
      end
    end
  end
end

function Board:mousereleased(x, y, button)
  if self.promotionUI and self.promotionUI.visible then
    self.promotionUI:mousereleased(x, y, button)
  end
end

function Board:mousemoved(x, y, dx, dy)
  if self.promotionUI and self.promotionUI.visible then
    self.promotionUI:mousemoved(x, y, dx, dy)
    return
  end

  local coord = self:getGridCoordinate(x, y)
  self.cursor_overlay.visible = type(coord) ~= "nil"
  if coord then
    self.cursor_overlay.grid_positon = {
      x = coord.row,
      y = coord.col
    }
  end
end

function Board:resize(w, h)
end

function Board:setOffset(x, y)
  self.board_offset.x = x
  self.board_offset.y = y
  for _, piece in ipairs(self.pieces) do
    local pos = getRenderPosition(piece.grid_coordinates.col, piece.grid_coordinates.row, self.CELL_SIZE, self.board_offset.x, self.board_offset.y)
    piece.position.x = pos.x
    piece.position.y = pos.y
  end
end

function Board:getSize()
  local w = 8 * self.CELL_SIZE
  local h = 8 * self.CELL_SIZE
  return { w = w, h = h }
end

function Board:draw()
  love.graphics.draw(self.img,
    self.board_offset.x, self.board_offset.y,
    0,
    self.scale.sx, self.scale.sy)
  for _, piece in ipairs(self.pieces) do
    piece:draw()
  end

  if self.promotionUI and self.promotionUI.visible then
    self.promotionUI:draw()
  end
end

function Board:drawOverlay()
  if self.selected_piece then
    local validMoves = self.selected_piece.behaviour:getMoves(self.grid)
    for _, vmove in ipairs(validMoves) do
      local mx = (vmove.col - 1) * self.CELL_SIZE + self.board_offset.x + CELLS_OFFSET.x - 6.0
      local my = (vmove.row - 1) * self.CELL_SIZE + self.board_offset.y + CELLS_OFFSET.y - 6.0

      local pieceAtTarget = self.grid[vmove.row] and self.grid[vmove.row][vmove.col]
      local color = pieceAtTarget and self.capture_overlay_color or self.move_overlay_color

      love.graphics.setColor(common.unwrap(color))
      love.graphics.rectangle("fill", mx, my, self.CELL_SIZE, self.CELL_SIZE)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end

  if not self.cursor_overlay.visible then
    return
  end

  local x = (self.cursor_overlay.grid_positon.y - 1) * self.CELL_SIZE + self.board_offset.x + CELLS_OFFSET.x - 6.0
  local y = (self.cursor_overlay.grid_positon.x - 1) * self.CELL_SIZE + self.board_offset.y + CELLS_OFFSET.y - 6.0

  love.graphics.setColor(common.unwrap(self.cursor_overlay.color))
  love.graphics.rectangle("fill", x, y, self.CELL_SIZE, self.CELL_SIZE)
  love.graphics.setColor(1, 1, 1, 1)
end

return Board
