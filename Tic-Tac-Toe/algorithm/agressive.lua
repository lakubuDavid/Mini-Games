agressive = {}

--[[ 
    The best move is the move that makes the AI win in less move
 ]]

function agressive.think(grid, whose_turn)
    -- Gets all the possible moves and how many moves it takes to win or if the move makes leads to a loss

    -- Returns the best move
    local _, move = agressive.min(grid, whose_turn, 1)

    return move
end

function agressive.min(grid, whose_turn, depth, alpha, beta)
    local moves = {}
    alpha = alpha or -math.huge
    beta = beta or math.huge
    for row = 1, 3 do
        for col = 1, 3 do
            if grid[row][col] == 0 then
                table.insert(moves, {
                    row = row,
                    col = col
                })
            end
        end
    end

    print("Depth : " .. depth)

    local bestScore = -math.huge
    -- local bestOpponentScore = -math.huge
    local bestMove = {}

    if #moves > 0 and depth < 45 then
        -- bestMove = moves[math.random(#moves)]
        --[[ 
            No more counter intuitive code
         ]]
        for _, move in ipairs(moves) do
            local copy = agressive.copy_grid(grid)
            print("move possible: " .. move.row .. " " .. move.col)
            copy[move.row][move.col] = whose_turn
            local score = 0
            if agressive.check_victory(copy, whose_turn) then
                score = (9 - depth) + 20
                bestMove = move
                bestScore = score
                break
            elseif agressive.check_victory(copy, agressive.others_turn(whose_turn)) then
                score = -(9 - depth) - 20
            elseif agressive.is_tie(copy) then
                score = 0
            else
                score = -agressive.min(copy, agressive.others_turn(whose_turn), depth + 1)
            end

            -- Alpha-Beta Pruning
            if whose_turn == 1 then
                alpha = math.max(alpha, score)
            else
                beta = math.min(beta, score)
            end

            if beta <= alpha then
                break -- Prune the remaining branches
            end

            print("Score: " .. score)
            print("Best score: " .. bestScore)
            -- print("Best opponent score: " .. bestOpponentScore)
            print("Move : " .. move.row .. " " .. move.col)

            if score > bestScore then
                bestScore = math.max(bestScore, score)
                bestMove = move
            end
            -- ::continue::
        end
        -- print("Best Move : "..bestMove.row.." "..bestMove.col)
    end

    return bestScore, bestMove
end

function agressive.copy_grid(grid)
    local copy = {}

    for i, row in ipairs(grid) do
        copy[i] = {}

        for j, value in ipairs(row) do
            copy[i][j] = value
        end
    end

    return copy
end

function agressive.check_victory(grid, whose_turn)
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

function agressive.is_tie(grid)
    for row = 1, 3 do
        for column = 1, 3 do
            if grid[row][column] == 0 then
                return false
            end
        end
    end
    return true
end

function agressive.others_turn(whose_turn)
    if whose_turn == 1 then
        return 2
    else
        return 1
    end
end

return agressive
