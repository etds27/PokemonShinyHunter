
BagTest = {
    SAVE_STATE_PATH = TestStates.BAG_TEST
}

function BagTest:testBagContainsBall()
    savestate.load(BagTest.SAVE_STATE_PATH)
    tab = BallPocket:containsItem(Items.POKE_BALL)
    return tab[1] == 1 and tab[2] == 2
end

function BagTest:testBagDoesntContainBall()
    savestate.load(BagTest.SAVE_STATE_PATH)
    tab = BallPocket:containsItem(Items.GREAT_BALL)
    return tab[1] == 0 and tab[2] == 0
end

function BagTest:testBagContainsItem()
    savestate.load(BagTest.SAVE_STATE_PATH)
    tab = ItemPocket:containsItem(Items.ANTIDOTE)
    return tab[1] == 2 and tab[2] == 1
end

function BagTest:testBagDoesntContainItem()
    savestate.load(BagTest.SAVE_STATE_PATH)
    tab = ItemPocket:containsItem(Items.THUNDER_STONE)
    return tab[1] == 0 and tab[2] == 0
end

function BagTest:testBagContainsKeyItem()
    savestate.load(TestStates.FISH_ON_LINE)
    tab = KeyPocket:containsItem(Items.OLD_ROD)
    return tab[1] == 2
end

function BagTest:testBagDoesntContainItem()
    savestate.load(TestStates.FISH_OFF_LINE)
    tab = KeyPocket:containsItem(Items.SILVER_WING)
    return tab[1] == 0
end

function BagTest:testNavigateToPokeball()
    savestate.load(BagTest.SAVE_STATE_PATH)
    return Bag:navigateToItem(Bag.Pocket.BALLS, Items.POKE_BALL)
end

function BagTest:testNavigateToItem()
    savestate.load(BagTest.SAVE_STATE_PATH)
    return Bag:navigateToItem(Bag.Pocket.ITEMS, Items.ANTIDOTE)
end

function BagTest:testUseBestBall()
    savestate.load(TestStates.ALL_BALLS)
    return Bag:useBestBall()
end

function BagTest:testUseFishingRod()
    savestate.load(TestStates.PRE_FISHING)
    Bag:openPack()
    return Bag:useItem(Bag.Pocket.KEY_ITEMS, Items.OLD_ROD)
end

function BagTest:testHasPokeballs()
    states = {TestStates.BAG_TEST,
              TestStates.POST_CATCH_TEST,
              TestStates.NO_BALLS,
              TestStates.OVERWORLD_MASTERBALL}
    values = {true,
             true,
             false,
             true}
    for i, state in ipairs(states)
    do
        savestate.load(state)
        if values[i] ~= Bag:hasPokeballs() then
            Log:error("Unexpected bag state: " .. state)
            return false
        end
    end
    return true
end

function BagTest:testIsOpen()
    states = {"States\\BagTests.State",
              "States\\PostCatchTests.State", 
              "States\\StartOfBattle.State"}
    values = {true,
              false,
              false}
    for i, state in ipairs(states)
    do
        savestate.load(state)
        if values[i] ~= Bag:isOpen() then
            Log:error("Unexpected bag state: " .. state)
            return false
        end
    end
    return true
end

Log.loggingLevel = LogLevels.INFO
GameSettings.initialize()
print("BagTest:testBagContainsBall()", BagTest:testBagContainsBall())
print("BagTest:testBagDoesntContainBall()", BagTest:testBagDoesntContainBall())
print("BagTest:testBagContainsItem()", BagTest:testBagContainsItem())
print("BagTest:testBagDoesntContainItem()", BagTest:testBagDoesntContainItem())
print("BagTest:testBagContainsKeyItem()", BagTest:testBagContainsKeyItem())
print("BagTest:testBagDoesntContainItem()", BagTest:testBagDoesntContainItem())
print("BagTest:testNavigateToPokeball()", BagTest:testNavigateToPokeball())
print("BagTest:testNavigateToItem()", BagTest:testNavigateToItem())
print("BagTest:testIsOpen()", BagTest:testIsOpen())
print("BagTest:testUseBestBall()", BagTest:testUseBestBall())
print("BagTest:testUseFishingRod()", BagTest:testUseFishingRod())