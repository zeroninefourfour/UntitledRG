
-- 場景
local sences = {
   gameplay =  require("gameplay.lua"),
   menu = require("menu.lua")
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


-- skibidi

