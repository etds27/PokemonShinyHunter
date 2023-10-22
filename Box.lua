Box = {
    addr = 0xDB72, -- For current loaded box
    firstHalfAddr = 0x4000, -- I think this RAM partition starts at 0xA000
    secondHalfAddr = 0x6000,
    size = 1,
    headerSize = 22,
    pokemonSize = 32,
    numBoxes = 14,
    maxBoxSize = 20,
}

BoxUI = {

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
function Box:getNumberOfPokemonInBox(boxNumber)
    startingAddress = Box:getBoxStartingAddress(boxNumber) 
    return Memory:read(startingAddress, size, Memory.CARTRAM) % 255 -- Value may be 255
end

function Box:getNumberOfPokemonInCurrentBox()
    return Box:getNumberOfPokemonInBox(Box:getCurrentBoxNumber()) 
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
    return startingAddress + Box.headerSize + Box.pokemonSize * (pokemonPosition - 1)
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
    numPokemon = Box:getNumberOfPokemonInBox(boxNumber)
    for i = 1, numPokemon 
    do
        pokemonAddress =  Box:pokemonLocation(startingAddress, i)
        pokemonTable = PokemonMemory:getPokemonTable(MemoryPokemonType.BOX, 
                                                     pokemonAddress, 
                                                     Memory.CARTRAM)
        table.insert(box, pokemonTable)
    end
    return box
end

function Box:getCurrentBox()
    return Box:getBox(Box:getCurrentBoxNumber())
end

function Box:getAllPokemonInPC()
    pokemon = {}
    for i = 1, Box.numBoxes
    do
        currentBox = Box:getBox(i)
        for i, pokemonTable in ipairs(currentBox)
        do
            table.insert(pokemon, pokemonTable)
        end
    end
    return pokemon
end

function Box:isBoxFull(boxNumber)
    --[[
        Determine if the specified box is full
    ]]
    return Box:getNumberOfPokemonInBox(boxNumber) == Box.maxBoxSize
end

function Box:isCurrentBoxFull()
    --[[
        Determine if the current box is full
    ]]
    return Box:getNumberOfPokemonInCurrentBox() == Box.maxBoxSize
end

PCMainMenu = {
    BILL = 1,
    TRAINER = 2,
    PROF_OAK = 3,
    TURN_OFF = 4
}

PCBillsMenu = {
    WITHDRAW = 1,
    DEPOSIT = 2,
    CHANGE_BOX = 3,
    MOVE_PKMN = 4
}

PCBoxCursor = {
    addr = 0xD106,
    size = 1,
    CANCEL = 255
}

PCBoxEdit = {
    addr = MenuCursor.addr,
    size = MenuCursor.size,
    SWITCH = 1,
    NAME = 2,
    PRINT = 3,
    QUIT = 4,
}

function BoxUI:changeBox(newBox)
    --[[
        Performs the entire changing box flow from starting up the pc to closing out
    ]]
    if Box:getCurrentBoxNumber() == newBox then
        Log:info("Box is already set to " .. tostring(newBox))
        return true
    end

    BoxUI:bootUpPC()
    BoxUI:selectBillsPC()
    BoxUI:selectChangeBox()
    BoxUI:navigateToBox(newBox)
    BoxUI:switchBox(boxNumber)
    BoxUI:exitPC()
    return Box:getCurrentBoxNumber() == newBox
end

function BoxUI:bootUpPC()
    --[[
        Go from overworld to main page of PC
        No verification
    ]]
    Input:performButtonSequence(ButtonSequences.OPEN_TO_PC_MENU)
end

function BoxUI:selectBillsPC()
    --[[
        Go from main page of PC to Bills PC
        No verification
    ]]
    Common:navigateMenuFromAddress(MenuCursor.addr, PCMainMenu.BILL)
    Input:performButtonSequence(ButtonSequences.PC_MENU_TO_BILLS)
end

function BoxUI:selectChangeBox()
    --[[
        Go from Bills PC to Change Box Menu
        No verification
    ]]
    Common:navigateMenuFromAddress(MenuCursor.addr, PCBillsMenu.CHANGE_BOX)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

function BoxUI:navigateToBox(boxNumber)
    --[[
        Go from Box select screen to selecting the desired box
        No verification
    ]]
    Common:navigateMenuFromAddress(PCBoxCursor.addr, boxNumber)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

function BoxUI:switchBox(boxNumber)
    --[[
        Go from selected box screen to completing the box change
        No verification
    ]]
    Common:navigateMenuFromAddress(PCBoxEdit.addr,  PCBoxEdit.SWITCH)
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:performButtonSequence(ButtonSequences.SAVE_GAME)
end

function BoxUI:exitPC()
    Input:performButtonSequence(ButtonSequences.EXIT_PC)
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

-- print(Box:getCurrentBoxNumber())
-- print(Box:getBox(1)[1])
-- print(Box:getBox(1)[2])
-- BoxUI:changeBox(3)
 -- Box:getAllPokemonInPC()