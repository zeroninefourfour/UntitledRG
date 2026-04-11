-- Table based love2D UI rendering system
--[[
使用metatable追蹤Instance added/removed

]]
local UIRender = {}

local love2d_cache = {}
local optimized_uirender_workflows = {}

---@param instances Instance[]
UIRender.new = function (instances)
    local self = setmetatable({}, {__index = UIRender})
    self.instances = instances or {}
    return self
end

UIRender.generateOptimizedWorkflows = function (instances)
     
end
UIRender.draw = function (loveapi)

    
end

return UIRender