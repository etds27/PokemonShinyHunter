require "Factory"
require "Memory"
require "Menu"
require "Pokegear"
require "StartMenu"

---@type FactoryMap
local factoryMap = {
    GSRadio = GameGroups.GOLD_SILVER,
    CrystalRadio = {Games.CRYSTAL}
}

Radio = {}

-- Abstract tables
local Model = {}
---@enum Radio.Station
Model.Station = {}
Model = Factory:loadModel(factoryMap)

-- Merge model into class
Radio = Common:tableMerge(Radio, Model)

---Open Pokegear radio and turn to station
---@param station Radio.Station
function Radio:tuneToStation(station)
    -- Open Pokegear
    Pokegear:selectOption(Pokegear.Option.RADIO)
    Common:waitFrames(40)

    Menu:activeNavigateMenuFromTable(Radio.Station, station --[[@as integer]], {duration = 2, waitFrames = 10, downIsUp = false})
    --
end
