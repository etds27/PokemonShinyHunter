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
        Input:pressButtons{buttonKeys={button}, duration=Duration.MENU_TAP}
    end
end