require "Common"
require "Log"
require "Memory"
require "Input"

Bag = {}
BagPocket = {
    addr = 0xCF65,
    size = 1,
    ITEMS = 0,
    BALLS = 1,
    KEY_ITEMS = 2,
    TM_HM = 3,
}

BagCursor = { -- Starts at 1
    addr = 0xCFA9,
    size = 1,
}

ItemPocket = {
    addr = 0xD892,
    size = 1
}

BallPocket = {
    addr = 0xD8D7,
    size = 1
}

KeyPocket = {
    addr = 0xD8BC,
    size = 1
}

TMHMPocket = {
    addr = 0xD859,
    size = 1
}

BattleItem = {
    USE = 1,
    QUIT = 2,
}

BagOpen = {
    addr = 0xCFCC,
    size = 1,
    OPEN = 19,
}

BallPriority = {
    Items.MASTER_BALL,
    Items.ULTRA_BALL,
    Items.GREAT_BALL,
    Items.POKE_BALL
}

SelectedItem = {
    addr = 0xD95C,
    size = 1
}

function Bag:navigateToItem(pocket, item)
    --[[
        Moves the bag cursor to the specified item
        Arguments:
            - pocket: The pocket that the item will be in
            - item: The item to select 
    ]]
    if pocket == BagPocket.ITEMS then
        tab = ItemPocket:containsItem(item)
        location = tab[1]
    elseif pocket == BagPocket.BALLS then
        tab = BallPocket:containsItem(item)
        location = tab[1]
    elseif pocket == BagPocket.KEY_ITEMS then
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

    currentLocation = Memory:readFromTable(BagCursor)

    Common:navigateMenu(currentLocation, location)

    return Memory:readFromTable(BagCursor) == location
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
    currentLocation = Memory:readFromTable(BagCursor)
    Common:navigateMenu(currentLocation, BattleItem.USE)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end

function Bag:useBestBall()
    --[[
        Uses the best available pokeball
    ]]
    for i, ball in ipairs(BallPriority)
    do
        if BallPocket:containsItem(ball)[1] ~= 0 then
            Log:debug("Using ball: " .. ball)
            return Bag:useItem(BagPocket.BALLS, ball)
        end
    end
    Log:warning("Did not find any Pokeballs")
    return false
end

function Bag:navigateToPocket(pocket)
    i = 0
    while Memory:readFromTable(BagPocket) ~= pocket and i < 10
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
    if pocket == BagPocket.ITEMS then
        pocketTable = ItemPocket
    elseif pocket == BagPocket.BALLS then
        pocketTable = BallPocket
    elseif pocket == BagPocket.KEY_ITEMS then
        pocketTable = KeyPocket
    elseif pocket == BagPocket.TM_HM then
        pocketTable = TMHMPocket
    end

    numOfItemsInPocket = Memory:readFromTable(pocketTable)
    for i = 1, numOfItemsInPocket, 1
    do
        if Common:contains({BagPocket.ITEMS, BagPocket.BALLS}, pocket) then
            itemAddr =  Bag:_calculateItemBallAddress(pocketTable.addr, i)
            quantityAddr = itemAddr + 1
        elseif pocket == BagPocket.KEY_ITEMS then
            itemAddr = Bag:_calculateKeyItemAddress(pocketTable.addr, i)
            quantityAddr = itemAddr
        end

        currentItem = Memory:readbyte(itemAddr)
        if currentItem == item then
            return {i, Memory:readbyte(quantityAddr)}
        end
    end
    return {0, 0}
end

function Bag:_calculateItemBallAddress(startingAddress, index)
    return startingAddress + 2 * index - 1
end

function Bag:_calculateKeyItemAddress(startingAddress, index)
    return startingAddress + index
end

function Bag:openPack()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(MenuCursor.addr, 3)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return Bag:isOpen()
end

function Bag:isOpen()
    --[[
        Determine if the bag is currently open
        I'm a little iffy on if this is the right address
        but it worked across like 5-6 different states
    ]]
    return Memory:readFromTable(BagOpen) == BagOpen.OPEN
end

function Bag:getSelectedItem()
    return Memory:readFromTable(SelectedItem)
end

function ItemPocket:containsItem(item)
    return Bag:doesPocketContain(BagPocket.ITEMS, item)
end

function BallPocket:containsItem(item)
    return Bag:doesPocketContain(BagPocket.BALLS, item)
end

function KeyPocket:containsItem(item)
    return Bag:doesPocketContain(BagPocket.KEY_ITEMS, item)
end

function BallPocket:hasPokeballs()
    --[[
        Determine if the user has any pokeballs left

        Returns:
            - true if there are any amount of any type of pokeball
    ]]
    for i, ball in ipairs(BallPriority)
    do
        tab = BallPocket:containsItem(ball)
        if tab[1] ~= 0 then
            return true
        end
    end
    return false
end
