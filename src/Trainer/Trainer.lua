require "Common"
require "Log"
require "Memory"

Trainer = {}

local Model = {}
Model.ID = {}
Model.Money = {}
Model.PlayTime = {}
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

function Trainer:getPlayTime()
    hr = Memory:read(Trainer.PlayTime.hrAddr, Trainer.PlayTime.size)
    min = Memory:read(Trainer.PlayTime.minAddr, Trainer.PlayTime.size)
    sec = Memory:read(Trainer.PlayTime.secAddr, Trainer.PlayTime.size)
    return {hr, min, sec}
end

function Trainer:getName()
    return Text:readTextAtAddress(Trainer.Name.addr, Trainer.Name.maxLength)
end
