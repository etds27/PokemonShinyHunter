require "Common"
require "SlotsFactory"


Slots = {}

local Model = {}
Model.ID = {}
Model.Money = {}
Model.PlayTime = {}
Model.Name = {}
Model = SlotsFactory:loadModel()


function Slots:playSlotUntilAmount(amount)
    --[[
        Plays the slot machine a single time. Abstract method.
        Assumes we are looking at the slot screen
    ]]
end

-- Merge model into class
Slots = Common:tableMerge(Slots, Model)


Slots:playSlotUntilAmount(9900)