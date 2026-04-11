---@class TweenInfo
---@field duration number
---@field easingStyle EasingStyle       -- 或你自己定義的 EasingStyle
---@field easingDirection any   -- 或你自己定義的 EasingDirection
---@field repeatCount number
---@field reverses boolean
---@field delayTime number

local TweenInfo = {}
TweenInfo.__index = TweenInfo

---@param duration number
---@param easingStyle any
---@param easingDirection any
---@param repeatCount number
---@param reverses boolean
---@param delayTime number
---@return TweenInfo
function TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
  local self = setmetatable({}, TweenInfo)
  self.duration = duration
  self.easingStyle = easingStyle
  self.easingDirection = easingDirection
  self.repeatCount = repeatCount
  self.reverses = reverses
  self.delayTime = delayTime
  return self
end

return TweenInfo