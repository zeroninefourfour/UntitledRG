local gameplay = {}

local note_icon = love.graphics.newImage("assets/note.png")
local scroll_speed = 64.0

local debug_note = false
-- Playback things
local audioInstance = nil
local playback = {
    time = 0,
    length = 0,
    paused = 0
}

local near_notes = {}
local notes = {}

for i = 1, 100 do
    table.insert(notes, {
        type = "cricital",
        y = 0.5,
        time = 15 + i * 5
    })
end
local last_visible_note_index = 1
-- Playback things

gameplay.init = function()
    audioInstance = love.audio.newSource("music.mp3", "static")

end

gameplay.start = function()
    audioInstance:play()

end

gameplay.update = function()
    -- love.graphics.translate(playback.time * scroll_speed, 0)
    playback.time = playback.time + 0.1

end

gameplay.drawNote = function(note_HitTime, Y_Position)
    local hitX = 100
    love.graphics.draw(note_icon, hitX + (note_HitTime - playback.time) * scroll_speed, Y_Position, 0, 0.05, 0.05)
end
gameplay.drawJudgementText = function(type)
    love.graphics.print(type, 200, 200)
end
gameplay.drawJudgementLine = function()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineWidth(2)
    love.graphics.line(100, love.graphics.getHeight(), 100, 0);
end
gameplay.draw = function()
    love.graphics.setColor(1, 1, 1)

    gameplay.drawJudgementLine()
    -- print(playback.time)
    near_notes = {}

    for index, note in pairs(notes) do
        local calculated_note_appearX = note.time + (note.time - playback.time) * scroll_speed
        -- Check if the note is within the visible area
       if debug_note then
 print("Note Calculation: ", note.time, playback.time, calculated_note_appearX)
        print("Note Abs: ", math.abs(note.time - playback.time))
        print("NearNotes: ", #near_notes)
        print("NoteCounts: ", #notes)        end
        if (math.abs(note.time - playback.time) < 1) then
            table.insert(near_notes, note)
        end
        if (calculated_note_appearX > love.graphics.getWidth()) then
            break -- No need to draw notes that are off-screen to the right
        end

        gameplay.drawNote(note.time, note.y * love.graphics.getHeight())
    end

end

function gameplay.keypressed(key, scancode, isrepeat)
    print(key  )
    if key == "z" or key == "x" then
       for index, note in pairs(near_notes) do
            if math.abs(note.time - playback.time) < 0.5 then
                local latency = math.abs(note.time - playback.time)
                print("Hit! Latency: ", latency)
                if latency < 0.05 then
                    print("Cricital Perfect!")
                elseif latency < 0.1 then
                    print("Perfect!")
                elseif latency < 0.25 then
                    print("Great!")
                elseif latency < 1 then
                    print("Good!")
                elseif latency < 1.5 then
                    print("Bad!")
                else
                    print("Miss!")
                end
                 break
            end

        end
    end
end
return gameplay;
