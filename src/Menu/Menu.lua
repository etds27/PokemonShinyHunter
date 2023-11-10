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
local Model = MenuFactory:loadModel()

-- Load in default tables

-- Merge model into class
Menu = Common:tableMerge(Menu, Model)

function Menu:getCursorPosition()
    --[[
        Get the position of the standard menu cursor

        Returns: position of cursor as int
    ]]
    return Memory:readFromTable(Menu.Cursor)
end

function Menu:getMultiCursorPosition(args)
    --[[
        Get the position of the 2 dimensional menu cursor

        Arguments

        Returns: Table of cursor coordinates
            {x: y:}
    ]]
    return {
        x = Memory:readFromTable(Menu.MultiCursor.X),
        y = Memory:readFromTable(Menu.MultiCursor.Y)
    }
end

function Menu:navigateMenu(currentLocation, endLocation, options)
    --[[
        Navigates a menu to the desired index

        Arguments:
            - currentLocation: Current cursor position
            - endLocation: End value of the cursor position
            - options: Options to control the inputs for menu navigation
                {duration: waitFrames:}
    ]]
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

function Menu:navigateMenuFromTable(cursorTable, endLocation, options)
    --[[
        Navigates a menu to the desired index

        Arguments:
            - cursorTable: Cursor table where the cursor position is held
            - endLocation: End value for the cursor address
            - options: Options to control the inputs for menu navigation
                {duration: waitFrames:}
    ]]
    currentLocation = Memory:readFromTable(cursorTable)
    Menu:navigateMenu(currentLocation, endLocation, options)
    return Memory:readFromTable(cursorTable) == endLocation
end

function Menu:navigateMenuFromAddress(cursorAddress, endLocation, options)
    --[[
        Navigates a menu to the desired index

        Arguments:
            - cursorAddress: 1 Byte address where the cursor position is held
            - endLocation: End value for the cursor address
            - options: Options to control the inputs for menu navigation
                {duration: waitFrames:}
    ]]
    return Menu:navigateMenuFromTable({addr = cursorAddress, size = 1}, endLocation, options)
end