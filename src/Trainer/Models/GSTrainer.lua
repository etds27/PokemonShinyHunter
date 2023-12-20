require "Memory"
local Model = {
    ID = {
        addr = 0xDD63,
        size = 2
    },

    Money = {
        addr = 0xD574,
        size = 2
    },

    PlayTime = {
        Hour = {
            addr = 0xC1EC,
            size = 1
        },
        Minute = {
            addr = 0xC1ED,
            size = 1
        },
        Second = {
            addr = 0xC1EE,
            size = 1
        }
    },

    Name = {
        addr = 0xD1A3,
        maxLength = 7,
    },

    Coins = {
        addr = 0xD57A,
        size = 2,
        memdomain = Memory.WRAM
    }
}
return Model