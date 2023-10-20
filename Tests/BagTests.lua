SAVE_STATE_PATH = "BagTests.State"

BagTest = {}

function BagTest:testBagContainsBall()
    savestate.load(SAVE_STATE_PATH)
    tab = BallPocket:containsItem(Items.POKE_BALL)
    return tab[1] == 1 and tab[2] == 1
end

function BagTest:testBagDoesntContainBall()
    savestate.load(SAVE_STATE_PATH)
    tab = BallPocket:containsItem(Items.GREAT_BALL)
    return tab[1] == 0 and tab[2] == 0
end

function BagTest:testBagContainsItem()
    savestate.load(SAVE_STATE_PATH)
    tab = ItemPocket:containsItem(Items.ANTIDOTE)
    return tab[1] == 2 and tab[2] == 1
end

function BagTest:testBagDoesntContainItem()
    savestate.load(SAVE_STATE_PATH)
    tab = ItemPocket:containsItem(Items.THUNDER_STONE)
    return tab[1] == 0 and tab[2] == 0
end
function BagTest:testNavigateToPokeball()
    savestate.load(SAVE_STATE_PATH)
    return Bag:navigateToItem(Items.POKE_BALL)
end

function BagTest:testNavigateToItem()
    savestate.load(SAVE_STATE_PATH)
    return Bag:navigateToItem(Items.ANTIDOTE)
end