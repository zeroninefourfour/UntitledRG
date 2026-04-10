local fatal = {}




fatal.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBackgroundColor(214 / 255, 138 / 255, 133 / 255)

         love.graphics.printf("something went wrong!!!!",love.fonts.inter.bold["12"], 0, 0, love.graphics.getWidth(), "center")
end


return fatal