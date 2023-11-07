require "Bag"
require "Battle"
require "Box"
require "Breeding"
require "ButtonSequences"
require "Collection"
require "Common"
require "Fishing"
require "GameSettings"
require "Input"
require "Log"
require "Memory"
require "Pokemon"
require "PokemonData"
require "PokemonSocket"
require "Positioning"
require "PostCatch"
require "Text"
require "Trainer"

StaticEncounters = {}

-- These function signatures allow them to be used as callbacks in tests
StaticEncounters.shuckleEncounter = function()
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end
end

StaticEncounters.eeveeEncounter = function()
    -- Start dialog
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}

    -- Press A until confirmation menu appears
    while not Positioning:inOverworld() and not (Memory:readFromTable(MenuCursor) == 1)
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end

    -- Confirm accept pokemon
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}

    -- Skip pokemon namining until in overworld
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=14, waitFrames=2}
    end
end

