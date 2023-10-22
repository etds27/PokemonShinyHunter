require "Common"
require "Log"
require "Memory"

Trainer = {}

TrainerID = {
    addr = 0xD114,
    size = 2
}

TrainerMoney = {
    addr = 0xD84F,
    size = 2
}

TrainerPlayTime = {
    hrAddr = 0xD4C5,
    minAddr = 0xD4C6,
    secAddr = 0xD4C7,
    size = 1
}

function Trainer:getTrainerID()
    return Memory:readFromTable(TrainerID)
end

function Trainer:getTrainerMoney()
    return Memory:readFromTable(TrainerMoney)
end 

function Trainer:getPlayTime()
    hr = Memory:read(TrainerPlayTime.hrAddr, TrainerPlayTime.size)
    min = Memory:read(TrainerPlayTime.minAddr, TrainerPlayTime.size)
    sec = Memory:read(TrainerPlayTime.secAddr, TrainerPlayTime.size)
    return {hr, min, sec}
end
