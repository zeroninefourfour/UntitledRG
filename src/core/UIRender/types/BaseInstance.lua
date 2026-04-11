local TweenService = require("TweenService")

---@class Instance
---@field uuid string
---@field type "Text"|"Image"|"Unknown"
---@field ZIndex number
local Instance = {}
Instance.uuid = ""
Instance.type = "Unknown"
Instance.ZIndex = 0

---@param tweenInfo TweenInfo
---@param tweenProperties table
function Instance:Tween(tweenInfo, tweenProperties)
  TweenService.Tween(self.uuid, tweenInfo, tweenProperties)
end


return Instance