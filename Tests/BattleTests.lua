BattleTest = {
    AUTO_CATCH_SAVE_STATE = TestStates.AUTO_CATCH_SAVE_STATE,
    START_OF_BATTLE_SAVE_STATE = TestStates.START_OF_BATTLE_SAVE_STATE
}

function BattleTest:testGetCatchStatus() 
    savestate.load(BattleTest.AUTO_CATCH_SAVE_STATE)
    return Battle:getCatchStatus() == 1
end

function BattleTest:testRunFromPokemon()
    savestate.load(BattleTest.START_OF_BATTLE_SAVE_STATE)
    return Battle:runFromPokemon()
end

function BattleTest:testOpenPack()
    savestate.load(BattleTest.START_OF_BATTLE_SAVE_STATE)
    Battle:openPack()
    return Bag:isOpen()
end

GameSettings.initialize()
Log.loggingLevel = LogLevels.INFO
print("BattleTest:testGetCatchStatus()", BattleTest:testGetCatchStatus())
print("BattleTest:testRunFromPokemon()", BattleTest:testRunFromPokemon())
print("BattleTest:testOpenPack()", BattleTest:testOpenPack())