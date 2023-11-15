require "Memory"
local Model = {
    addr = 0xD1EF,
    size = 1,
    memdomain = Memory.WRAM,
    FISH = 1,
    NO_FISH = 2,

    Rods = {
        Items.OLD_ROD,
        Items.GOOD_ROD,
        Items.SUPER_ROD
    }
}
return Model