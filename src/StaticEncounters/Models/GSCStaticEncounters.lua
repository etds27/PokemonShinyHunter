require "BotModes"
require "Common"
require "Input"
require "StartMenu"
require "Memory"
require "Positioning"

local Model = {
    ENTEI = {
        Location = {
            addr = 0xDFD9,
            size = 1
        },
        MapLocation = {
            addr = 0xCFBA.
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

Model[BotModes.STARTER] = function() 

    -- Initiate diaglog with pokeball
    Input:pressButtons{buttonKeys={Buttons.A}, 
                       duration=20,
                       waitFrames=100}
    -- Dismiss Picture
    -- You'll take ---, the
    Input:pressButtons{buttonKeys={Buttons.A},
                       duration=80,
                       waitFrames=8}
    -- --- Pokemon
    -- Gets to the Yes/No prompt
    Input:pressButtons{buttonKeys={Buttons.A},
                       duration=44,
                       waitFrames=8}
    -- I think thats a great
    Input:pressButtons{buttonKeys={Buttons.A},
                       duration=56,
                       waitFrames=8}
    -- Pokemon too!
    Input:pressButtons{buttonKeys={Buttons.A},
                       duration=28,
                       waitFrames=4}
    -- Trainer received ---
    Input:pressButtons{buttonKeys={Buttons.A},
                       duration=250,
                       waitFrames=4}
    -- Do you want to give a name
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=42,
                       waitFrames=4}
    -- --- you received?
    -- Gets to Yes/No prompt
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=25,
                       waitFrames=4}
    -- Walk to Prof Elm
    -- MR.POKEMON lives a little bit beyond
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=240,
                       waitFrames=4}
    -- Cherrygrove the next city over
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=57,
                       waitFrames=4}
    -- It's almost a direct route
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=47,
                       waitFrames=4}
    -- so you can't miss it
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=48,
                       waitFrames=4}
    -- Heres my phone
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=54,
                       waitFrames=4}
    -- Call me if anything comes up
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=60,
                       waitFrames=10}

    -- Trainer got Elm's phone number
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=280,
                       waitFrames=10}
    -- Elm looks around
    -- If your pokemon is hurt
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=96,
                       waitFrames=4}

    -- heal it with this machine
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=48,
                       waitFrames=4}
    -- Feel free to use it any time
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=50,
                       waitFrames=10}
    -- Im counting on you!
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=85,
                       waitFrames=10}
    -- Im counting on you!
    Input:pressButtons{buttonKeys={Buttons.B},
                       duration=10,
                       waitFrames=30}
end

return Model
