require "Common"

local Model = {}

---@type MemoryTable
local Station = {
    addr = 0xC32A,
    size = 1,
    PLACES_AND_PEOPLE = 0x40,
    LETS_ALL_SING = 0x48,
    POKE_FLUTE = 0x4E
}

Model.Station = Station

return Model
