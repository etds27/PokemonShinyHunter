require "Memory"

Text = {}    

local Model = TextFactory:loadModel()
-- Merge model into class
Text = Common:tableMerge(Text, Model)

function Text:readTextAtAddress(addr, expectedLength)
    if expectedLength == nil then
        expectedLength = 1000
    end
    
    local i = 0
    local str = ""
    while i < expectedLength
    do
        char = Memory:readbyte(addr + i)
        letter = Text[char]
        if char == Text.TERM or letter == nil then
            break
        end
        str = str .. Text[char]
        i = i + 1
    end
    return str 
end

