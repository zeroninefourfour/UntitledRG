local bgr = {}

-- Checkerboard tile size in pixels
local TILE = 80

-- Color palettes per form  (primary = O cell, secondary = X cell)
local PALETTES = {
    default = {
        primary   = {0.14, 0.14, 0.18},
        secondary = {0.09, 0.09, 0.13},
    },

    -- red
    yellow = {
        primary   = {0.82, 0.14, 0.14},
        secondary = {0.44, 0.05, 0.05},
    },
    green = {
        primary   = {0.15, 0.76, 0.26},
        secondary = {0.05, 0.40, 0.12},
    },
    blue = {
        primary   = {0.18, 0.38, 0.92},
        secondary = {0.06, 0.16, 0.52},
    },

    -- no
    yellow2 = {
        primary   = {0.96, 0.82, 0.10},
        secondary = {0.55, 0.46, 0.05},
    },
}

-- Current displayed colors (updated every frame during transition)
local cur_primary   = {unpack(PALETTES.default.primary)}
local cur_secondary = {unpack(PALETTES.default.secondary)}

-- Transition state
local from_primary   = {unpack(cur_primary)}
local from_secondary = {unpack(cur_secondary)}
local to_primary     = {unpack(cur_primary)}
local to_secondary   = {unpack(cur_secondary)}

local TRANSITION_DURATION = 0.5
local transition_t = 1.0   -- 1.0 = finished, no active transition

-- ── helpers ──────────────────────────────────────────────────────────────────

local function lerp(a, b, t)    return a + (b - a) * t end

local function lerpColor(from, to, t)
    return { lerp(from[1], to[1], t),
             lerp(from[2], to[2], t),
             lerp(from[3], to[3], t) }
end

local function smoothstep(t)    return t * t * (3 - 2 * t) end

-- ── public API ───────────────────────────────────────────────────────────────

-- Call this whenever the game form / color changes.
function bgr.setForm(form)
    local palette = PALETTES[form] or PALETTES.default
    -- Skip if we're already targeting this palette
    if palette.primary[1] == to_primary[1] and
       palette.primary[2] == to_primary[2] and
       palette.primary[3] == to_primary[3] then
        return
    end
    from_primary   = {unpack(cur_primary)}
    from_secondary = {unpack(cur_secondary)}
    to_primary     = {unpack(palette.primary)}
    to_secondary   = {unpack(palette.secondary)}
    transition_t   = 0.0
end

function bgr.update(dt)
    if transition_t < 1.0 then
        transition_t  = math.min(transition_t + dt / TRANSITION_DURATION, 1.0)
        local t       = smoothstep(transition_t)
        cur_primary   = lerpColor(from_primary,   to_primary,   t)
        cur_secondary = lerpColor(from_secondary, to_secondary, t)
    end
end

--[[
  Draws a full-screen checkerboard:
      O X O X …     (O = primary, X = secondary)
      X O X O …
      O X O X …
      …
]]
function bgr.draw()
    local W    = love.graphics.getWidth()
    local H    = love.graphics.getHeight()
    local cols = math.ceil(W / TILE) + 1
    local rows = math.ceil(H / TILE) + 1

    -- make the partten fells like movement
    love.graphics.translate(0, math.sin(love.timer.getTime() * 2) * 10)
    for row = 0, rows do
        for col = 0, cols do
            if (row + col) % 2 == 0 then
                love.graphics.setColor(cur_primary)
            else
                love.graphics.setColor(cur_secondary)
            end
            love.graphics.rectangle("fill", col * TILE, row * TILE, TILE, TILE)
        end
    end

    -- restore default color so other draw calls aren't tinted
    love.graphics.setColor(0, 0, 0, 0.2)

    love.graphics.rectangle("fill", 0, 0, W, H);
    love.graphics.setColor(1, 1, 1, 1)
end

return bgr