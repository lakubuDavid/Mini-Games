-- [[
-- ChessPiece
-- ]]

local assets = require("assets")
local common = require("lib.common")
local flux = require("lib.flux")

ChessPiece = {
  img = nil,
  side = "",
  type = "",
  position = { x = 0, y = 0 },
  grid_coordinates = { col = 0, row = 0 },
  scale = { sx = 2, sy = 2 },
  quad = nil,
  selected = false,
  behaviour = nil,
  highlight_color = common.Color(255, 170, 100),
  is_moving = false
}

local quadsCache = {}

local function getQuads(side)
  if quadsCache[side] then
    return quadsCache[side]
  end

  local pieceWidth, pieceHeight = 16, 16
  quadsCache[side] = {
    pawn   = love.graphics.newQuad(0 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
    knight = love.graphics.newQuad(1 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
    rook   = love.graphics.newQuad(2 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
    bishop = love.graphics.newQuad(3 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
    king   = love.graphics.newQuad(4 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
    queen  = love.graphics.newQuad(5 * pieceWidth, 0, pieceWidth, pieceHeight, assets.CHESS_PIECES[side]),
  }
  return quadsCache[side]
end

function ChessPiece.getQuadsForSide(side)
  return getQuads(side)
end

function ChessPiece:new(side, pieceType)
  local instance = {
    img = nil,
    side = side,
    type = pieceType,
    quad = getQuads(side)[pieceType],
    selected = false,
    grid_coordinates = { col = 0, row = 0 },
    highlight_color = common.Color(255, 170, 100),
    hasMoved = false
  }
  setmetatable(instance, self)
  self.__index = ChessPiece
  return instance
end

function ChessPiece:init()
  self.img = assets.CHESS_PIECES[self.side]
end

function ChessPiece:update(dt)
  if self.tween then
    flux.update(dt)
  end
end

function ChessPiece:moveTo(gridCol, gridRow, targetX, targetY, onComplete)
  self.is_moving = true
  self.grid_coordinates.col = gridCol
  self.grid_coordinates.row = gridRow
  
  self.tween = flux.to(self.position, 0.2, { x = targetX, y = targetY })
    :ease("quadout")
    :oncomplete(function()
      self.is_moving = false
      self.tween = nil
      if onComplete then onComplete() end
    end)
end

function ChessPiece:draw()
  if self.selected then
    love.graphics.setColor(common.unwrap(self.highlight_color))
  end
  love.graphics.draw(self.img, self.quad, self.position.x, self.position.y, 0, self.scale.sx, self.scale.sy)
  love.graphics.setColor(1, 1, 1, 1)
end

return ChessPiece