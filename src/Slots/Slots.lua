require "Common"
require "SlotsFactory"


Slots = {}

local Model = {}
Model.ID = {}
Model.Money = {}
Model.PlayTime = {}
Model.Name = {}
Model = SlotsFactory:loadModel()

---Plays the slot machine a single time. Abstract method.
---
---Assumes we are looking at the slot screen
---@param amount integer Number of coins to play until
---@return boolean true if the amount is reached
function Slots:playSlotUntilAmount(amount)
    return false
end

-- Merge model into class
Slots = Common:tableMerge(Slots, Model)
