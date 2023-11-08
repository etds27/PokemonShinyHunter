require "BoxFactory"
require "Common"
require "Log"
require "Memory"
require "Menu"
require "Party"
require "Pokemon"
require "Input"
Box = {}

-- Abstract tables
local Model = {}
Model.CurrentBoxNumber = {}
Model.LoadedBox = {}
local Model = BoxFactory:loadModel()

-- Load in default tables

-- Merge model into class
Box = Common:tableMerge(Box, Model)

function Box:getCurrentBoxNumber()
    --[[
        Get the current loaded box number
        Returns:
            - Box number (Indexed at 1)
    ]]
    return Memory:readFromTable(Box.CurrentBoxNumber) + 1
end

function Box:getNumberOfPokemonInBox(boxNumber)
    --[[
        Get the number of pokemon in the specified box

        Returns: Number of pokemon in the box
    ]]
    startingAddress = Box:getBoxStartingAddress(boxNumber) 
    return Memory:read(startingAddress, size, Memory.CARTRAM) % 255 -- Value may be 255
end

function Box:getNumberOfPokemonInCurrentBox()
    --[[
        Get the number of pokemon in the current box

        Returns: Number of pokemon in the current box
    ]]
    return Box:getNumberOfPokemonInBox(Box:getCurrentBoxNumber()) 
end

function Box:getBoxStartingAddress(boxNumber) 
    --[[
        Calculate the starting address of the box in SRAM.
        Arguments:
            - boxNumber: integer between 1 and 14
    ]]

    if boxNumber == Box:getCurrentBoxNumber() then
        return Box.LoadedBox.addr
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
        pokemonTable = Pokemon:new(Pokemon.PokemonType.BOX, 
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

function Box:findFirstBoxWithCapacity(capacity)
    --[[
        Search through the boxes to find one that has enough open space

        Arguments:
            capacity: default 1, the minimum open space required for a box
    ]]
    if capacity == nil then capacity = 1 end
    for i = 1, Box.numBoxes
    do
        if Box.maxBoxSize - Box:getNumberOfPokemonInBox(i) >= capacity then
            return i
        end
    end
end

BoxUI = {}

function BoxUI:performDepositMenuActions(boxActions) 
    --[[
        Perform the specified actions in box actions
        THIS CAN INCLUDE RELEASES

        Arguments: Table of box actions to conduct
            {{index: action:}, {index: action:}}
                index: Slot in the party to perform action
                action: DEPOSIT or RELEASE
    ]]
    -- Sort the actions in reverse order by party index
    -- This will allow us to iterate backwards through the list
    -- And not mess up pokemon ordering when performing deposit or release actions
    table.sort(boxActions, function(lhs, rhs) return lhs.index > rhs.index end)
    
    -- Determine how many deposit actions will be taken
    local numActions = 0
    for i, actionPair in ipairs(boxActions)
    do
        if actionPair.action == BoxUI.Action.DEPOSIT then numActions = numActions + 1 end
    end

    -- Find a box capable of storing enough pokemon
    local index = Box.findFirstBoxWithCapacity(numActions)
    BoxUI:changeBox(index)

    BoxUI:bootUpPC()
    BoxUI:selectBillsPC()
    Menu:navigateMenuFromTable(MenuCursor, BoxUI.PCBillsMenu.DEPOSIT)
    Input:pressButtons{buttonKeys={Buttons.A}, waitFrames=40}
    for i, actionPair in ipairs(boxActions)
    do
        local index = actionPair.index - 1 -- Indices start at 0
        local action = actionPair.action
        local numPokemon = Party:numOfPokemonInParty()
        -- Move to pokemon at index
        Menu:navigateMenu(BoxUI:currentPokemonIndex(), index, {duration = 2, waitFrames=15})
        if BoxUI:currentPokemonIndex() ~= index then 
            return false 
        end

        Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS, waitFrames=30}
        if action == BoxUI.Action.DEPOSIT then
            if not Menu:navigateMenuFromTable(MenuCursor, BoxUI.DepositMenu.DEPOSIT) then return false end
            Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
        elseif action == BoxUI.Action.RELEASE then
            if not Menu:navigateMenuFromTable(MenuCursor, BoxUI.DepositMenu.RELEASE) then return false end
            Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS, waitFrames=30}
            -- Extra A press for release confirmation
            Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
        end
        -- About 120 for deposit and 180 for release
        Common:waitFrames(200)
        -- Compare the current number of pokemon to the start value,
        -- If it is the same still, then we did not deposit
        if numPokemon == Party:numOfPokemonInParty() then
            Log:error("Did not deposit or release pokemon")
            return false
        end

    end

    return BoxUI:exitPC()
end

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
    Log:debug("BoxUI:bootUpPC - init")
    Input:performButtonSequence(ButtonSequences.OPEN_TO_PC_MENU)
end

function BoxUI:selectBillsPC()
    --[[
        Go from main page of PC to Bills PC
        No verification
    ]]
    Log:debug("BoxUI:selectBillsPC() - init")
    Menu:navigateMenuFromTable(MenuCursor, BoxUI.PCMainMenu.BILL)
    Input:performButtonSequence(ButtonSequences.PC_MENU_TO_BILLS)
end

function BoxUI:selectChangeBox()
    --[[
        Go from Bills PC to Change Box Menu
        No verification
    ]]
    Menu:navigateMenuFromTable(MenuCursor, BoxUI.PCBillsMenu.CHANGE_BOX)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

function BoxUI:navigateToBox(boxNumber)
    --[[
        Go from Box select screen to selecting the desired box
        No verification
    ]]
    Menu:navigateMenuFromTable(BoxUI.PCBoxCursor, boxNumber)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

function BoxUI:switchBox(boxNumber)
    --[[
        Go from selected box screen to completing the box change
        No verification
    ]]
    Menu:navigateMenuFromTable(BoxUI.PCBoxEdit,  BoxUI.PCBoxEdit.SWITCH)
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:performButtonSequence(ButtonSequences.SAVE_GAME)
end

function BoxUI:exitPC()
    Input:performButtonSequence(ButtonSequences.EXIT_PC)
    return Positioning:inOverworld()
end

function BoxUI:currentPokemonIndex()
    --[[
        ABSTRACT FUNCTION. Will differ between games 
        Determine the index of the currently focused pokemon in the box
    ]]
end

-- Abstract tables
local Model = {}
Model.PCMainMenu = {}
Model.PCBillsMenu = {}
Model.PCBoxCursor = {}
Model.PCBoxEdit = {}
local Model = BoxUIFactory:loadModel()

-- Load in default tables

-- Merge model into class
BoxUI = Common:tableMerge(BoxUI, Model)

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