local menu = {}
local timer = 0

function menu.update(dt)
end

local exo_font_path = "assets/fonts/Exo/Exo-Regular.ttf"
local exo_24 = love.assets.newFont(exo_font_path, 24)
local exo_48 = love.assets.newFont(exo_font_path, 48)

local background = love.assets.newImage("assets/cool_blur.png")

function menu.draw()
    love.graphics.setColor(1, 1, 1, 1)
    -- love.graphics.setBackgroundColor(214 / 255, 138/ 255, 133 /255)
    -- love.graphics.draw(background, love.graphics.getWidth() /2 , love.graphics.getHeight() /2)
    love.graphics.printf("untitled rhythm game", exo_48, 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("CREDITS (0/3)", exo_24, 0, love.graphics.getHeight() - 140, love.graphics.getWidth(), "center")
    love.graphics.printf("Version 2026.4.10-dev ", 0, love.graphics.getHeight() - 20, love.graphics.getWidth(), "center")
end

function menu.keypressed(key)
    if key == "return" then
       love.switchScene("song_select")
    end
end

return menu
