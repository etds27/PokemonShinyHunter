require "Common"
require "HeadbuttFactory"
require "Input"
require "Memory"

Headbutt = {}

-- Abstract tables
local Model = {}
Model.Catch = {}
Model = HeadbuttFactory:loadModel()

-- Merge model into class
Headbutt = Common:tableMerge(Headbutt, Model)

function Headbutt:headbuttTree() 
    --[[
        Headbutt the tree that the trainer is facing

        Returns:
            True, if an encounter was found
            False, if we were unable to headbutt or no encounter was started
    ]]
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
