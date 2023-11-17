require "Common"
require "Factory"

---@type FactoryMap
local factoryMap = {
    GSStaticEncounters = GameGroups.GOLD_SILVER,
    CrystalStaticEncounters = {Games.CRYSTAL}
}

StaticEncounters = {}

-- Abstract tables
local Model = Factory:loadModel(factoryMap)

StaticEncounters.standardWildEncounter = function()
    -- Start Dialog
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    return Battle:waitForBattleMenu()
end


StaticEncounters = Common:tableMerge(StaticEncounters, Model)

