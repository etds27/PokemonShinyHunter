require "Common"
require "Factory"
require "Input"
require "Log"
require "Memory"

---@type FactoryMap
local factoryMap = {
    GSFishing = GameGroups.GOLD_SILVER,
    CrystalFishing = {Games.CRYSTAL}
}

Fishing = {}

-- Abstract tables
local Model = {}
Model.Rods = {
    Items.OLD_ROD,
    Items.GOOD_ROD,
    Items.SUPER_ROD
}
Model = Factory:loadModel(factoryMap)

-- Load in default tables

-- Merge model into class
Fishing = Common:tableMerge(Fishing, Model)

---Handle all interation after the rod has been selected from the bag
---@return boolean true if a fish was hooked, false, if it didnt fish or nothing was caught
function Fishing:fish()
    local catchStatus = Memory:readFromTable(Fishing)
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