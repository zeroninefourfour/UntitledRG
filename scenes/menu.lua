local menu = {}
local timer = 0

function menu.update(dt)
    timer=timer+dt
end

function menu.draw()
    love.graphics.clear(0,0,0)
    love.graphics.printf("Welcome", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Enter to start", 0, love.graphics.getHeight()/2 + 30, love.graphics.getWidth(), "center")
    love.setcolor(0.1,0.1,0.3)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(0.3,0.5,0.8,0.5)
    love.graphics.circle("fill", 200 ,150 ,80)
    love.graphics.circle("fill", 500 ,300 ,180)
    love.graphics.setColor(1, 1, 1)
end

function menu.keypressed(key)
    if key == "return" then
        scene = require("gameplay")
    end
end



return menu
