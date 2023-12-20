local Model = {
    firstHalfAddr = 0x4000, -- I think this RAM partition starts at 0xA000
    secondHalfAddr = 0x6000,
    headerSize = 22,
    pokemonSize = 32,
    numBoxes = 14,
    maxBoxSize = 20,

    CurrentBoxNumber = {
        addr = 0xDB72,
        size = 1,
        memdomain = Memory.WRAM
    },

    LoadedBox = {
        addr = 0x2D10,
        size = 1,
        memdomain = Memory.CARTRAM
    },
}
return Model