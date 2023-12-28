assets = {}

function assets.loadAssets()
    assets.CROSS_SPRITE = love.graphics.newImage("assets/textures/cross.png")
    assets.CIRCLE_SPRITE = love.graphics.newImage("assets/textures/circle.png")
    assets.GRID_SPRITE = love.graphics.newImage("assets/textures/grid.png")

    assets.RESET_BUTTON_SPRITE = love.graphics.newImage("assets/textures/reset.png")

    assets.TEXT_FONT = love.graphics.newFont("assets/fonts/Metrophobic-Regular.ttf", 32)
    assets.BIG_TEXT_FONT = love.graphics.newFont("assets/fonts/Metrophobic-Regular.ttf", 64)
    assets.SMALL_TEXT_FONT = love.graphics.newFont("assets/fonts/Metrophobic-Regular.ttf", 24)

    assets.CLICK1_SFX = love.audio.newSource("assets/sfx/Abstract1.wav","static")
    assets.CLICK2_SFX = love.audio.newSource("assets/sfx/Abstract2.wav", "static")
    
    assets.UI_RESET_CLICK_SFX = love.audio.newSource("assets/sfx/Minimalist11.wav", "static")

    assets.DIFF_UP_SFX = love.audio.newSource("assets/sfx/Minimalist8.wav", "static")
    assets.DIFF_DOWN_SFX = love.audio.newSource("assets/sfx/Minimalist7.wav", "static")

    assets.TIE_SFX = love.audio.newSource("assets/sfx/African1.wav", "static")
    assets.PLAYER1_WIN_SFX = love.audio.newSource("assets/sfx/African2.wav", "static")
    assets.PLAYER2_WIN_SFX = love.audio.newSource("assets/sfx/African3.wav", "static")

end

return assets