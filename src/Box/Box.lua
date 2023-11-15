require "Common"
require "Factory"
require "Log"
require "Memory"
require "Menu"
require "Party"
require "Pokemon"
require "Input"

---@type FactoryMap
local boxFactoryMap = {
    CrystalBox = {Games.CRYSTAL},
    GSBox = GameGroups.GOLD_SILVER
}

---@type FactoryMap
local boxUIFactoryMap = {
    CrystalBoxUI = {Games.CRYSTAL},
    GSBoxUI = GameGroups.GOLD_SILVER
}

Box = {}

-- Abstract tables
local Model = {}
Model.CurrentBoxNumber = {}
Model.LoadedBox = {}
Model = Factory:loadModel(boxFactoryMap)

-- Load in default tables

-- Merge model into class
Box = Common:tableMerge(Box, Model)

---Get the current loaded box number
---@return integer boxNumber Box number (Indexed at 1)
function Box:getCurrentBoxNumber()
    return Memory:readFromTable(Box.CurrentBoxNumber) + 1
end

---Get the number of pokemon in the specified box
---@param boxNumber integer Box number to query
---@return integer numPokemonInBox Number of pokemon in the box
function Box:getNumberOfPokemonInBox(boxNumber)
    local startingAddress = Box:getBoxStartingAddress(boxNumber)
    return Memory:read(startingAddress, 1, Memory.CARTRAM) % 255 -- Value may be 255
end

---Get the number of pokemon in the current box
---@return integer numPokemon Number of pokemon in the current box
function Box:getNumberOfPokemonInCurrentBox()
    return Box:getNumberOfPokemonInBox(Box:getCurrentBoxNumber())
end


---Calculate the starting address of the box in SRAM.
---@param boxNumber integer between 1 and 14
---@return integer boxAddress Address of the start of the box
function Box:getBoxStartingAddress(boxNumber)
    if boxNumber == Box:getCurrentBoxNumber() then
        return Box.LoadedBox.addr
    end

    if boxNumber < 8 then
        return Box.firstHalfAddr + 0x450 * (boxNumber - 1)
    else
        return Box.secondHalfAddr + 0x450 * (boxNumber - 8)
    end
end

---@param startingAddress integer The starting address of the box the pokemon is in
---@param pokemonPosition integer The index of the pokemon (Start at 1)
---@return integer pokemonAddress Location of the pokemon within the box
function Box:pokemonLocation(startingAddress, pokemonPosition)
    return startingAddress + Box.headerSize + Box.pokemonSize * (pokemonPosition - 1)
end


---Collect the Pokemon data in the box
---@param boxNumber integer between 1 and 14
---@return Pokemon[] pokemon Table of `Pokemon` from the box
function Box:getBox(boxNumber)
    -- First Byte is always the number of Pokemon in the box
    local box = {}
    local startingAddress = Box:getBoxStartingAddress(boxNumber)
    local numPokemon = Box:getNumberOfPokemonInBox(boxNumber)
    for i = 1, numPokemon
    do
        local pokemonAddress =  Box:pokemonLocation(startingAddress, i)
        local pokemonTable = Pokemon:new(Pokemon.PokemonType.BOX,
                                    pokemonAddress,
                                    Memory.CARTRAM)
        table.insert(box, pokemonTable)
    end
    return box
end


---Get the currently loaded box
---@return Pokemon[] pokemon Table of `Pokemon` from the box
function Box:getCurrentBox()
    return Box:getBox(Box:getCurrentBoxNumber())
end

---Get all the pokemon in the PC
---@return Pokemon[] pokemon Table of `Pokemon` from the PC
function Box:getAllPokemonInPC()
    local pokemon = {}
    for i = 1, Box.numBoxes
    do
        local currentBox = Box:getBox(i)
        for _, pokemonTable in ipairs(currentBox)
        do
            table.insert(pokemon, pokemonTable)
        end
    end
    return pokemon
end

---Determine if the specified box is full
---@param boxNumber integer Box to check
---@return boolean true if the box is full
function Box:isBoxFull(boxNumber)
    return Box:getNumberOfPokemonInBox(boxNumber) == Box.maxBoxSize
end

---Determine if the current box is full
---@return boolean true if the box is full
function Box:isCurrentBoxFull()
    return Box:getNumberOfPokemonInCurrentBox() == Box.maxBoxSize
end

---Search through the boxes to find one that has enough open space
---@param capacity integer [1] the minimum open space required for a box
---@return integer boxNumber Number of box with available capacity
function Box:findFirstBoxWithCapacity(capacity)
    if capacity == nil then capacity = 1 end
    for i = 1, Box.numBoxes
    do
        if Box.maxBoxSize - Box:getNumberOfPokemonInBox(i) >= capacity then
            return i
        end
    end
    return -1
end

BoxUI = {}

---Perform the specified actions in box actions
---THIS CAN INCLUDE RELEASES
---@param boxActions table Table of box actions to conduct
---     {{index: action:}, {index: action:}}
---         index: `Slot in the party to perform action`
---         action: `DEPOSIT or RELEASE`
---@return boolean true if the actions were complete successfully
function BoxUI:performDepositMenuActions(boxActions)
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
    local index = Box:findFirstBoxWithCapacity(numActions)
    BoxUI:changeBox(index)

    BoxUI:bootUpPC()
    BoxUI:selectBillsPC()
    Menu:navigateMenuFromTable(Menu.Cursor, BoxUI.PCBillsMenu.DEPOSIT)
    Input:pressButtons{buttonKeys={Buttons.A}, waitFrames=40}
    for _, actionPair in ipairs(boxActions)
    do
        index = actionPair.index - 1 -- Indices start at 0
        local action = actionPair.action
        local numPokemon = Party:numOfPokemonInParty()
        -- Move to pokemon at index
        Menu:navigateMenu(BoxUI:currentPokemonIndex(), index, {duration = 1, waitFrames=20})
        if BoxUI:currentPokemonIndex() ~= index then
            return false
        end

        Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS, waitFrames=30}
        if action == BoxUI.Action.DEPOSIT then
            if not Menu:navigateMenuFromTable(Menu.Cursor, BoxUI.DepositMenu.DEPOSIT) then return false end
            Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
        elseif action == BoxUI.Action.RELEASE then
            if not Menu:navigateMenuFromTable(Menu.Cursor, BoxUI.DepositMenu.RELEASE) then return false end
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

---Performs the entire changing box flow from starting up the pc to closing out
---@param newBox integer Box to change to
---@return boolean true If box was changed correctly
function BoxUI:changeBox(newBox)
    if Box:getCurrentBoxNumber() == newBox then
        Log:info("Box is already set to " .. tostring(newBox))
        return true
    end

    BoxUI:bootUpPC()
    BoxUI:selectBillsPC()
    BoxUI:selectChangeBox()
    BoxUI:navigateToBox(newBox)
    BoxUI:switchBox()
    BoxUI:exitPC()
    return Box:getCurrentBoxNumber() == newBox
end

---Go from overworld to main page of PC.
---No verification
function BoxUI:bootUpPC()
    Log:debug("BoxUI:bootUpPC - init")
    Input:performButtonSequence(ButtonSequences.OPEN_TO_PC_MENU)
end

---Go from main page of PC to Bills PC.
---No verification
function BoxUI:selectBillsPC()
    Log:debug("BoxUI:selectBillsPC() - init")
    Menu:navigateMenuFromTable(Menu.Cursor, BoxUI.PCMainMenu.BILL)
    Input:performButtonSequence(ButtonSequences.PC_MENU_TO_BILLS)
end

---Go from Bills PC to Change Box Menu.
---No verification
function BoxUI:selectChangeBox()
    Menu:navigateMenuFromTable(Menu.Cursor, BoxUI.PCBillsMenu.CHANGE_BOX)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

---Go from Box select screen to selecting the desired box.
---No verification
function BoxUI:navigateToBox(boxNumber)
    Menu:navigateMenuFromTable(BoxUI.PCBoxCursor, boxNumber)
    Input:pressButtons{buttonKeys={Buttons.A}}
end

---Go from selected box screen to completing the box change.
---No verification
function BoxUI:switchBox()
    Menu:navigateMenuFromTable(BoxUI.PCBoxEdit,  BoxUI.PCBoxEdit.SWITCH)
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:pressButtons{buttonKeys={Buttons.A}}
    Input:performButtonSequence(ButtonSequences.SAVE_GAME)
end

---Close out of the PC
---@return boolean true If overworld is back
function BoxUI:exitPC()
    Input:performButtonSequence(ButtonSequences.EXIT_PC)
    return Positioning:inOverworld()
end

---Get the current focused pokemon in the BoxUI
---@return integer index
function BoxUI:currentPokemonIndex()
    --[[
        ABSTRACT FUNCTION. Will differ between games 
        Determine the index of the currently focused pokemon in the box
    ]]
    return 0
end

-- Abstract tables
Model = {}
Model.PCMainMenu = {}
Model.PCBillsMenu = {}
Model.PCBoxCursor = {}
Model.PCBoxEdit = {}
Model = Factory:loadModel(boxUIFactoryMap)

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
