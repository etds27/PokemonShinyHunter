require "Common"
require "Log"
require "Memory"
require "Input"

Fishing = {}

-- Abstract tables
local Model = {}
Model.Rods = {}
local Model = FishingFactory:loadModel()

-- Load in default tables

-- Merge model into class
Fishing = Common:tableMerge(Fishing, Model)

function Fishing:fish() 
    --[[
        Handle all interation after the rod has been selected from the bag

        Returns: true if a fish was hooked, false, if it didnt fish or nothing was caught
    ]]
    catchStatus = Memory:readFromTable(Fishing)
    Log:debug("Fishing status " .. tostring(catchStatus))
    if catchStatus == Fishing.FISH then
        Common:waitFrames(305)
        Log:debug("Dismissing 'Oh a Bite!'")
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        Common:waitFrames(210)
        return true
    elseif catchStatus == Fishing.NO_FISH then
        Common:waitFrames(175)
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        Common:waitFrames(20)
        Log:debug("Not a nibble")
        return false
    else
        Log:debug("Never fished")
        return false
    end
end