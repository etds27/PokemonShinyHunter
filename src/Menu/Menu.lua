require "Common"
require "Input"
require "Memory"
require "MenuFactory"

Menu = {}

---@class MenuOption: ButtonDuration
---@field vertical boolean? [true] Determines if to use up/down vs. left/right
---@field downIsUp boolean? [true] If set to true, Down/Right goes up in cursor index
---@field maximumPresses integer? [100] Maximum number of times to press a button when navigating

-- Abstract tables
local Model = {}
Model.Cursor = {}
-- When this value is 0, we are at the start of a battle
Model.MultiCursor = {
    X = {},
    Y = {}
}
Model = MenuFactory:loadModel()

-- Load in default tables

-- Merge model into class
Menu = Common:tableMerge(Menu, Model)

---Get the current cursor position of the generic menu
---@return integer position Position of the cursor as int
function Menu:getCursorPosition()
    return Memory:readFromTable(Menu.Cursor)
end

---Get the position of the 2 dimensional menu cursor
---@return Coordinate position The 2-D position of the cursor
function Menu:getMultiCursorPosition()
    return {
        x = Memory:readFromTable(Menu.MultiCursor.X),
        y = Memory:readFromTable(Menu.MultiCursor.Y)
    }
end


---Navigates a menu to the desired index
---@param currentLocation integer Current cursor position
---@param endLocation integer End value of the cursor position
---@param options MenuOption? Options to control the inputs for menu navigation
function Menu:navigateMenu(currentLocation, endLocation, options)
    local button = ""
    local delta = 0
    local duration = Duration.MENU_TAP
    local waitFrames = 10
    local maximumPresses = 100

    if options ~= nil then
        duration = options.duration or Duration.MENU_TAP
        waitFrames = options.waitFrames or 10
        maximumPresses = options.maximumPresses or 100
    end

    delta =  math.min(math.abs(endLocation - currentLocation), maximumPresses)

    button = Menu:getButtonForMenuNavigation(currentLocation, endLocation, options)
    Log:debug("Searching " .. tostring(button) .. " in menu")
    Log:debug("Pressing " .. button .. " " .. tostring(delta) .. " times")
    for _ = 1, math.abs(delta)
    do
        Input:pressButtons{buttonKeys={button}, duration=duration, waitFrames=waitFrames}
    end
end

---Navigates a menu to the desired index from a table
---@param cursorTable MemoryTable: Cursor table where the cursor position is held
---@param endLocation integer End value for the cursor address
---@param options MenuOption? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:navigateMenuFromTable(cursorTable, endLocation, options)
    local currentLocation = Memory:readFromTable(cursorTable)
    Menu:navigateMenu(currentLocation, endLocation, options)
    return Memory:readFromTable(cursorTable) == endLocation
end

---Navigates a menu to the desired index from an address
---@param cursorAddress address 1 Byte address where the cursor position is held
---@param endLocation integer  Desired location for the menu
---@param options MenuOption? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:navigateMenuFromAddress(cursorAddress, endLocation, options)
    return Menu:navigateMenuFromTable({addr = cursorAddress, size = 1}, endLocation, options)
end

---Actively navigates a menu to the desired index from a table
--- 
--- This is different from navigateMenu as it will check the value of the cursor after
--- each button press rather than precalculate the number of presses it should need
---@param cursorTable MemoryTable: Cursor table where the cursor position is held
---@param endLocation integer End value for the cursor address
---@param options MenuOption? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:activeNavigateMenuFromTable(cursorTable, endLocation, options)
    local button = ""
    local duration = Duration.MENU_TAP
    local waitFrames = 10
    local maximumPresses = 100
    if options ~= nil then
        duration = options.duration or Duration.MENU_TAP
        waitFrames = options.waitFrames or 10
        maximumPresses = options.maximumPresses or 100
    end

    local currentLocation = Memory:readFromTable(cursorTable)
    button = Menu:getButtonForMenuNavigation(currentLocation, endLocation, options)
    for _ = 1, maximumPresses
    do
        currentLocation = Memory:readFromTable(cursorTable)
        Log:debug("Menu:activeNavigateMenuFromTable: Current: " .. tostring(currentLocation) .. " End: " .. tostring(endLocation))
        if currentLocation == endLocation then
            return true
        end
        Input:pressButtons{buttonKeys={button}, duration=duration, waitFrames=waitFrames}
    end
    return false
end

---Actively navigates a menu to the desired index from a table
--- 
--- This is different from navigateMenu as it will check the value of the cursor after
--- each button press rather than precalculate the number of presses it should need
---@param cursorAddress address: Cursor table where the cursor position is held
---@param endLocation integer End value for the cursor address
---@param options MenuOption? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:activeNavigateMenuFromAddress(cursorAddress, endLocation, options)
    return Menu:navigateMenuFromTable({addr = cursorAddress, size = 1}, endLocation, options)
end

---@private
---Determine which button we should press to navigate a menu
---@param currentLocation integer Current cursor position
---@param endLocation integer End value for the cursor address
---@param options MenuOption? Options to control the inputs for menu navigation
---@return Buttons
function Menu:getButtonForMenuNavigation(currentLocation, endLocation, options)
    local button = ""
    local delta = 0
    local downIsUp = true
    local vertical = true
    if options ~= nil then
        if options.downIsUp ~= nil then
            downIsUp = options.downIsUp
        end
        if options.vertical ~= nil then
            vertical = options.vertical
        end
    end
    -- Button that will make the cursor index increase
    local increaseButton
    -- Button that will make the cursor index decrease
    local decreaseButton
    if vertical and downIsUp then
        increaseButton = Buttons.DOWN
        decreaseButton = Buttons.UP
    elseif vertical and not downIsUp then
        increaseButton = Buttons.UP
        decreaseButton = Buttons.DOWN
    elseif not vertical and downIsUp then
        increaseButton = Buttons.RIGHT
        decreaseButton = Buttons.LEFT
    elseif not vertical and not downIsUp then
        increaseButton = Buttons.LEFT
        decreaseButton = Buttons.RIGHT
    end

    delta = endLocation - currentLocation
    if delta > 0 then
        button = increaseButton
    else
        button = decreaseButton
    end
    return button
end
