-- require "Log"
-- require "Memory"
-- require "Input"

Common = {}

function Common:waitFrames(number)
    for _ = 1, number, 1 do emu.frameadvance() end
end

function Common:shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function Common:find(table, value)
    for index, item in ipairs(table) do
        if item == value then
            return index
        end
    end
    return -1
end

function Common:contains(table, value)
    if Common:find(table, value) ~= -1 then
        return true
    end
    return false
end

function Common:navigateMenu(currentLocation, endLocation)
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
        Input:pressButtons{buttonKeys={button}, duration=Duration.MENU_TAP, waitFrames=10}
    end
end

function Common:navigateMenuFromAddress(cursorAddress, endLocation)
    --[[
        Navigates a menu to the desired index

        Arguments:
            - cursorAddress: 1 Byte address where the cursor position is held
            - endLocation: End value for the cursor address
    ]]
    currentLocation = Memory:read(cursorAddress, 1)
    return Common:navigateMenu(currentLocation, endLocation)
end

function Common:tableLength(table)
    i = 0
    for _ in pairs(table)
    do
        i = i + 1
    end
    return i
end

function Common:tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function Common:waitForState(addrTab, desiredState, frameLimit)
    --[[
        General function to advance frames until a specific memory address is set to a value

        Arguments:
            - addrTab: Address table to look up in memory
                {addr: size: memdomain: frameLimit:}
            - desiredState: Expected value to wait for
            - frameLimit: Maximum number of frames to wait
                Default: 1000 (frames)
        Returns: true if the desired state is found in memory
    ]]
    if frameLimit == nil then
        if addrTab.frameLimit == nil then
            frameLimit = 1000
        else
            frameLimit = addrTab.frameLimit
        end
    end

    local i = 0

    for i = 1, frameLimit 
    do
        if Memory:readFromTable(addrTab) == desiredState then
            return true
        end
    end
    return false
end

function Common:resetRequires(list)
    --[[
        Reset the specified required modules so that `require` will load them again
    ]]
    for i, packageName in ipairs(list)
    do
        if package.loaded[packageName] ~= nil then
            package.loaded[packageName] = nil
        end
    end
end

function Common:currentTime()
    return os.clock()
end