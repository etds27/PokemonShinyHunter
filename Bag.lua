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
    numAddr = 0xD892
}

BallPocket = {
    numAddr = 0xD8D7
}

KeyPocket = {
    numAddr = 0xD8BC
}

TMHMPocket = {
    numAddr = 0xD859
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
            - Quantity of item, 0 if not found
    ]]
    pocketAddr = pocket.numAddr
    numOfItemsInPocket = Memory:readbyte(pocketAddr)
    for i = 1, numOfItemsInPocket, 1
    do
        itemAddr = pocketAddr + (2 * i - 1)
        quatityAddr = pocketAddr + (2 * i)

        currentItem = Memory:readbyte(itemAddr)
        if currentItem == item then
            return {i, Memory:readbyte(quatityAddr)}
        end
    end
    return {0, 0}
end

function Bag:isOpen()
    --[[
        Determine if the bag is currently open
        I'm a little iffy on if this is the right address
        but it worked across like 5-6 different states
    ]]
    return Memory:readFromTable(BagOpen) == BagOpen.OPEN
end

function ItemPocket:containsItem(item)
    return Bag:doesPocketContain(ItemPocket, item)
end

function BallPocket:containsItem(item)
    return Bag:doesPocketContain(BallPocket, item)
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
