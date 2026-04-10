--[[

OSZLua V14

]]


local osu = {}

function split_str(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function osu.parseSections(text)
  local sections = {}
  local currentSection = nil

  for line in text:gmatch("[^\n]+") do
    local sectionName = line:match("^%[(.+)%]$")

    if sectionName then
      currentSection = sectionName
      sections[currentSection] = ""
    elseif currentSection then
      if sections[currentSection] == "" then
        sections[currentSection] = line
      else
        sections[currentSection] = sections[currentSection] .. "\n" .. line
      end
    end
  end

  return sections
end
function osu.parse(data)
    local parsed = {}

    local sections = osu.parseSections(data)
    print(#sections)
end

return osu
