require "Input"
require "Memory"
require "src.Pokegear.Models.PokegearFactory"
require "StartMenu"

Pokegear = {}

-- Abstract tables
local Model = {}
Pokegear.Option = {
    addr = -1,
    size = -1
}
Model = PokegearFactory:loadModel()

-- Merge model into class
Pokegear = Common:tableMerge(Pokegear, Model)

---Open Pokegear radio and change to option
---comment
---@param option Pokegear.Option Page to change Pokegear to
---@param maxInputs integer? [10] Maximum number of button presses
function Pokegear:selectOption(option, maxInputs)
    maxInputs = maxInputs or 10

    -- Open Pokegear
    StartMenu:open()
    StartMenu:selectOption(StartMenu.POKEGEAR)

    local button
    for _ = 1,maxInputs
    do
        local currentOption = Memory:readFromTable(Pokegear.Option)
        if currentOption > option then
            button = Buttons.LEFT
        elseif currentOption < option then
            button = Buttons.RIGHT
        else
            return true
        end
        Input:pressButtons{buttonKeys={button},
                           duration=8,
                           waitFrames=2}
    end

    return false
end
