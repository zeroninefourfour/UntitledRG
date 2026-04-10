-- main.lua


local fonts = {
  "assets/inter_static"
}
local scenes = {
  gameplay    = require("scenes.gameplay.main"),
  menu        = require("scenes.menu_deprecated"),
  song_select = require("scenes.song_select"),
  result      = require("scenes.result"),
  fatal       = require("scenes.fatal_ui"),
  welcome_v2  = require("scenes.views.welcome_ui"),
}

local cv_payload = nil
function love.setCrossViewPayload(data) cv_payload = data end
function love.getCrossViewPayload()    return cv_payload   end

local current_scene = nil

function love.switchScene(name, payload)
  local next = scenes[name]
  assert(next, "Unknown scene: " .. tostring(name))

  if current_scene and current_scene.exit then
    current_scene.exit()
  end

  if payload ~= nil then
    love.setCrossViewPayload(payload)
  end

  current_scene = next

  if current_scene.enter then
    current_scene.enter(love.getCrossViewPayload())
  end
end

local function loadInterFont(style, sizes)
  local path = ("assets/inter_static/Inter_24pt-%s.ttf"):format(style)
  local t = {}
  for _, size in ipairs(sizes) do
    t[tostring(size)] = love.graphics.newFont(path, size)
  end
  return t
end

-- ── LÖVE 回呼 ────────────────────────────────────────────
function love.load()
  love.window.setMode(1280, 720)
  love.window.setTitle("Untitled Rhythm Game (ver 0.0.1)")

  love.fonts = {
    inter = {
      bold    = loadInterFont("Bold",    { 12, 18, 24, 48 }),
      regular = loadInterFont("Regular", { 12, 18, 24, 48 }),
    }
  }

  love.switchScene("welcome_v2")
end

function love.draw()
  if current_scene and current_scene.draw then
    current_scene.draw()
  end
end

function love.update(dt)
  if current_scene and current_scene.update then
    current_scene.update(dt)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if current_scene and current_scene.keypressed then
    current_scene.keypressed(key, scancode, isrepeat)
  end
end

function love.keyreleased(key, scancode, isrepeat)
  if current_scene and current_scene.keyreleased then
    current_scene.keyreleased(key, scancode, isrepeat)
  end
end