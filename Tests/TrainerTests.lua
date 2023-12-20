TrainerTest = {}

function TrainerTest:testTrainerName()
    savestate.load(TestStates.TRAINER_TESTS)
    return Trainer:getName() == "CHRIS"
end

function TrainerTest:testTrainerMoney()
    savestate.load(TestStates.TRAINER_TESTS)
    return Trainer:getTrainerMoney() == 0x0C68 -- 3176
end

function TrainerTest:testTrainerID()
    savestate.load(TestStates.TRAINER_TESTS)
    return Trainer:getTrainerID() == 0xC758 -- 51032
end

print("TrainerTest:testTrainerName()", TrainerTest:testTrainerName())
print("TrainerTest:testTrainerMoney()", TrainerTest:testTrainerMoney())
print("TrainerTest:testTrainerID()", TrainerTest:testTrainerID())