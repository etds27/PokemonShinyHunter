require "Menu"

local Model = {
    Catch = {
        addr = 0xCA16,
        size = 1,
        memdomain = Memory.WRAM,
        frameLimit = 700, -- 600 in testing
        RESET = 0,
        CAUGHT = 1,
        MISSED = 2
    },

    -- When this value is 0, we are at the start of a battle
    PokemonTurnCounter = {
        addr = 0xCBBB,
        size = 1,
    },

    EnemyPokemonTurnCounter = {
        addr = 0xCBBA,
        size = 1,
    },

    MenuCursor = {
        X = Menu.MultiCursor.X,
        Y = Menu.MultiCursor.Y,
        FIGHT = {x = 1, y = 1}, -- 0101
        PKMN = {x = 2, y = 1},  -- 0102
        PACK = {x = 1, y = 2},  -- 0201
        RUN = {x = 2, y = 2},   -- 0202
    },
}
return Model