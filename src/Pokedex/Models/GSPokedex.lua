require "Memory"

local Model = {
    ViewOffset = {
        addr = 0xC6D0,
        size = 1,
        memdomain = Memory.WRAM
    },
    CursorOffset = {
        addr = 0xC6D1,
        size = 1,
        memdomain = Memory.WRAM
    },
    maxView = 7,
    pokemonNumber = {
        addr = 0xD151,
        size = 1,
        memdomain = Memory.WRAM
    }
}

function Model:currentPosition() 
    return Memory:readFromTable(Model.ViewOffset) + Memory:readFromTable(Model.CursorOffset) + 1
end

return Model