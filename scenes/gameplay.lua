local gameplay = {}


local note_icon = love.graphics.newImage("assets/note.png")
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
  -- audioInstance:play()
   
  playback.time = playback.time + 1 / 60
end

gameplay.update = function()
 love.graphics.translate(playback.time * scroll_speed, 0)

end

gameplay.draw = function()
      love.graphics.setColor(1, 1, 1)

   love.graphics.draw( note_icon, love.graphics.getWidth() - (playback.time * scroll_speed), 0, 0, 0.05,0.05)
   print(playback.time)
print( love.graphics.getWidth() - (playback.time * scroll_speed))
     love.graphics.setColor(1, 1, 1,0.5)
  love.graphics.setLineWidth(2)
  love.graphics.line(100,love.graphics.getHeight(),100, 0);
 
end
return gameplay;
  