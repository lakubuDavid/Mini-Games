relaxed = {
    error_margin = 5,
    max_depth = 9
}

--[[ 
    The best move is the move that makes the AI win in less move
 ]]

 function table.slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
  end

function relaxed.think(grid, whose_turn)
    -- Gets all the possible moves and how many moves it takes to win or if the move makes leads to a loss

    local err_margin = relaxed.error_margin + 1

    -- Returns the best move
    local moves = relaxed.min(grid, whose_turn, 1)
    relaxed.sort_moves(moves)
    local smoves = table.slice(moves,1,err_margin)
    -- print(smoves)
    err_margin = math.min(err_margin,#smoves)
    local final_move = smoves[math.random(err_margin)]
    return final_move
end

function relaxed.min(grid, whose_turn, depth, alpha, beta)
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

    -- print("Depth : " .. depth)

    local best_moves = {}

    local bestScore = -math.huge
    -- local bestOpponentScore = -math.huge
    local bestMove = {}

    if #moves > 0 and depth < relaxed.max_depth then
        -- bestMove = moves[math.random(#moves)]
        --[[ 
            No more counter intuitive code
         ]]
        for _, move in ipairs(moves) do
            local copy = relaxed.copy_grid(grid)
            -- print("move possible: " .. move.row .. " " .. move.col)
            copy[move.row][move.col] = whose_turn
            local score = 0
            if relaxed.check_victory(copy, whose_turn) then
                score = (9 - depth) + 20
            elseif relaxed.check_victory(copy, relaxed.others_turn(whose_turn)) then
                score = -(9 - depth) - 20
            elseif relaxed.is_tie(copy) then
                score = 0
            else
                local _best_moves = relaxed.min(copy, relaxed.others_turn(whose_turn), depth + 1)
                for _, value in ipairs(_best_moves) do
                    table.insert(best_moves, {row=value.row,col=value.col,score=-value.score})
                end
                -- goto continue
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

            -- print("Score: " .. score)
            -- print("Best score: " .. bestScore)
            -- print("Best opponent score: " .. bestOpponentScore)
            -- print("Move : " .. move.row .. " " .. move.col)
            bestScore = math.max( bestScore,score )
            table.insert(best_moves,{row=move.row, col=move.col, score=score})
            -- ::continue::
        end
        -- print("Best Move : "..bestMove.row.." "..bestMove.col)
    end

    return best_moves
end

function relaxed.sort_moves(moves)
    table.sort(moves, function (a,b) return a.score < b.score end)
    return moves
end

function relaxed.copy_grid(grid)
    local copy = {}

    for i, row in ipairs(grid) do
        copy[i] = {}

        for j, value in ipairs(row) do
            copy[i][j] = value
        end
    end

    return copy
end

function relaxed.check_victory(grid, whose_turn)
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

function relaxed.is_tie(grid)
    for row = 1, 3 do
        for column = 1, 3 do
            if grid[row][column] == 0 then
                return false
            end
        end
    end
    return true
end

function relaxed.others_turn(whose_turn)
    if whose_turn == 1 then
        return 2
    else
        return 1
    end
end

return relaxed
