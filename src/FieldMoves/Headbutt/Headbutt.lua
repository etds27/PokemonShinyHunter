require "Common"
require "Factory"
require "Input"
require "Memory"

---@type FactoryMap
local factoryMap = {
    GSHeadbutt = GameGroups.GOLD_SILVER,
    CrystalHeadbutt = {Games.CRYSTAL}
}

Headbutt = {}

-- Abstract tables
local Model = {}
Model.Catch = {}
Model = Factory:loadModel(factoryMap)

-- Merge model into class
Headbutt = Common:tableMerge(Headbutt, Model)

---Headbutt the tree that the trainer is facing
---@return boolean True If an encounter was found False, if we were unable to headbutt or no encounter was started
function Headbutt:headbuttTree() 
    -- Initiate headbutt
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    -- Press A until Yes/No prompt comes up
    while Memory:readFromTable(Menu.Cursor) == 0
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end
    -- Press yes
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}

    -- Press B until we are back in overworld or in a battle
    while not Positioning:inOverworld() and Memory:readFromTable(Battle.PokemonTurnCounter) ~= 0
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=14, waitFrames=2}
    end

    return Memory:readFromTable(Headbutt) == Headbutt.ENCOUNTER
end
