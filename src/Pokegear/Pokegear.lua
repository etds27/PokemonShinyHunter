require "Factory"
require "Input"
require "Memory"
require "StartMenu"

---@type FactoryMap
local factoryMap = {
    GSPokegear = GameGroups.GOLD_SILVER,
    CrystalPokegear = {Games.CRYSTAL}
}

Pokegear = {}

-- Abstract tables
local Model = {}
---@enum Pokegear.Option
Pokegear.Option = {
    addr = -1,
    size = -1,
    BACK = 0,
    PHONE = 0,
    RADIO = 0,
    MAP = 0
}

Model = Factory:loadModel(factoryMap)

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
