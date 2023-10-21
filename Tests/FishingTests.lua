FishingTest = {}

function FishingTest:fishOnLine()
    savestate.load(TestStates.FISH_ON_LINE)
    ret = Fishing:fish()
    return not Positioning:inOverworld() and ret
end

function FishingTest:fishOffLine()
    savestate.load(TestStates.FISH_OFF_LINE)
    ret = Fishing:fish()
    return Positioning:inOverworld() and not ret
end

print("FishingTest:fishOnLine()", FishingTest:fishOnLine())
print("FishingTest:fishOffLine()", FishingTest:fishOffLine())