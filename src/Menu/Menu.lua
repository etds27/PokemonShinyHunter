require "Common"
require "Input"
require "Memory"
require "MenuFactory"

Menu = {}

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
---@param options ButtonPress? Options to control the inputs for menu navigation
function Menu:navigateMenu(currentLocation, endLocation, options)
    local button = ""
    local delta = 0
    local duration = Duration.MENU_TAP
    local waitFrames = 10
    if options ~= nil then
        if options.duration ~= nil then
            duration = options.duration
        end
        if options.waitFrames ~= nil then
            waitFrames = options.waitFrames
        end
    end

    delta = endLocation - currentLocation
    if delta > 0 then
        Log:debug("Searching DOWN in menu")
        button = Buttons.DOWN
    else
        Log:debug("Searching UP in menu")
        button = Buttons.UP
    end

    Log:debug("Pressing " .. button .. " " .. tostring(delta) .. " times")
    for i = 1, math.abs(delta)
    do
        Input:pressButtons{buttonKeys={button}, duration=duration, waitFrames=waitFrames}
    end
end

---Navigates a menu to the desired index from a table
---@param cursorTable MemoryTable: Cursor table where the cursor position is held
---@param endLocation integer End value for the cursor address
---@param options ButtonPress? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:navigateMenuFromTable(cursorTable, endLocation, options)
    local currentLocation = Memory:readFromTable(cursorTable)
    Menu:navigateMenu(currentLocation, endLocation, options)
    return Memory:readFromTable(cursorTable) == endLocation
end

---Navigates a menu to the desired index from an address
---@param cursorAddress address 1 Byte address where the cursor position is held
---@param endLocation integer  Desired location for the menu
---@param options ButtonPress? Options to control the inputs for menu navigation
---@return boolean true if the memory address is at the desired location
function Menu:navigateMenuFromAddress(cursorAddress, endLocation, options)
    return Menu:navigateMenuFromTable({addr = cursorAddress, size = 1}, endLocation, options)
end