require "Log"
require "Input"

---@enum ButtonSequences
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
