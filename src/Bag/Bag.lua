require "Common"
require "Log"
require "Memory"
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

function Bag:navigateToItem(pocket, item)
    --[[
        Moves the bag cursor to the specified item
        Arguments:
            - pocket: The pocket that the item will be in
            - item: The item to select 
    ]]
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
    currentLocation = Memory:readFromTable(Bag.Cursor)
    Common:navigateMenu(currentLocation, location)
 
    return Memory:readFromTable(Bag.Cursor) == location
end

function Bag:useItem(pocket, item)
    --[[
        Use the item specified both in and out of battle
        Arguments:
            - pocket: The pocket that the item will be in
            - item: The item to select 
    ]]
    if not Bag:navigateToItem(pocket, item) then
        return false
    end

    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS} -- TAP is too short
    currentLocation = Memory:readFromTable(Bag.Cursor)
    Common:navigateMenu(currentLocation, Bag.BattleItem.USE)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end

function Bag:useBestBall()
    --[[
        Uses the best available pokeball
    ]]
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

function Bag:navigateToPocket(pocket)
    i = 0
    while Memory:readFromTable(Bag.Pocket) ~= pocket and i < 10
    do
        Input:pressButtons{buttonKeys={Buttons.RIGHT}, duration=Duration.TAP}
        i = i + 1
    end
    return i ~= 10
end

function Bag:doesPocketContain(pocket, item) 
    --[[
        Generic method to determine if the player has a certain item
        Use for: Item, and Ball pockets

        Arguments: 
            - pocket: Pocket table
            - item: The value of the item that is being searched for

        Returns: Tuple:
            - Location of item in the bag, 0 if not found
            - Quantity of item, 0 if not found or same as location addr if key item
    ]]
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
            itemAddr =  calculateItemBallAddress(pocketTable.addr, i)
            quantityAddr = itemAddr + 1
        elseif pocket == Bag.Pocket.KEY_ITEMS then
            itemAddr = calculateKeyItemAddress(pocketTable.addr, i)
            quantityAddr = itemAddr
        end

        currentItem = Memory:readbyte(itemAddr)
        if currentItem == item then
            return {i, Memory:readbyte(quantityAddr)}
        end
    end
    return {0, 0}
end

function calculateItemBallAddress(startingAddress, index)
    return startingAddress + 2 * index - 1
end

function calculateKeyItemAddress(startingAddress, index)
    return startingAddress + index
end

function Bag:openPack()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(Bag.Cursor.addr, 3)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return Bag:isOpen()
end

function Bag:closePack()
    Input:repeatedlyPressButton{buttonKeys={Buttons.B}, duration=Duration.PRESS, iterations=6}
end

function Bag:isOpen()
    --[[
        Determine if the bag is currently open
        I'm a little iffy on if this is the right address
        but it worked across like 5-6 different states
    ]]
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

function KeyPocket:selectItem(item)
    --[[
        Registers an item in the key pocket
    ]]
    if Bag:getSelectedItem() == item then
        return true
    end

    print(KeyPocket:containsItem(item), item)
    if not Bag:navigateToItem(Bag.Pocket.KEY_ITEMS, item) then
        Log:error("Unable to find item to register")
        return false
    end
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS} -- TAP is too short
    currentLocation = Memory:readFromTable(Bag.Cursor)
    Common:navigateMenu(currentLocation, Bag.KeyMenu.SEL)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
end

function BallPocket:hasPokeballs()
    --[[
        Determine if the user has any pokeballs left

        Returns:
            - true if there are any amount of any type of pokeball
    ]]
    for i, ball in ipairs(Bag.BallPriority)
    do
        tab = BallPocket:containsItem(ball)
        if tab[1] ~= 0 then
            return true
        end
    end
    return false
end