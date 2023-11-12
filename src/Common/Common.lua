require "Log"
require "Memory"
-- require "Input"

Common = {}

---Advance the emulator a specified amount of frames
---@param number integer Number of frames to advance
function Common:waitFrames(number)
    for _ = 1, number, 1 do emu.frameadvance() end
end

---Shallow copy a table
---@param orig any Item to copy
---@return any newItem A copy of the original item
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

---Find a value in a list
---@param tab table Table to search in
---@param value any Value to search for in table
---@return integer index Index of item in table if found. -1 if not found
function Common:find(tab, value)
    for index, item in ipairs(tab) do
        if item == value then
            return index
        end
    end
    return -1
end

---Check if a table contains a certain item
---@param tab table Table to search in
---@param value any Value to search for in table
---@return boolean true if the item was found
function Common:contains(tab, value)
    return Common:find(tab, value) ~= -1
end


---Determine the length of a table
---@param tab table Table to search in
---@return integer count The number of items in the table
function Common:tableLength(tab)
    local i = 0
    for _ in pairs(tab)
    do
        i = i + 1
    end
    return i
end


---Merge t2 into t1
---@param t1 table
---@param t2 table
---@return table mergedTable The merged table
function Common:tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                Common:tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

---General function to advance frames until a specific memory address is set to a value
---@param addrTab MemoryTable table to look up in memory
---@param desiredState integer|table Expected value to wait for. Can be list of values
---@param frameLimit integer? [1000] Maximum number of frames to wait
---@return boolean true if the desired state is found in memory
function Common:waitForState(addrTab, desiredState, frameLimit)
    if frameLimit == nil then
        if addrTab.frameLimit == nil then
            frameLimit = 1000
        else
            frameLimit = addrTab.frameLimit
        end
    end

    if type(desiredState) ~= "table" then
        desiredState = {desiredState}
    end

    for _ = 1, frameLimit 
    do
        if Common:contains(desiredState, Memory:readFromTable(addrTab)) then
            return true
        end
        emu.frameadvance()
    end
    return false
end


---General function to advance frames until a specific memory address is not set to a value
---@param addrTab MemoryTable table to look up in memory
---@param undesiredState integer|table Expected value to wait for. Can be list of values
---@param frameLimit integer [1000] Maximum number of frames to wait
---@return boolean true if the desired state is found in memory
function Common:waitForNotState(addrTab, undesiredState, frameLimit)
    if frameLimit == nil then
        if addrTab.frameLimit == nil then
            frameLimit = 1000
        else
            frameLimit = addrTab.frameLimit
        end
    end

    if type(undesiredState) ~= "table" then
        undesiredState = {undesiredState}
    end

    for _ = 1, frameLimit
    do
        if not Common:contains(undesiredState, Memory:readFromTable(addrTab)) then
            return true
        end
        emu.frameadvance()
    end
    return false
end

---Reset the specified required modules so that `require` will load them again
---@param list table List of modules to reset
function Common:resetRequires(list)
    for _, packageName in ipairs(list)
    do
        if package.loaded[packageName] ~= nil then
            package.loaded[packageName] = nil
        end
    end
end

---The current system time
---@return number current system time
function Common:currentTime()
    return os.clock()
end

---Convert coordinate or position to a string
---@param coord Coordinate|Position
---@return string
function Common:coordinateToString(coord)
    return "x: " .. tostring(coord.x) .. ", y: " .. tostring(coord.y) 
end