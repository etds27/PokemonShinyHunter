require "Memory"

---@type MemoryTable
local Model = {
    addr = 0xDA22, -- num of pokemon address
    size = 1,
    memdomain = Memory.WRAM,
    pokemonSize = 48,
    maxPokemon = 6,
    EGG_POKEMON = 0xFD,
    NO_POKEMON = 0xFF
}
return Model