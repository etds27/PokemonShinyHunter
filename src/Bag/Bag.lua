require "BagFactory"
require "Common"
require "Log"
require "StartMenu"
require "Memory"
require "Menu"
require "Input"
require "Items"

-- Abstract tables
local Model = {}
Model.BagPocket = {}
Model.Cursor = {}
Model.KeyPocket = {}
Model.TMHMPocket = {}
Model.BallPocket = {}
Model.ItemPocket = {}
local Model = BagFactory:loadModel()

-- Load in default tables
local BallPriority = {
    Items.MASTER_BALL,
    Items.ULTRA_BALL,
    Items.GREAT_BALL,
    Items.POKE_BALL
}

-- 
Bag = {
    BallPriority = BallPriority
}
Bag = Common:tableMerge(Bag, Model)
ItemPocket = {}
KeyPocket = {}
TMHMPocket = {}
BallPocket = {}

---Moves the bag cursor to the specified item
---@param pocket integer The pocket that the item will be in
---@param item integer The item to select 
function Bag:navigateToItem(pocket, item)
    if pocket == Bag.Pocket.ITEMS then
        tab = ItemPocket:containsItem(item)
        location = tab[1]
    elseif pocket == Bag.Pocket.BALLS then
        tab = BallPocket:containsItem(item)
        location = tab[1]
    elseif pocket == Bag.Pocket.KEY_ITEMS then
        tab = KeyPocket:containsItem(item)
        location = tab[1]
    end

    -- Item was not found
    if location == 0 then
        Log:error("Unable to find item")
        return false
    end

    if not Bag:navigateToPocket(pocket) then
        Log:error("Unable to navigate to pocket")
        return false
    end 
    Menu:navigateMenuFromTable(Bag.Cursor, location)
 
    return Memory:readFromTable(Bag.Cursor) == location
end

---Use the item specified both in and out of battle
---@param pocket integer The pocket that the item will be in
---@param item integer The item to select 
---@return boolean
function Bag:useItem(pocket, item)
    if not Bag:navigateToItem(pocket, item) then
        return false
    end

    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS} -- TAP is too short
    currentLocation = Memory:readFromTable(Bag.Cursor)
    Menu:navigateMenuFromTable(Bag.Cursor, Bag.BattleItem.USE)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end


---Uses the best available pokeball
function Bag:useBestBall()
    for i, ball in ipairs(Bag.BallPriority)
    do
        if BallPocket:containsItem(ball)[1] ~= 0 then
            Log:debug("Using ball: " .. ball)
            return Bag:useItem(Bag.Pocket.BALLS, ball)
        end
    end
    Log:warning("Did not find any Pokeballs")
    return false
end

---Change the bag view to the specified pocket
---@param pocket integer The pocket value to change the bag view to
---@return boolean `true` if the correct pocket is displayed
function Bag:navigateToPocket(pocket)
    local i = 0
    while  i < 10
    do
        if Memory:readFromTable(Bag.Pocket) == pocket then
            return true
        end
        Input:pressButtons{buttonKeys={Buttons.RIGHT}, duration=Duration.TAP}
        i = i + 1
    end
    return false
end

--- Generic method to determine if the player has a certain item
---
---Use for: Item, and Ball pockets
---@param pocket integer The pocket value to change the bag view to
---@param item integer The item to select 
---@return table
---| 0: Location of item in the bag, 0 if not found
---| 1: Quantity of item, 0 if not found or same as location addr if key item
function Bag:doesPocketContain(pocket, item) 
    local pocketTable = {}
    local numOfItemsInPocket = 0
    local itemAddr = 0x0
    local quantityAddr = 0x0
    local currentItem = 0

    if pocket == Bag.Pocket.ITEMS then
        pocketTable = Bag.ItemPocket
    elseif pocket == Bag.Pocket.BALLS then
        pocketTable = Bag.BallPocket
    elseif pocket == Bag.Pocket.KEY_ITEMS then
        pocketTable = Bag.KeyPocket
    elseif pocket == Bag.Pocket.TM_HM then
        pocketTable = Bag.TMHMPocket
    end

    numOfItemsInPocket = Memory:readFromTable(pocketTable)
    for i = 1, numOfItemsInPocket, 1
    do
        if Common:contains({Bag.Pocket.ITEMS, Bag.Pocket.BALLS}, pocket) then
            itemAddr =  Bag:calculateItemBallAddress(pocketTable.addr, i)
            quantityAddr = itemAddr + 1
        elseif pocket == Bag.Pocket.KEY_ITEMS then
            itemAddr = Bag:calculateKeyItemAddress(pocketTable.addr, i)
            quantityAddr = itemAddr
        end

        currentItem = Memory:readbyte(itemAddr)
        if currentItem == item then
            return {i, Memory:readbyte(quantityAddr)}
        end
    end
    return {0, 0}
end


---@private
function Bag:calculateItemBallAddress(startingAddress, index)
    return startingAddress + 2 * index - 1
end

---@private
function Bag:calculateKeyItemAddress(startingAddress, index)
    return startingAddress + index
end

function Bag:openPack()
    StartMenu:open()
    StartMenu:selectOption(StartMenu.PACK)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return Bag:isOpen()
end

function Bag:closePack()
    Input:repeatedlyPressButton{buttonKeys={Buttons.B}, duration=Duration.PRESS, iterations=6}
end

---Determine if the bag is currently open
---I'm a little iffy on if this is the right address
---but it worked across like 5-6 different states
---@return boolean `true` if bag is open
function Bag:isOpen()
    return Memory:readFromTable(Bag.BagOpen) == Model.BagOpen.OPEN
end

function Bag:getSelectedItem()
    return Memory:readFromTable(Bag.SelectedItem)
end

function ItemPocket:containsItem(item)
    return Bag:doesPocketContain(Bag.Pocket.ITEMS, item)
end

function BallPocket:containsItem(item)
    return Bag:doesPocketContain(Bag.Pocket.BALLS, item)
end

function KeyPocket:containsItem(item)
    return Bag:doesPocketContain(Bag.Pocket.KEY_ITEMS, item)
end

---Registers an item in the key pocket
---@param item integer Key item to register
---@return boolean `true` if item was successfully registered
function KeyPocket:selectItem(item)
    if Bag:getSelectedItem() == item then
        return true
    end

    if not Bag:navigateToItem(Bag.Pocket.KEY_ITEMS, item) then
        Log:error("Unable to find item to register")
        return false
    end
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS} -- TAP is too short
    Menu:navigateMenuFromTable(Bag.Cursor, Bag.KeyMenu.SEL)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end

---Determine if the user has any pokeballs left
---@return boolean true if there are any amount of any type of pokeball
function BallPocket:hasPokeballs()
    for i, ball in ipairs(Bag.BallPriority)
    do
        local tab = BallPocket:containsItem(ball)
        if tab[1] ~= 0 then
            return true
        end
    end
    return false
end