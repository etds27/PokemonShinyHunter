require "Memory"

---@type MemoryTable
local Model = {
    addr = 0xDCD7, -- num of pokemon address
    size = 1, 
    memdomain = Memory.WRAM,
    pokemonSize = 48,
    maxPokemon = 6
}
return Model