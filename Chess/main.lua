
local lurker = require ("lib.lurker")
local assets = require("assets")
local common = require("lib.common")
assets.loadAssets()

local Game = require("game")

love.graphics.setDefaultFilter('nearest', 'nearest')

-- local BG_COLOR = {r=1,g=1,b=1,a=1}
BG_COLOR = common.Color(145,  120,  110,  255 )

GRID_OFFSET = { x = 312, y = 160 }
GRID_SIZE = 400
GRID_SCALE = { sx = 3, sy = 3 }

SCREEN_WIDTH = 1024
SCREEN_HEIGHT = 720

local game = {}

function love.load()
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
    resizable = true,
    vsync = false,
    minwidth = SCREEN_WIDTH,
    minheight = SCREEN_HEIGHT
  })
    -- love.graphics.setBackgroundColor(25 / 255, 25 / 255, 35 / 255)

  game = Game:new()
    
  game:init()
end

function love.resize(w, h)
  SCREEN_WIDTH = w
  SCREEN_HEIGHT = h

  GRID_OFFSET = {
    x = (SCREEN_WIDTH - GRID_SIZE) / 2,
    y = (SCREEN_HEIGHT - GRID_SIZE) / 2
  }

  -- love.graphics.setBackgroundColor(common.colors.unwrap(BG_COLOR))

  game:resize(w, h)
end

function love.update(dt)
  lurker.scan()

  game:update(dt)
end

function love.mousepressed(x, y, button)
  game:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  game:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy)
  game:mousemoved(x, y, dx, dy)
end

function love.keypressed(key)
  game:keypressed(key)
end

function love.draw()
  love.graphics.clear(common.colors.unwrap(BG_COLOR))
  -- love.graphics.setBackgroundColor(common.colors.unwrap(BG_COLOR))

  game:draw()
end
