require "Log"
require "Input"


ButtonSequences = {
    -- Battle sequences
    BATTLE_RUN = {buttonSequence={{Buttons.DOWN}, {Buttons.RIGHT}, {Buttons.A}}, waitFrames=5},
    BATTLE_FIGHT = {buttonSequence={{Buttons.UP}, {Buttons.LEFT}, {Buttons.A}}, waitFrames=5, waitEnd=300},
    BATTLE_PKMN = {buttonSequence={{Buttons.UP}, {Buttons.RIGHT}, {Buttons.A}}, waitFrames=5},
    BATTLE_PACK = {buttonSequence={{Buttons.DOWN}, {Buttons.LEFT}, {Buttons.A}}, waitFrames=5},

    -- Search sequences
    SEARCH_ALL_DIR_N = {buttonSequence={{Buttons.UP}, {Buttons.RIGHT}, {Buttons.DOWN}, {Buttons.LEFT}},
                        duration=Duration.TURN,
                        waitFrames=Duration.STEP},
    SEARCH_ALL_DIR_S = {buttonSequence={{Buttons.DOWN}, {Buttons.LEFT}, {Buttons.UP}, {Buttons.RIGHT}},
                        duration=Duration.TURN,
                        waitFrames=Duration.STEP},

    -- PC
    OPEN_TO_PC_MENU = {buttonSequence={{Buttons.A}, {Buttons.B}}, 
                         duration=60,
                         waitFrames=10,
                         waitEnd=60},
    PC_MENU_TO_BILLS = {buttonSequence={{Buttons.A}, {Buttons.B}, {Buttons.B}}, 
                        duration=60,
                        waitFrames=60
                    },
    EXIT_PC = {buttonSequence={{Buttons.B}, {Buttons.B}, {Buttons.B}}, 
                duration=20,
                waitFrames=50},
    
    SAVE_GAME = {buttonSequence={{Buttons.A}, {Buttons.A}, {Buttons.A}, {Buttons.A}},
                 duration=60,
                 waitFrames=60,
                 waitEnd=450, -- Wait for save to finish
                 },

    -- Static Encounters
    STARTERS = {buttonSequence={{Buttons.A}, Buttons.A},
                duration=Duration.LONG_PRESS,
                waitFrames=80}
}

CustomSequences = {}
function CustomSequences:starterEncounter() 

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
                       waitFrames=10}
end