
require "Common"
require "StaticEncountersFactory"



StaticEncounters = {}

-- Abstract tables
local Model = StaticEncountersFactory:loadModel()

StaticEncounters.standardWildEncounter = function()
    -- Start Dialog
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    return Battle:waitForBattleMenu()
end


StaticEncounters = Common:tableMerge(StaticEncounters, Model)

