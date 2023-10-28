BattleTest = {
    AUTO_CATCH_SAVE_STATE = "States\\AutoCatch.State",
    START_OF_BATTLE_SAVE_STATE = "States\\StartOfBattle.State"
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