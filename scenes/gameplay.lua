local gameplay = {}


local note_icon = love.graphics.newImage("../assets/note.png")
local scroll_speed = 16.0

-- Playback things
local audioInstance = nil
local playback = {
    time = 0,
    length = 0,
    paused = 0
}


local notes = {
    {
      type = "cricital",
      y = 0.5,
      time = 0.1,
    }
}
-- Playback things

gameplay.init  = function()
  audioInstance = love.audio.newSource("music.mp3", "static")

end

gameplay.start = function()
  audioInstance:play()
end

gameplay.update = function()
 love.graphics.translate(time * scroll_speed, 0)

end

gameplay.draw = function()
  love.graphics.draw( note_icon, 100, 50)
  
end
return gameplay;
