require "Memory"
local Model = {
    ID = {
        addr = 0xD47B,
        size = 2
    },

    Money = {
        addr = 0xD84F,
        size = 2
    },

    PlayTime = {
        Hour = {
            addr = 0xD4C5,
            size = 1
        },
        Minute = {
            addr = 0xD4C6,
            size = 1
        },
        Second = {
            addr = 0xD4C7,
            size = 1
        }
    },

    Name = {
        addr = 0xD47D,
        maxLength = 7,
    },

    Coins = {
        addr = 0xD855,
        size = 2,
        memdomain = Memory.WRAM
    }
}
return Model