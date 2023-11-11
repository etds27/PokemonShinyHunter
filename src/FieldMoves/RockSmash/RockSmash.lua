require "Common"
require "RockSmashFactory"
require "Input"
require "Memory"

RockSmash = {}

-- Abstract tables
local Model = {}
Model.Catch = {}
Model = RockSmashFactory:loadModel()

-- Merge model into class
RockSmash = Common:tableMerge(RockSmash, Model)

function RockSmash:smashRock() 
    --[[
        RockSmash the tree that the trainer is facing

        Returns:
            True, if an encounter was found
            False, if we were unable to rock smash or no encounter was started
    ]]
    -- Initiate rock smash
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    -- Press A until Yes/No prompt comes up
    while Memory:readFromTable(Menu.Cursor) == 0
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end
    -- Press yes
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}

    -- Press B until we are back in overworld or in a battle
    while Memory:readFromTable(RockSmash) == RockSmash.PENDING and Memory:readFromTable(Battle.PokemonTurnCounter) ~= 0
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=14, waitFrames=2}
    end

    return Memory:readFromTable(RockSmash) ~= RockSmash.NO_ENCOUNTER
end


print(RockSmash:smashRock())