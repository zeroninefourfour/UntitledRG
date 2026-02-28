local track_lists = {{
    name = "Kyu-kurarin",
    artist = "Iyowa",
    audio_path = "music/全世界共通リズム感テスト.flac",
    cover_path = "covers/全世界共通リズム感テスト.jpg",
    difficulties = {{
        name = "easy skibidi lv.1",
        level = 1,
    }}
}}
local active_track = nil
local ss = {}
local active_index = 0
local diff_index = 0
local max_index = 0
local current_offset = 0
local difficulty_current_offset = 0
local animation_speed = 0.15
local difficulty_index = 1

local preview_audio = nil
ss.update = function()
    -- Smooth animation to target position
    local target_offset = active_index
    current_offset = current_offset + (target_offset - current_offset) * animation_speed

    local difficulty_target_offset = active_index
    difficulty_current_offset = difficulty_current_offset + (difficulty_target_offset - difficulty_current_offset) *
                                    animation_speed

end

ss.draw = function()
          love.graphics.setBackgroundColor(214 / 255, 138/ 255, 133 /255)

    love.graphics.push()

    if active_track then
      --  love.graphics.translate(-100, 0)

    end

    max_index = #track_lists
    for index, track in pairs(track_lists) do
        love.graphics.setColor(1, 1, 1, 0.5)
        if index == active_index then
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.print(track.name .. " - " .. track.artist, love.fonts.inter.bold["24"], 100,
            150 + (index - current_offset) * 50)
        love.graphics.print("DIFFICULTY [0.00-9.99]", love.fonts.inter.bold["12"], 100,
            180 + (index - current_offset) * 50)
    end
    -- draw difficulty select
    if active_track then

        love.graphics.translate(100, 0)
        for index, difficulty in pairs(active_track.difficulties) do
            if index == difficulty_index then
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(1, 1, 1, 0.5)
            end

            love.graphics.print("easy skibidi lv1", love.fonts.inter.bold["24"], 450,
                150 + (active_index - current_offset) * 50)

        end
    else
        love.graphics.setColor(1, 1, 1, 0)
        love.graphics.print("Unselected", love.fonts.inter.bold["24"], 450, 150 + (active_index - current_offset) * 50)

    end
    love.graphics.pop()

end

ss.keypressed = function(key)
    if key == "down" then
        if max_index > active_index then
            if active_track then
                difficulty_index = difficulty_index + 1

            else

                active_index = active_index + 1
            end
        end

    end
    if key == "up" then
        if active_index > 0 then
            if active_track then
                difficulty_index = difficulty_index - 1

            else

                active_index = active_index - 1
            end
        end

    end
    if key == "esc" then
        active_track = nil
        active_index = 0
        difficulty_index = 1
    end
    if key == "return" and active_index > 0 then
        if active_track then
            love.scenes.gameplay.reset()
            love.scene = love.scenes.gameplay
        end
        active_track = track_lists[active_index]
        print("Selected track: " .. active_track.name)

    end
end
return ss
