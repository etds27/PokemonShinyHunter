local Model = {
    Catch = {
        addr = 0x11416,
        size = 1,
        memdomain = Memory.WRAM,
        frameLimit = 700, -- 600 in testing
        RESET = 0,
        CAUGHT = 1,
        MISSED = 2
    },

    -- When this value is 0, we are at the start of a battle
    PokemonTurnCounter = {
        addr = 0xC6DD,
        size = 1,
    },

    EnemyPokemonTurnCounter = {
        addr = 0xC6DC,
        size = 1,
    },

    MenuCursor = {
        addr = GameSettings.battleCursor,
        size = 2,
        FIGHT = 257, -- 0101
        PKMN = 258,  -- 0102
        PACK = 513,  -- 0201
        RUN = 514,   -- 0202
    },
}
return Model