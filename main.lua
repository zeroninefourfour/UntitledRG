function saferequire(module)
  local success, result = pcall(require, module)
  if not success then
    print("Error loading module '" .. module .. "': " .. tostring(result))
    return nil
  else
    print("Successfully loaded module: " .. module)
  end
  return result
end

-- main.lua

local love_assetmanager = require("src.core_utils.AssetManager")
love.assets = love_assetmanager

local transition_state = ""
local selected_transition_animation = ""

local cv_payload = nil

function love.setCrossViewPayload(data) cv_payload = data end
function love.getCrossViewPayload() return cv_payload end

local current_scene = nil


local scenes = {
  gameplay    = saferequire("src.scenes.gameplay.main"),
  menu        = saferequire("src.scenes.menu_deprecated"),
  song_select = saferequire("src.scenes.song_select"),
  result      = saferequire("src.scenes.result"),
  fatal       = saferequire("src.ui.fatal_ui"),
  welcome_v2  = saferequire("src.ui.welcome_ui"),
}

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
    t[tostring(size)] = love.assets.newFont(path, size)
  end
  return t
end

-- Load

-- ── LÖVE 回呼 ────────────────────────────────────────────
function love.load()
  love.window.setMode(1280, 720)
  love.window.setTitle("Untitled Rhythm Game (ver 0.0.1)")

  love.fonts = {
    inter = {
      bold    = loadInterFont("Bold", { 12, 18, 24, 48 }),
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
