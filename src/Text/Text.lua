require "Memory"
require "Factory"

---@type FactoryMap
local factoryMap = {
    GSCTest = GameGroups.GEN_2,
}

Text = {}

local Model = Factory:loadModel(factoryMap)
-- Merge model into class
Text = Common:tableMerge(Text, Model)

---Reads the text from memory
---@param addr address Address to read the text from 
---@param expectedLength integer Expected length of the string
---@return string string Text read
function Text:readTextAtAddress(addr, expectedLength)
    if expectedLength == nil then
        expectedLength = 1000
    end

    local i = 0
    local str = ""
    while i < expectedLength
    do
        local char = Memory:readbyte(addr + i)
        local letter = Text[char]
        if char == Text.TERM or letter == nil then
            break
        end
        str = str .. Text[char]
        i = i + 1
    end
    return str
end

