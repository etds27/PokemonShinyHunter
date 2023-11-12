require "Memory"
require "Menu"
require "Pokegear"
require "src.Pokegear.Models.RadioFactory"
require "StartMenu"

Radio = {}

-- Abstract tables
local Model = {}
Model.Station = {}
Model = RadioFactory:loadModel()

-- Merge model into class
Radio = Common:tableMerge(Radio, Model)

---Open Pokegear radio and turn to station
---@param station Radio.Station
function Radio:tuneToStation(station)
    -- Open Pokegear
    Pokegear:selectOption(Pokegear.Option.RADIO)
    Common:waitFrames(40)

    print(Radio.Station.POKE_FLUTE, Memory:readFromTable(Radio.Station))
    Menu:activeNavigateMenuFromTable(Radio.Station, station, {duration = 2, waitFrames = 10, downIsUp = false})
    --
end
