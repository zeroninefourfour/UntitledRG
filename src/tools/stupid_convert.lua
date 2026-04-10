local inputFile = "beatmap7f58e6153305470f92ea230fc84dd451.osu"   -- change to your .osu filename
local outputFile = "output.lua" -- generated table

local file = io.open(inputFile, "r")
if not file then
    error("Failed to open file.")
end

local inHitObjects = false
local notes = {}

for line in file:lines() do
    if line:match("^%[HitObjects%]") then
        inHitObjects = true
    elseif inHitObjects and line ~= "" then
        -- Split CSV line
        local values = {}
        for v in line:gmatch("([^,]+)") do
            table.insert(values, v)
        end

        -- Make sure we have at least x,y,time
        if #values >= 3 then
            local y = tonumber(values[2])
            local time = tonumber(values[3])

            table.insert(notes, {
                y = 0.5,
                time = time / 1000
            })
        end
    end
end

file:close()

-- Write output
local out = io.open(outputFile, "w")
out:write("return {\n")

for _, note in ipairs(notes) do
    out:write(string.format(
        "    { y = %s, time = %s },\n",
        note.y,
        note.time
    ))
end

out:write("}\n")
out:close()

print("Conversion complete. Saved to " .. outputFile)