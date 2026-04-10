local am = {}

am.basePath = "src"
am.paths = {
    ["@"] = "src"
}

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

function parse_path(path)

    local dir = {
        
    }
    if am.basePath then
        dir[#dir + 1] = am.basePath
    end
    if am.paths[string.sub(path,1,1)] then
        dir[#dir + 1] = am.paths[string.sub(path,1,1)] 
    end
    --
    local dir_splited = split_str(path,"/")
 
    for i = 1,#dir_splited do
        dir[#dir + 1] = dir_splited[i]
    end
   
  
    return dir

end

function convert_util(path,type)
    if type == "lua_module" then
        return table.concat(path,".")
    elseif type == "fs_path" then
        return table.concat(path,"/")
    end 
end
am.loadImage = function (path)
    assert(path ~= "string","Path must be string")
    return love.graphics.newImage(convert_util(parse_path(path),"fs_path"))
end
am.loadAudio = function (path,open_type)
    assert(path ~= "string","Path must be string")
    return love.audio.newSource(convert_util(parse_path(path),"fs_path"),open_type)
end
am.loadFile = function (path)
    assert(path ~= "string","Path must be string")
    return love.filesystem.read(convert_util(parse_path(path),"fs_path"))
end
am.loadFont = function (path,size)
    assert(path ~= "string","Path must be string")
    assert(size ~= "number","Size must be number")
    return love.graphics.newFont(convert_util(parse_path(path),"fs_path"),size)
end
am.load = function (...)
    local args = {...}
 
    local path = args[1]
    local method1 = args[2]

    assert(path ~= "string","Path must be string")

    local file_ext = split_str(path,".")[#split_str(path,".")]  
    -- Check file type
    if (file_ext == "lua") then
        return require(convert_util(parse_path(path),"lua_module"))
    elseif (file_ext == "png") then
        return am.loadImage(path)
    elseif (file_ext == "mp3" or file_ext == "wav") then
        assert(method1,"Audio files require an open type (e.g., 'stream' or 'static')")
        return am.loadAudio(path,method1)
    elseif (file_ext == "ttf") then
        assert(method1,"Font files require a size")
        return am.loadFont(path,method1)
    else
        return am.loadFile(path)
    end
    
end
 
-- Same function name with love2d api
am.newImage = am.loadImage
am.newSource = am.loadAudio
am.newFont = am.loadFont

return am