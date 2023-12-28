
bozo_ai = {}

function bozo_ai.think(grid,whose_turn)
    local free_cells = {}

    for row=1,3 do
        for col=1,3 do
            if grid[row][col] == 0 then
                table.insert(free_cells, {row=row, col=col})
            end
        end
    end
    local move = {}
    if #free_cells > 0 then
        move = free_cells[math.random(#free_cells)]
    end
    return move
end

return bozo_ai