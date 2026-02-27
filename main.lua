
-- 場景
local sences = {
   gameplay =  require("scenes.gameplay"),
   menu = require("scenes.menu")
}

local current_sence = nil
-- 啟動先將場景設成開始菜
current_sence = sences.gameplay


function love.draw()
  if current_sence then
    current_sence.draw()
  end
end

function love.update()
  if current_sence then
     current_sence.update()
  end
end
function love.keypressed(key, scancode, isrepeat)
  if current_sence and current_sence.keypressed then
    current_sence.keypressed(key, scancode, isrepeat)
  end
end

-- skibidi

