-- Table based love2D UI rendering system
--[[
使用metatable追蹤Instance added/removed

]]
local UIRender = {}



--[[
Render workflow format:

{
 type: string,
 data: table
}

UIRender table format:


=== Instance ===
{
 type: string,
 data: table,
 children: Instance[],
 uuid: string
}
]]
local optimized_uirender_workflows = {}
UIRender.new = function (table)
    
end

UIRender.draw = function ()
 
end

return UIRender