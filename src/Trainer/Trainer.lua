require "Common"
require "Log"
require "Memory"
require "TrainerFactory"

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
Model = TrainerFactory:loadModel()

-- Merge model into class
Trainer = Common:tableMerge(Trainer, Model)

function Trainer:getTrainerID()
    return Memory:readFromTable(Trainer.ID)
end

function Trainer:getTrainerMoney()
    return Memory:readFromTable(Trainer.Money)
end 

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

function Trainer:getName()
    return Text:readTextAtAddress(Trainer.Name.addr, Trainer.Name.maxLength)
end
