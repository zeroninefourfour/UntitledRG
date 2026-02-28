local menu = {}
local timer = 0

function menu.update(dt)
 end
local inter_48pt_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 48)
local inter_24pt_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 24)
local background = love.graphics.newImage("assets/cool_blur.png")

function menu.draw()
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setBackgroundColor(214 / 255, 138/ 255, 133 /255)
   -- love.graphics.draw(background, love.graphics.getWidth() /2 , love.graphics.getHeight() /2)
     love.graphics.printf("untitled rhythm game",inter_48pt_bold,  0, 200, love.graphics.getWidth(), "center")
 

    love.graphics.printf("press enter to start",inter_24pt_bold, 0, love.graphics.getHeight() - 140, love.graphics.getWidth(), "center")

         love.graphics.printf("FC,AP Video from MajdataPlay",love.fonts.inter.bold["12"], 0, love.graphics.getHeight() - 20, love.graphics.getWidth(), "center")

end

function menu.keypressed(key)
    if key == "return" then
        print("Switch page")
        love.scene = love.scenes.song_select
    end
end



return menu
