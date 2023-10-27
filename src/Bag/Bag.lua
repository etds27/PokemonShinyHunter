require "Common"
require "Log"
require "Memory"
require "Input"
require "Items"


-- Abstract tables
local Model = {}
BagModel.BagPocket = {}
BagModel.BagCursor = {}
BagModel.KeyPocket = {}
BagModel.TMHMPocket = {}
BagModel.BallPocket = {}
BagModel.ItemPocket = {}
local Model = BagFactory:loadModel()

BallPriority = {
    Items.MASTER_BALL,
    Items.ULTRA_BALL,
    Items.GREAT_BALL,
    Items.POKE_BALL
}

function Bag:new(o)
    o = o or {}   -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end

function Bag:navigateToItem(pocket, item)
    --[[
        Moves the bag cursor to the specified item
        Arguments:
            - pocket: The pocket that the item will be in
            - item: The item to select 
    ]]
    if pocket == Model.BagPocket.ITEMS then
        tab = ItemPocket:containsItem(item)
        location = tab[1]
    elseif pocket == Model.BagPocket.BALLS then
        tab = BallPocket:containsItem(item)
        location = tab[1]
    elseif pocket == Model.BagPocket.KEY_ITEMS then
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

    currentLocation = Memory:readFromTable(Model.BagCursor)

    Common:navigateMenu(currentLocation, location)

    return Memory:readFromTable(Model.BagCursor) == location
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
    currentLocation = Memory:readFromTable(Model.BagCursor)
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
            return Bag:useItem(Model.BagPocket.BALLS, ball)
        end
    end
    Log:warning("Did not find any Pokeballs")
    return false
end

function Bag:navigateToPocket(pocket)
    i = 0
    while Memory:readFromTable(Model.BagPocket) ~= pocket and i < 10
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
        pocketTable = Model.ItemPocket
    elseif pocket == BagPocket.BALLS then
        pocketTable = Model.BallPocket
    elseif pocket == BagPocket.KEY_ITEMS then
        pocketTable = Model.KeyPocket
    elseif pocket == BagPocket.TM_HM then
        pocketTable = Model.TMHMPocket
    end

    numOfItemsInPocket = Memory:readFromTable(pocketTable)
    for i = 1, numOfItemsInPocket, 1
    do
        if Common:contains({Model.BagPocket.ITEMS, Model.BagPocket.BALLS}, pocket) then
            itemAddr =  Bag:calculateItemBallAddress(pocketTable.addr, i)
            quantityAddr = itemAddr + 1
        elseif pocket == BagPocket.KEY_ITEMS then
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

local function Bag:calculateItemBallAddress(startingAddress, index)
    return startingAddress + 2 * index - 1
end

local function Bag:calculateKeyItemAddress(startingAddress, index)
    return startingAddress + index
end

function Bag:openPack()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(Model.MenuCursor.addr, 3)
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return Bag:isOpen()
end

function Bag:isOpen()
    --[[
        Determine if the bag is currently open
        I'm a little iffy on if this is the right address
        but it worked across like 5-6 different states
    ]]
    return Memory:readFromTable(Model.BagOpen) == Model.BagOpen.OPEN
end

function Bag:getSelectedItem()
    return Memory:readFromTable(Model.SelectedItem)
end

function ItemPocket:containsItem(item)
    return Bag:doesPocketContain(Model.BagPocket.ITEMS, item)
end

function BallPocket:containsItem(item)
    return Bag:doesPocketContain(Model.BagPocket.BALLS, item)
end

function KeyPocket:containsItem(item)
    return Bag:doesPocketContain(Model.BagPocket.KEY_ITEMS, item)
end

function BallPocket:hasPokeballs()
    --[[
        Determine if the user has any pokeballs left

        Returns:
            - true if there are any amount of any type of pokeball
    ]]
    for i, ball in ipairs(Model.BallPriority)
    do
        tab = BallPocket:containsItem(ball)
        if tab[1] ~= 0 then
            return true
        end
    end
    return false
end
