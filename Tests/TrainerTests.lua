TrainerTest = {}

function TrainerTest:testTrainerName()
    savestate.load(TestStates.FISH_ON_LINE)
    return Trainer:getName() == "CHRIS"
end

function TrainerTest:testTrainerMoney()
    savestate.load(TestStates.FISH_ON_LINE)
    return Trainer:getTrainerMoney() == 3176
end

function TrainerTest:testTrainerID()
    savestate.load(TestStates.FISH_ON_LINE)
    return Trainer:getTrainerID() == 51032
end

print("TrainerTest:testTrainerName()", TrainerTest:testTrainerName())
print("TrainerTest:testTrainerMoney()", TrainerTest:testTrainerMoney())
print("TrainerTest:testTrainerID()", TrainerTest:testTrainerID())