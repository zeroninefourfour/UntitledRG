local menu = {}
local timer = 0
 local initalized = false

 
local inter_48pt_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 48)
local inter_24pt_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 24)
local background = love.graphics.newImage("assets/cool_blur.png")
local e1 = love.graphics.newImage("assets/icons/enter1.png")
 local e2 = love.graphics.newImage("assets/icons/enter2.png")
 local json = require("modules.json")
local keyframes = {
    -- 1 to 34
    love.graphics.newImage("assets/result_character_animations/1.png"),
    love.graphics.newImage("assets/result_character_animations/2.png"),
    love.graphics.newImage("assets/result_character_animations/3.png"),
    love.graphics.newImage("assets/result_character_animations/4.png"),
    love.graphics.newImage("assets/result_character_animations/5.png"),
    love.graphics.newImage("assets/result_character_animations/6.png"),
    love.graphics.newImage("assets/result_character_animations/7.png"),
    love.graphics.newImage("assets/result_character_animations/8.png"),
    love.graphics.newImage("assets/result_character_animations/9.png"),
    love.graphics.newImage("assets/result_character_animations/10.png"),
    love.graphics.newImage("assets/result_character_animations/11.png"),
    love.graphics.newImage("assets/result_character_animations/12.png"),
    love.graphics.newImage("assets/result_character_animations/13.png"),
    love.graphics.newImage("assets/result_character_animations/14.png"),
    love.graphics.newImage("assets/result_character_animations/15.png"),
    love.graphics.newImage("assets/result_character_animations/16.png"),
    love.graphics.newImage("assets/result_character_animations/17.png"),
    love.graphics.newImage("assets/result_character_animations/18.png"),
    love.graphics.newImage("assets/result_character_animations/19.png"),
    love.graphics.newImage("assets/result_character_animations/20.png"),
    love.graphics.newImage("assets/result_character_animations/21.png"),
    love.graphics.newImage("assets/result_character_animations/22.png"),
    love.graphics.newImage("assets/result_character_animations/23.png"),
    love.graphics.newImage("assets/result_character_animations/24.png"),
    love.graphics.newImage("assets/result_character_animations/25.png"),
    love.graphics.newImage("assets/result_character_animations/26.png"),
    love.graphics.newImage("assets/result_character_animations/27.png"),
    love.graphics.newImage("assets/result_character_animations/28.png"),
    love.graphics.newImage("assets/result_character_animations/29.png"),
    love.graphics.newImage("assets/result_character_animations/30.png"),
    love.graphics.newImage("assets/result_character_animations/31.png"),
    love.graphics.newImage("assets/result_character_animations/32.png"),
    love.graphics.newImage("assets/result_character_animations/33.png"),
    love.graphics.newImage("assets/result_character_animations/34.png")
    
}
 local scores = {
    critical = 123,
    perfect = 67,
    great = 67,
    good = 67,
    miss = 67
 }
 local percentage = 0
local cv_data = {
    scores = {
        critical = 123,
        perfect = 67,
        great = 67,
        good = 67,
        miss = 67
    },
}
function menu.update(dt)
    if not initalized then
        menu.load()
    end
end
 function menu.load()

    cv_data = love.getCrossViewPayload()
    if cv_data then
        print("Recevied cross-view payload:", cv_data)
        print(json.encode(cv_data)) -- Print the payload in JSON format for easier readability
        scores = cv_data.scores 
            initalized = true
        -- Calculated percentage
        local total_notes = cv_data.total_notes or 0
        if total_notes > 0 then
            percentage = ((scores.critical * 1.0 + scores.perfect * 0.8 + scores.great * 0.5 + scores.good * 0.2) / total_notes) * 100
        else
            percentage = 0
        end
       else
        print("No cross-view payload received.")
        love.scene = love.scenes.menu
        initalized = false
    end
 end

 local t = 1
 function menu.drawAnimation()
    love.graphics.draw(keyframes[math.floor(t)], love.graphics.getWidth() - 300, 300, 0.5,0.5)
    t = t + 1 
    if (t > #keyframes) then
        t = 1 end
 end
 function menu.draw()
    menu.drawAnimation()
    love.graphics.draw(e1, 50, love.graphics.getHeight() - 50)
    love.graphics.draw(e2, 66, love.graphics.getHeight() - 50)
    love.graphics.print("Next", love.fonts.inter.regular["12"], 90, love.graphics.getHeight() - 51)
    love.graphics.setBackgroundColor(214 / 255, 138 / 255, 133 / 255)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(inter_48pt_bold)

    love.graphics.printf("Completion Rate ", love.fonts.inter.regular["24"], 100, 200, love.graphics.getWidth())
    love.graphics.printf(percentage .. "% ", love.fonts.inter.bold["48"], 100, 230, love.graphics.getWidth())

    love.graphics.printf("CRICITAL PERFECT | " .. scores.critical, love.fonts.inter.regular["24"], 100, 290, love.graphics.getWidth())
    love.graphics.printf("PERFECT | " .. scores.perfect, love.fonts.inter.regular["24"], 100, 320, love.graphics.getWidth())
    love.graphics.printf("GREAT | " .. scores.great, love.fonts.inter.regular["24"], 100, 350, love.graphics.getWidth())
    love.graphics.printf("GOOD | " .. scores.good, love.fonts.inter.regular["24"], 100, 380, love.graphics.getWidth())
    love.graphics.printf("MISS | " .. scores.miss, love.fonts.inter.regular["24"], 100, 410, love.graphics.getWidth())

end

function menu.keypressed(key)
    if key == "return" then
        print("Switch page")
        
        love.scene = love.scenes.song_select
            initalized = false

    end
end

return menu
