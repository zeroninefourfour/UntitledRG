
-- 場景
local scenes = {
   gameplay =  require("scenes.gameplay"),
   menu = require("scenes.menu"),
   song_select = require("scenes.song_select"),
   result = require("scenes.result")
}

local cv_payload = nil
function love.setCrossViewPayload(data)
  cv_payload = data
end
function love.getCrossViewPayload()
   
  return cv_payload
end

   love.window.setMode(1280, 720)
   love.window.setTitle("Untitled Rhythm Game (ver 114.5.1.4)")
function love.draw()
  -- Key guidelines
  
  --
    if love.scene and love.scene.draw then
    love.scene.draw()
  end
   
end
function love.load()
  
  love.scenes = scenes
   love.scene = scenes.menu
   love.fonts = {
    inter = {
      bold = {
        ["12"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 12),
        ["24"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 24),
        ["48"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 48)

       },

       regular = {
        ["12"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Regular.ttf", 12),
        ["24"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Regular.ttf", 24),
        ["48"] = love.graphics.newFont("assets/inter_static/Inter_24pt-Regular.ttf", 48)

       }
    }
   }


end
function love.update(dt)
    
  if love.scene and love.scene.update then
     love.scene.update(dt)
  end
end
function love.keypressed(key, scancode, isrepeat)
  if love.scene and love.scene.keypressed then
    love.scene.keypressed(key, scancode, isrepeat)
  end
end
function love.keyreleased(key,scancode, isrepeat)
  if love.scene and love.scene.keyreleased then
    love.scene.keyreleased(key, scancode, isrepeat)
  end

  
end
-- skibidi

