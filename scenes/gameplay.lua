local json = require("modules.json")
local bgr = require("scenes.backgroundRender")

local gameplay = {}
gameplay.notes = {}
gameplay.judgement = {}
local gready = false

local note_icon = love.graphics.newImage("assets/note.png")
local inter_24pt_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 12)

local inter18px_bold = love.graphics.newFont("assets/inter_static/Inter_24pt-Bold.ttf", 18)
local j = love.graphics.newImage("assets/icons/j.png")

local k = love.graphics.newImage("assets/icons/k.png")
-- Audio
local audioInstance = love.audio.newSource("music/Kyu-krarin/audio.mp3", "stream")
local hitsound = love.audio.newSource("music/hitsound.wav", "static")

local scores = {
    critical = 0,
    perfect = 0,
    great = 0,
    good = 0,
    miss = 0
}
local hs = {}

local playback = {
    time = 0,
    length = 0,
    paused = 0
}
-- Character
local keys_held = {}
local character = {
    y = 0,
    image = love.graphics.newImage("assets/teto.jpg"),
    forms = {
        yellow = {love.graphics.newImage("assets/characters/red/1.png"),
                  love.graphics.newImage("assets/characters/red/2.png"),
                  love.graphics.newImage("assets/characters/red/3.png"),
                  love.graphics.newImage("assets/characters/red/4.png"),
                  love.graphics.newImage("assets/characters/red/5.png"),
                  love.graphics.newImage("assets/characters/red/6.png"),
                  love.graphics.newImage("assets/characters/red/7.png"),
                  love.graphics.newImage("assets/characters/red/8.png"),
                  love.graphics.newImage("assets/characters/red/9.png"),
                  love.graphics.newImage("assets/characters/red/10.png"),
                  love.graphics.newImage("assets/characters/red/11.png"),
                  love.graphics.newImage("assets/characters/red/12.png"),
                  love.graphics.newImage("assets/characters/red/13.png"),
                  love.graphics.newImage("assets/characters/red/14.png"),
                  love.graphics.newImage("assets/characters/red/15.png"),
                  love.graphics.newImage("assets/characters/red/16.png")},
        green = {love.graphics.newImage("assets/characters/green/1.png"),
                 love.graphics.newImage("assets/characters/green/2.png"),
                 love.graphics.newImage("assets/characters/green/3.png"),
                 love.graphics.newImage("assets/characters/green/4.png"),
                 love.graphics.newImage("assets/characters/green/5.png"),
                 love.graphics.newImage("assets/characters/green/6.png"),
                 love.graphics.newImage("assets/characters/green/7.png"),

                 love.graphics.newImage("assets/characters/green/8.png"),
                 love.graphics.newImage("assets/characters/green/9.png"),
                 love.graphics.newImage("assets/characters/green/10.png"),
                 love.graphics.newImage("assets/characters/green/11.png"),
                 love.graphics.newImage("assets/characters/green/12.png"),
                 love.graphics.newImage("assets/characters/green/13.png"),
                 love.graphics.newImage("assets/characters/green/14.png"),
                 love.graphics.newImage("assets/characters/green/15.png"),

                 love.graphics.newImage("assets/characters/green/16.png")},
        blue = {love.graphics.newImage("assets/characters/blue/1.png"),
                love.graphics.newImage("assets/characters/blue/2.png"),
                love.graphics.newImage("assets/characters/blue/3.png"),
                love.graphics.newImage("assets/characters/blue/4.png"),
                love.graphics.newImage("assets/characters/blue/5.png"),
                love.graphics.newImage("assets/characters/blue/6.png"),
                love.graphics.newImage("assets/characters/blue/7.png"),

                love.graphics.newImage("assets/characters/blue/8.png"),
                love.graphics.newImage("assets/characters/blue/9.png"),
                love.graphics.newImage("assets/characters/blue/10.png"),
                love.graphics.newImage("assets/characters/blue/11.png"),
                love.graphics.newImage("assets/characters/blue/12.png"),
                love.graphics.newImage("assets/characters/blue/13.png"),
                love.graphics.newImage("assets/characters/blue/14.png"),
                love.graphics.newImage("assets/characters/blue/15.png"),

                love.graphics.newImage("assets/characters/blue/16.png")}
    }
}

-- Note related
local scroll_speed = 256.0
local traget_scroll_speed = 256
local image_size = 717 * 0.05
local debug_note = false
local useMouse = false
local isCharting = false
local near_notes = {}
local notes_judgement_result = {}
local notes = love.filesystem.read("music/Kyu-krarin/basic.json")
local note_color = {1, 1, 1}
notes = json.decode(notes)

local acceleration = 0

local hiddenIndex = {}
--[[
  {
     length = 0
     animation
  }

]] --
local animation_tables = {}
local tt = 0
local auto = false

local last_visible_note_index = 1

local combo_count = 0
local MISS_WINDOW = 0.35 -- seconds past note time before it's a miss
-- Playback things

gameplay.init = function()

end

gameplay.reset = function()
    hiddenIndex = {}
    animation_tables = {}
    notes_judgement_result = {}
    near_notes = {}
    combo_count = 0
    acceleration = 0
    character.y = 0.5
    character.current_form = "green"
    scroll_speed = 256.0
    traget_scroll_speed = 256.0
    note_color = {1, 1, 1}
    gready = false
    tt = 0
    -- Reset note ended flags
    for _, note in pairs(notes) do
        note.ended = nil
    end
    audioInstance:stop()
    audioInstance:seek(0)
end

gameplay.start = function()
    audioInstance:play()
    audioInstance:setLooping(false)
end

gameplay.update = function(dt)
    bgr.update(dt)

    if not audioInstance:isPlaying() then
        if not gready then gameplay.start() gready = true return end
         
        print("Game ended, switching to result screen")
        love.setCrossViewPayload({
            scores = scores,
            total_notes = #notes,
            combo = combo_count
        })
        love.scene = love.scenes.result
    end
    if traget_scroll_speed ~= scroll_speed then
        scroll_speed = scroll_speed + (traget_scroll_speed - scroll_speed) * dt * 5
    end

    playback.time = audioInstance:tell()

    local accelRate = 5.0 -- how fast speed builds up (screen units/sec^2)
    local maxSpeed = 3 -- max speed (screen units/sec)

    local movingDown = keys_held["s"] and not keys_held["w"]
    local movingUp = keys_held["w"] and not keys_held["s"]

    if movingDown then
        acceleration = math.min(acceleration + accelRate * dt, maxSpeed)
        character.y = character.y + acceleration * dt
    elseif movingUp then
        acceleration = math.min(acceleration + accelRate * dt, maxSpeed)
        character.y = character.y - acceleration * dt
    else
        acceleration = 0
    end

    if character.y >= 1 then
        character.y = 1
        acceleration = 0
    elseif character.y <= 0 then
        character.y = 0
        acceleration = 0
    end

    if useMouse then
        character.y = love.mouse.getPosition() / love.graphics.getHeight()
    end

    -- Miss detection: auto-miss notes whose window has expired
    for index, note in pairs(notes) do
        if not note.event and not hiddenIndex[index] then
            if playback.time - note.time > MISS_WINDOW then
                hiddenIndex[index] = true
                combo_count = 0
                table.insert(notes_judgement_result, {
                    type = "miss",
                    length = 1.5,
                    elapsed = 0,
                    originalY = (note.y or 0.5) * love.graphics.getHeight()
                })
            end
        end
    end
end

gameplay.notes.drawHitAnimation = function()
    for index, animation in pairs(animation_tables) do
        if animation.elapsed > animation.length then
            table.remove(animation_tables, index)

        end

        love.graphics.setColor(1, 1, 1, (1 / animation.length) * (animation.length - animation.elapsed))

        local rad = animation.elapsed * math.pi
        local calculatedY = animation.originalY

        if (animation.x < 0) then
            animation.x = 0
        end
        calculatedY = calculatedY + (animation.elapsed * animation.elapsed * 100)
        love.graphics.draw(note_icon, 100 + animation.x + animation.elapsed * 50, calculatedY, rad, 0.05, 0.05)

        animation.elapsed = animation.elapsed + 0.1

        love.graphics.setColor(1, 1, 1, 1)

    end
end
gameplay.notes.drawNote = function(note_HitTime, Y_Position)
    if not Y_Position then
        return
    end
    love.graphics.setColor(unpack(note_color))
    local hitX = 100
    love.graphics.draw(note_icon, hitX + (note_HitTime - playback.time) * scroll_speed,
        love.graphics.getHeight() * Y_Position, 0, 0.05, 0.05)
    love.graphics.setColor(1, 1, 1)

end
gameplay.notes.draw = function()
    near_notes = {}
    for index, note in pairs(notes) do
        note.id = index
        local calculated_note_appearX = note.time + (note.time - playback.time) * scroll_speed
        -- Check if the note is within the visible area
        if (note.event) then
            if (note.time <= playback.time and not note.ended) then
                note.ended = true
                if note.type == "switch_form" then
                    print("Recevied switch_form")
                    if note.form == "slow" then
                        print("Switching to slow form")
                        character.current_form = "blue"
                        traget_scroll_speed = 128
                        note_color = {1, 1, 1}

                    elseif note.form == "normal" then
                        print("Switching to normal form")
                        character.current_form = "green"
                        traget_scroll_speed = 256.0
                        note_color = {1, 1, 1}
                    elseif note.form == "fast" then
                        print("Switching to fast form")
                        character.current_form = "yellow"
                        traget_scroll_speed = 256 * 3
                        note_color = {1, 1, 1}
                    end

                    bgr.setForm(character.current_form)
                end
                if note.type == "switch_speed" then
                    print("Received switch_speed")
                    scroll_speed = note.speed
                end
            end
        end
        if debug_note then
            print("Note Calculation: ", note.time, playback.time, calculated_note_appearX)
            print("Note Abs: ", math.abs(note.time - playback.time))
            print("NearNotes: ", #near_notes)
            print("NoteCounts: ", #notes)
        end
        if (math.abs(note.time - playback.time) < 1) then
            table.insert(near_notes, note)
        end
        if (calculated_note_appearX > love.graphics.getWidth()) then
            break -- No need to draw notes that are off-screen to the right
        end

        if not hiddenIndex[note.id] then
            gameplay.notes.drawNote(note.time, note.y)
        end
    end
end

gameplay.drawKeyguide = function()
    love.graphics.draw(j, 50, love.graphics.getHeight() - 50, 0, 2, 2)
    love.graphics.draw(k, 82, love.graphics.getHeight() - 50, 0, 2, 2)
    love.graphics.print("Hit Note", love.fonts.inter.regular["12"], 124, love.graphics.getHeight() - 40)
end
gameplay.judgement.drawResultAnimation = function(type)
    for index, animation in pairs(notes_judgement_result) do
        if animation.elapsed > animation.length then
            table.remove(notes_judgement_result, index)
        end

        if animation.type == "critical" then
            love.graphics.setColor(1, 1, 174 / 255, 1 - (animation.elapsed / animation.length))
            love.graphics.print("Critical Perfect!", inter18px_bold, 74, animation.originalY - 36)
        elseif animation.type == "perfect" then
            love.graphics.setColor(1, 1, 255 / 174, 1 - (animation.elapsed / animation.length))

            love.graphics.print("Perfect!", inter18px_bold, 74, animation.originalY - 36)
        elseif animation.type == "great" then
            love.graphics.setColor(23 / 255, 191 / 255, 68 / 255, 1 - (animation.elapsed / animation.length))
            love.graphics.print("Great!", inter18px_bold, 74, animation.originalY - 36)
        elseif animation.type == "miss" then
            love.graphics.setColor(1, 0.2, 0.2, 1 - (animation.elapsed / animation.length))
            love.graphics.print("Miss!", inter18px_bold, 74, animation.originalY - 36)
        end

        animation.elapsed = animation.elapsed + 0.1

        love.graphics.setColor(1, 1, 1, 1)

    end
end
gameplay.judgement.drawLine = function()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(100, love.graphics.getHeight(), 100, 0);
end

local c_frame = 1

gameplay.drawCharacter = function()
    -- print("Draw character: ", character.y)
    c_frame = c_frame + 1
    if c_frame > 16 then
        c_frame = 1
    end
    c_frame = c_frame % 16 
   if c_frame == 0 then c_frame = 1 end

    local form_spirits = character.forms[character.current_form or "green"]
    print(math.floor(c_frame))
    love.graphics.draw(form_spirits[math.floor(c_frame)], 65, character.y * love.graphics.getHeight(), 0, 0.07, 0.07)
end
gameplay.drawCombo = function()
    if combo_count > 3 then
        -- local text = love.graphics.print("COMBO", love.fonts.inter.bold["12"], love.graphics.getWidth() / 2, 12, 0)
        local text = love.graphics.print(combo_count, love.fonts.inter.bold["48"], love.graphics.getWidth() / 2, 60, 0)

    end
end
gameplay.draw = function()
    love.graphics.setColor(1, 1, 1)

    bgr.draw()
    gameplay.drawCombo()
    gameplay.judgement.drawLine()
    gameplay.drawKeyguide()

    love.graphics.setColor(1, 1, 1, 1)

    gameplay.notes.draw()
    gameplay.drawCharacter()
    gameplay.notes.drawHitAnimation()
    gameplay.judgement.drawResultAnimation()
    -- print(playback.time)

end

function gameplay.keyreleased(key)
    if key == "w" or key == "s" then
        keys_held[key] = nil
    end
end
function gameplay.keypressed(key, scancode, isrepeat)

    if isCharting then
        if key == "z" then
            audioInstance:setPitch(0.5)
            table.insert(notes, {
                y = character.y,
                time = playback.time
            })
            print("Recorded note at time: ", playback.time, " with y: ", character.y)

        end
        if key == "r" then

            print(json.encode(notes))
        end
    end
    
    if key == "escape" then
       audioInstance:pause()
    end
    
    if key == "w" or key == "s" then
        -- reset acceleration when switching direction (e.g. was going down, now going up)
        if (key == "w" and keys_held["s"] == nil) or (key == "s" and keys_held["w"] == nil) then
            acceleration = 0
        end
        keys_held[key] = true
    end
    if key == "j" or key == "k" then
        for index, note in pairs(near_notes) do
            local latency = math.abs(note.time - playback.time)
            local calculated_note_appearX = note.time + (note.time - playback.time) * scroll_speed

            if (hiddenIndex[note.id]) then
                print("Note already hit, skipping...")
            else
                if math.abs(note.time - playback.time) < 0.5 then
                    if (note.y == nil) then
                        return
                    end
                    if (math.abs(character.y - note.y) < 0.1) then
                        print("Hit! Latency: ", latency, " Character note distance: ", math.abs(character.y - note.y))
                        table.insert(animation_tables, {
                            type = "hit",
                            length = 2,
                            elapsed = 0,
                            originalY = character.y * love.graphics.getHeight(),
                            x = calculated_note_appearX
                        })
                        hiddenIndex[note.id] = true
                        hitsound:clone():play()
                        if latency < 0.05 then
                            scores.critical = scores.critical + 1

                            table.insert(notes_judgement_result, {
                                type = "critical",
                                length = 2,
                                elapsed = 0,
                                originalY = note.y * love.graphics.getHeight()
                            })
                            combo_count = combo_count + 1
                        elseif latency < 0.1 then
                            scores.perfect = scores.perfect + 1

                            table.insert(notes_judgement_result, {
                                type = "perfect",
                                length = 2,
                                elapsed = 0,
                                originalY = note.y * love.graphics.getHeight()
                            })
                            combo_count = combo_count + 1
                        elseif latency < 0.25 then
                            scores.great = scores.great + 1

                            table.insert(notes_judgement_result, {
                                type = "great",
                                length = 2,
                                elapsed = 0,
                                originalY = note.y * love.graphics.getHeight()
                            })
                            combo_count = combo_count + 1
                        elseif latency < 0.3 then
                            scores.good = scores.good + 1
                            combo_count = combo_count + 1
                        elseif latency < 0.4 then
                            print("Bad!")
                            combo_count = 0
                        else
                            print("Miss!")
                            scores.miss = scores.miss + 1
                            combo_count = 0
                        end
                        break
                    else
                        print("Bad position!")

                    end

                end
            end

        end
    end
end
return gameplay;
