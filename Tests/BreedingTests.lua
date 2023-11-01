BreedingTest = {}

function BreedingTest:testWalkToPCFromReset()
    savestate.load(TestStates.EGG_RESET_POINT)
    return Breeding:walkToPCFromReset()
end

function BreedingTest:testWalkToResetPointFromPC()
    savestate.load(TestStates.DAY_CARE_PC)
    return Breeding:walkToResetPointFromPC()
end

function BreedingTest:testWalkToDayCareManFromReset()
    savestate.load(TestStates.EGG_RESET_POINT)
    return Breeding:walkToDayCareManFromReset()
end

function BreedingTest:testWalkToResetFromDayCareMan()
    savestate.load(TestStates.DAY_CARE_MAN)
    return Breeding:walkToResetFromDayCareMan()
end

function BreedingTest:testEggReadyForPickup()
    local testTable = {
        {false, TestStates.EGG_RESET_POINT},
        {true, TestStates.EGG_READY}
    }
    for i, pair in ipairs(testTable)
    do
        print(state)
        local result = pair[1]
        local state = pair[2]
        savestate.load(state)
        if Breeding:eggReadyForPickup() ~= result then
            print("Failed on " .. state)
            return false
        end
    end
    return true
end

function BreedingTest:testPickUpEggs()
    savestate.load(TestStates.EGG_READY)
    return Breeding:pickUpEggs()
end

Log.loggingLevel = LogLevels.INFO
print("BreedingTest:testWalkToPCFromReset()", BreedingTest:testWalkToPCFromReset())
print("BreedingTest:testWalkToResetPointFromPC()", BreedingTest:testWalkToResetPointFromPC())
print("BreedingTest:testWalkToDayCareManFromReset()", BreedingTest:testWalkToDayCareManFromReset())
print("BreedingTest:testWalkToResetFromDayCareMan()", BreedingTest:testWalkToResetFromDayCareMan())
print("BreedingTest:testEggReadyForPickup()", BreedingTest:testEggReadyForPickup())
print("BreedingTest:testPickUpEggs()", BreedingTest:testPickUpEggs())
