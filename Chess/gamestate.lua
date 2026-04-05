GameState = {
  MENU = "menu",
  PLAYING = "playing",
  PAUSED = "paused",
  THEMES = "themes"
}

local currentState = GameState.MENU

function GameState.set(newState)
  currentState = newState
end

function GameState.get()
  return currentState
end

function GameState.is(state)
  return currentState == state
end

return GameState