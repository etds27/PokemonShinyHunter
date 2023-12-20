require "Memory"

local Model = {
    ViewOffset = {
        addr = 0xC7D0,
        size = 1,
        memdomain = "WRAM"
    },
    CursorOffset = {
        addr = 0xC7D1,
        size = 1,
        memdomain = "WRAM"
    },
    maxView = 7,
    pokemonNumber = {
        addr = 0xD265,
        size = 1,
        memdomain = "WRAM"
    }
}

function Model:currentPosition() 
    return Memory:readFromTable(Model.ViewOffset) + Memory:readFromTable(Model.CursorOffset) + 1
end

return Model