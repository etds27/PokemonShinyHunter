require "Common"

local Model = {}

---@type MemoryTable
local Station = {
    addr = 0xC532,
    size = 1,
    OAKS_PKMN_TALK = 0x10,
    POKEMON_MUSIC = 0x1C,
    LUCKY_CHANNEL = 0x20,
    PLACES_AND_PEOPLE = 0x40,
    LETS_ALL_SING = 0x48,
    POKE_FLUTE = 0x4E
}

Model.Station = Station

return Model
