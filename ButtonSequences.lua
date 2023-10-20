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
}