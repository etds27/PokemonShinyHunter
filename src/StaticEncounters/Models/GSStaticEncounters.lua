require "BotModes"
require "Common"
require "Input"
require "StartMenu"
require "Memory"
require "Menu"
require "Positioning"

---TODO: Fix this for Gold/Silver
local Model = {
    ENTEI = {
        Location = {
            addr = 0xDFD9,
            size = 1
        },
        MapLocation = {
            addr = 0xCFBA,
            size = 1
        },
        
    },
    RAIKOU = {
        addr = 0xDFD2,
        size = 1,
    }
}

-- These function signatures allow them to be used as callbacks in tests
Model[BotModes.SHUCKLE_GSC] = function()
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end
end

Model[BotModes.EEVEE_GSC] = function()
    -- Start dialog
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}

    -- Press A until confirmation menu appears
    while not Positioning:inOverworld() and not (Memory:readFromTable(Menu.Cursor) == 1)
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

Model[BotModes.STARTER] = function() 

    -- Press A until the prompt to accept the pokemon
    while Memory:readFromTable(Menu.Cursor) == 0
    do
        Input:pressButtons{buttonKeys={Buttons.A}, 
                           duration=16,
                           waitFrames=2}
    end

    -- Press A to accept the pokemon
    Input:pressButtons{buttonKeys={Buttons.A}, 
                       duration=16,
                       waitFrames=2}

    -- Press B until we walk over to Prof Elm
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.B},
                            duration=16,
                            waitFrames=2}
    end

    -- Press B until we get to Prof Elm
    while Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.B},
                            duration=16,
                            waitFrames=2}
    end

    -- Press B until we are free
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.B},
                            duration=16,
                            waitFrames=2}
    end
end

return Model
