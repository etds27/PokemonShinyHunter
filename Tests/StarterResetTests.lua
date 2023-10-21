StarterResetTest = {}
GameSettings.initialize()
Log.loggingLevel = LogLevels.INFO
function StarterResetTest:testStarterResetCyndaquil()
    savestate.load(TestStates.STARTER_CYNDAQUIL)
    CustomSequences:starterEncounter()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(MenuCursor.addr, 6) -- Exit
    return Memory:readFromTable(MenuCursor) == 6
end

function StarterResetTest:testStarterResetTotadile()
    savestate.load(TestStates.STARTER_TOTADILE)
    CustomSequences:starterEncounter()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(MenuCursor.addr, 6) -- Exit
    return Memory:readFromTable(MenuCursor) == 6
end

function StarterResetTest:testStarterResetChikorita()
    savestate.load(TestStates.STARTER_CHIKORITA)
    CustomSequences:starterEncounter()
    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS}
    Common:navigateMenuFromAddress(MenuCursor.addr, 6) -- Exit
    return Memory:readFromTable(MenuCursor) == 6
end

print("StarterResetTest:testStarterResetCyndaquil()", StarterResetTest:testStarterResetCyndaquil())
print("StarterResetTest:testStarterResetTotadile()", StarterResetTest:testStarterResetTotadile())
print("StarterResetTest:testStarterResetChikorita()", StarterResetTest:testStarterResetChikorita())