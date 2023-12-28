# Tic Tac Toe - AI

This is a simple Tic-Tac-Toe game with different AI implementations.

## Bozo AI

This AI is the simplest one that just chooses a random free cell.

## Relaxed AI

This is an implementation of the min-max algorithm that's gets and sorts the best moves then <br/>
While select one based on difficulty by : 

- Reducing the depth of the min-max algorithm depending on difficulty
- Randomly select one of the best moves 

```lua

    local err_margin = relaxed.error_margin + 1

    -- Returns the best move
    local moves = relaxed.min(grid, whose_turn, 1)
    relaxed.sort_moves(moves)
    local smoves = table.slice(moves,1,err_margin)
    -- print(smoves)
    err_margin = math.min(err_margin,#smoves)
    local final_move = smoves[math.random(err_margin)]
    return final_move

```

## Agressive AI

This one is a more agressive implementation of the min max algorithm that only chooses the best move (which makes it unbeatable 😂)


## Uses

Feel free to try it and give me your feedbacks 😉


