--[[
    Your love2d game start here
]] love.graphics.setDefaultFilter('linear', 'linear')

local bozo_ai = require("algorithm.bozo")
local agressive_ai = require("algorithm.agressive")
local relaxed_ai = require("algorithm.relaxed")

local difficulty_levels = {
    "Bozo",
    "Easy",
    "Medium",
    "Hard",
    "Impossible"
}

local current_difficulty = 1

MAX_DIFFICULTY = 5

function love.load()
    SCREEN_WIDTH = 800
    SCREEN_HEIGHT = 600
    love.window.setTitle('Tic Tac Toe - love2d')
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {
        resizable = true,
        vsync = 0,
        minwidth = SCREEN_WIDTH,
        minheight = SCREEN_HEIGHT
    })

    love.graphics.setBackgroundColor(22 / 255, 20 / 255, 30 / 255)

    CROSS_SPRITE = love.graphics.newImage("/assets/textures/cross.png")
    CIRCLE_SPRITE = love.graphics.newImage("/assets/textures/circle.png")
    GRID_SPRITE = love.graphics.newImage("/assets/textures/grid.png")

    RESET_BUTTON = love.graphics.newImage("/assets/textures/reset.png")

    TEXT_FONT = love.graphics.newFont("/assets/fonts/Metrophobic-Regular.ttf", 32)
    BIG_TEXT_FONT = love.graphics.newFont("/assets/fonts/Metrophobic-Regular.ttf", 64)
    SMALL_TEXT_FONT = love.graphics.newFont("/assets/fonts/Metrophobic-Regular.ttf", 24)

    TILE_WIDTH = 136
    TILE_HEIGHT = TILE_WIDTH

    GRID_SIZE = 400
    GRID_OFFSET = {
        x = (SCREEN_WIDTH - GRID_SIZE) / 2,
        y = (SCREEN_HEIGHT - GRID_SIZE) / 2
    }

    PLAYERS_TURN = 1

    SCORE = {0, 0}

    -- AI = random_ai
    -- AI = agressive_ai
    AI = relaxed_ai


    grid = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
    whose_turn = 1
    victory = 0

    setDifficulty(1)

    love.keyboard.keysPressed = {}
    -- love.graphics.setBackgroundColor()
end

function love.resize(w, h)
    SCREEN_WIDTH = w
    SCREEN_HEIGHT = h

    GRID_OFFSET = {
        x = (SCREEN_WIDTH - GRID_SIZE) / 2,
        y = (SCREEN_HEIGHT - GRID_SIZE) / 2
    }
end

function love.keypressed(key,_,is_repeat)
    if key == 'escape' then
        love.event.quit()
    end

    if key == '[' and not is_repeat then
        decreaseDifficulty()
    elseif key == ']' and not is_repeat then
        increaseDifficulty()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- change some values based on your actions
    if whose_turn ~= PLAYERS_TURN and victory == 0 and not is_tie() then
        local move = AI.think(grid,whose_turn)
        if move == nil then return end
        print("move :"..move.row..move.col)
        if grid[move.row][move.col] == 0 then
            grid[move.row][move.col] = whose_turn
        end
        if check_victory() then
            victory = whose_turn
            SCORE[whose_turn] = SCORE[whose_turn] + 1
        else
            next_turn()
        end            

    end
    love.keyboard.keysPressed = {}
end

function love.draw()
    drawGrid()
    drawHUD()
end

function drawGrid()

    love.graphics.draw(GRID_SPRITE, GRID_OFFSET.x, GRID_OFFSET.y, 0, 400 / 750, 400 / 750)

    local CROSS_SCALE = 100 / 150
    local CIRCLE_SCALE = 100 / 142

    for row = 1, #grid do
        for col = 1, #grid[row] do
            local value = grid[row][col]

            -- Calculate the position based on row and col
            local position = {
                x = (col - 1) * TILE_WIDTH + GRID_OFFSET.x, --  TILE_WIDTH is the width of each cell
                y = (row - 1) * TILE_HEIGHT + GRID_OFFSET.y --  TILE_HEIGHT is the height of each cell
            }

            sprite = nil

            if value == 1 then
                love.graphics.draw(CROSS_SPRITE, position.x, position.y, 0, CROSS_SCALE, CROSS_SCALE, -20, -20)
            elseif value == 2 then
                love.graphics.draw(CIRCLE_SPRITE, position.x, position.y, 0, CIRCLE_SCALE, CIRCLE_SCALE, -20, -20)
            end
        end
    end
end

function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, rectX + rectWidth / 2, rectY + rectHeight / 2, 0, 1, 1, textWidth / 2, textHeight / 2)
end

function drawHUD()
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(BIG_TEXT_FONT)

    drawCenteredText(0, 0, SCREEN_WIDTH, 70, "Tic-Tac-Toe")

    local RESET_SCALE = 50 / 260

    love.graphics.draw(RESET_BUTTON, SCREEN_WIDTH - RESET_BUTTON:getWidth() * RESET_SCALE - 18, 18, 0, RESET_SCALE,
        RESET_SCALE)

    love.graphics.setFont(TEXT_FONT)

    if victory ~= 0 then
        local winner = (victory == 1) and "Cross" or "Circle"
        local text = winner .. " won !"
        love.graphics.print(text,20, SCREEN_HEIGHT - 60)
    end

    love.graphics.print("Score : \n"..SCORE[1].." - "..SCORE[2],25,16)

    love.graphics.setColor(1,1,1,0.5)
    love.graphics.setFont(SMALL_TEXT_FONT)
    local d_text = "Difficulty : "..difficulty_levels[current_difficulty].."\nPress '[' to decrease and ']' to increase"
    love.graphics.print(d_text,SCREEN_WIDTH-SMALL_TEXT_FONT:getWidth(d_text)-20,SCREEN_HEIGHT - 80)
end

function setDifficulty(difficulty)
    if difficulty > 0 and difficulty <= MAX_DIFFICULTY  then
        current_difficulty = difficulty

        if difficulty == 1 then
            AI = bozo_ai
        elseif difficulty == 2 then
            local ai = relaxed_ai
            ai.error_margin = 5
            ai.max_depth = 3
            AI = ai
        elseif difficulty == 3 then
            local ai = relaxed_ai
            ai.error_margin = 3
            ai.max_depth = 5
            AI = ai
        elseif difficulty == 4 then
            local ai = relaxed_ai
            ai.error_margin = 1
            ai.max_depth = 7
            AI = ai
        elseif difficulty == 5 then
            AI = agressive_ai
        end
    end
end

function increaseDifficulty()
    local l = current_difficulty+1
    l = clamp(l,1,MAX_DIFFICULTY)
    setDifficulty(l)
end

function decreaseDifficulty()
    local l = current_difficulty-1
    l = clamp(l,1,MAX_DIFFICULTY)
    setDifficulty(l)
end

function clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        if victory == 0 and whose_turn == PLAYERS_TURN then
            if x > GRID_OFFSET.x and x < GRID_OFFSET.x + GRID_SIZE then
                if y > GRID_OFFSET.y and y < GRID_OFFSET.y + GRID_SIZE then
                    local gx = math.floor((x - GRID_OFFSET.x) / TILE_WIDTH) + 1
                    local gy = math.floor((y - GRID_OFFSET.y) / TILE_HEIGHT) + 1

                    if grid[gy][gx] == 0 then
                        grid[gy][gx] = whose_turn

                        if check_victory() then
                            victory = whose_turn
                            SCORE[whose_turn] = SCORE[whose_turn] + 1
                        else
                            next_turn()
                        end
                    end
                end
            end
        end

        local RESET_SCALE = 50 / 260
        local resetButtonX = SCREEN_WIDTH - RESET_BUTTON:getWidth() * RESET_SCALE - 18
        local resetButtonY = 18
        local resetButtonWidth = RESET_BUTTON:getWidth() * RESET_SCALE
        local resetButtonHeight = RESET_BUTTON:getHeight() * RESET_SCALE
    
        if x > resetButtonX and x < resetButtonX + resetButtonWidth and y > resetButtonY and y < resetButtonY + resetButtonHeight then
            reset_game()
        end
    end
end

function next_turn()
    if whose_turn == 1 then
        whose_turn = 2
    else
        whose_turn = 1
    end
end

function check_victory()
    -- Check rows
    for row = 1, 3 do
        if grid[row][1] == whose_turn and grid[row][2] == whose_turn and grid[row][3] == whose_turn then
            return true
        end
    end

    -- Check columns
    for col = 1, 3 do
        if grid[1][col] == whose_turn and grid[2][col] == whose_turn and grid[3][col] == whose_turn then
            return true
        end
    end

    -- Check diagonals
    if grid[1][1] == whose_turn and grid[2][2] == whose_turn and grid[3][3] == whose_turn then
        return true
    end

    if grid[1][3] == whose_turn and grid[2][2] == whose_turn and grid[3][1] == whose_turn then
        return true
    end

    return false
end

function is_tie()
    for row = 1,3 do
        for column = 1,3 do
            if grid[row][column] == 0 then
                return false
            end
        end
    end
    return true
end

function reset_game()
    next_turn()
    grid = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
    victory = 0
end

