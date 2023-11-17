require "Common"
require "Factory"
require "Log"
require "Memory"

---@type FactoryMap
local factoryMap = {
    GSTrainer = GameGroups.GOLD_SILVER,
    CrystalTrainer = {Games.CRYSTAL}
}

Trainer = {}

local Model = {}
Model.ID = {}
Model.Money = {}
Model.PlayTime = {
    Hour = {},
    Minute = {},
    Second = {}
}
Model.Name = {}
Model = Factory:loadModel(factoryMap)

-- Merge model into class
Trainer = Common:tableMerge(Trainer, Model)

---Get the trainer's ID
---@return integer id Trainer ID
function Trainer:getTrainerID()
    return Memory:readFromTable(Trainer.ID)
end

---Get the total number of money
---@return integer money total number of money
function Trainer:getTrainerMoney()
    return Memory:readFromTable(Trainer.Money)
end

---Get the total number of Game Corner coins
---@return integer coins total number of Game Corner coins
function Trainer:getTrainerCoins()
    return Memory:readFromTable(Trainer.Coins)
end

---Get the current play time for the trainer
---@return Time
function Trainer:getPlayTime()
    return {hour = Memory:readFromTable(Trainer.PlayTime.Hour),
            minute = Memory:readFromTable(Trainer.PlayTime.Minute),
            second = Memory:readFromTable(Trainer.PlayTime.Second)
    }
end

---Get the trainer's name
---@return string name Trainer's name
function Trainer:getName()
    return Text:readTextAtAddress(Trainer.Name.addr, Trainer.Name.maxLength)
end
