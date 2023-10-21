Box = {
    addr = 0xDB72, -- For current loaded box
    firstHalfAddr = 0x4000, -- I think this RAM partition starts at 0xA000
    secondHalfAddr = 0x6000,
    size = 1,
    headerSize = 22 
}

CurrentBoxNumber = {
    addr = 0xDB72,
    size = 1
}

LoadedBox = {
    addr = 0x2D10,
    size = 1,
    memdomain = Memory.CARTRAM
}

function Box:getCurrentBoxNumber()
    --[[
        Get the current loaded box number
        Returns:
            - Box number (Indexed at 1)
    ]]
    return Memory:readFromTable(CurrentBoxNumber) + 1
end

function Box:getBoxStartingAddress(boxNumber) 
    --[[
        Calculate the starting address of the box in SRAM.
        Arguments:
            - boxNumber: integer between 1 and 14
    ]]

    if boxNumber == Box:getCurrentBoxNumber() then
        return LoadedBox.addr
    end

    if boxNumber < 8 then
        return Box.firstHalfAddr + 0x450 * (boxNumber - 1)
    else
        return Box.secondHalfAddr + 0x450 * (boxNumber - 8)
    end
end

function Box:pokemonLocation(startingAddress, pokemonPosition)
    --[[
        Calculate the starting address of the pokemon's data

        Arguments:
            - startingAddress: The starting address of the box the pokemon is in
            - pokemonPosition: The index of the pokemon (Start at 1)
    ]]
    return startingAddress + Box.headerSize + 32 * (pokemonPosition - 1)
end

function Box:getBox(boxNumber)
    --[[
        Collect the Pokemon data in the box
        Arguments:
            - boxNumber: integer between 1 and 14
    ]]
    -- First Byte is always the number of Pokemon in the box
    box = {}
    startingAddress = Box:getBoxStartingAddress(boxNumber) 
    print(startingAddress)
    numPokemon = Memory:read(startingAddress, size, Memory.CARTRAM)
    print(numPokemon)
    for i = 1, numPokemon 
    do
        
        pokemonAddress =  Box:pokemonLocation(startingAddress, i)
        print(pokemonAddress, i)
        pokemonTable = PokemonMemory:getTrainerPokemonTable(pokemonAddress, Memory.CARTRAM)
        table.insert(box, pokemonTable)
    end
    return box
end

-- Box Structure
-- Box 1
-- SRAM
--[[
    Current Loaded Box:
SRAM
Pokemon Count: 0x2D10
20 Bytes of pokemon numbers
1 Empty Byte
Pokemon of size - 32 Bytes

Each box is 0x450 Hex. Padding after box 8
Box 1 - 0x4000
Box 2 - 0x4450
Box 3 - 0x48A0
Box 4 - 0x4CF0
Box 5 - 0x5140
Box 6 - 0x5590
Box 7 - 0x59E0
Box 8 - 0x6000
Box 9 - 0x6450
Box 10 - 0x68A0
Box 11 - 0x6CF0
Box 12 - 0x7140 
Box 13 - 0x7590
Box 14 - 0x79E0
]]

print(Box:getCurrentBoxNumber())
print(Box:getBox(1)[1])
print(Box:getBox(1)[2])