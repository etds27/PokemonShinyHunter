BoxTest = {}
BoxUITest = {}

function BoxTest:testCurrentBoxNumber()
    savestate.load(TestStates.BOX_4)
    return  Box:getCurrentBoxNumber() == 4
end

function BoxTest:testGetAllPokemonInPC()
    savestate.load(TestStates.BOX_1_6)
    return Common:tableLength(Box:getAllPokemonInPC()) == 3
end

function BoxTest:testGetCurrentBox()
    savestate.load(TestStates.BOX_1_6)
    local box = Box:getCurrentBox()
    local pokemon = box[1]
    return pokemon.species == "167"
end

function BoxTest:testGetBox()
    savestate.load(TestStates.BOX_1_6)
    local box = Box:getBox(1)
    local pokemon = box[2]
    return pokemon.species == "163"
end

function BoxUITest:testChangeBox()
    savestate.load(TestStates.BOXUI_OVERWORLD)
    return BoxUI:changeBox(14)
end

function BoxUITest:testChangeBoxExisting()
    savestate.load(TestStates.BOXUI_OVERWORLD)
    return BoxUI:changeBox(3)
end

function BoxUITest:testPerformDepositMenuActions()
    savestate.load(TestStates.POKEMON_DEPOSIT)
    local actionList = {
        {index = 3, action = BoxUI.Action.DEPOSIT},
        {index = 1, action = BoxUI.Action.RELEASE},
        {index = 5, action = BoxUI.Action.DEPOSIT},
        {index = 6, action = BoxUI.Action.DEPOSIT},
        {index = 4, action = BoxUI.Action.RELEASE},
    }
    return BoxUI:performDepositMenuActions(actionList)

end

print("BoxTest:testCurrentBoxNumber()", BoxTest:testCurrentBoxNumber())
print("BoxTest:testGetCurrentBox()", BoxTest:testGetCurrentBox())
print("BoxTest:testGetBox()", BoxTest:testGetBox())
print("BoxTest:testGetAllPokemonInPC()", BoxTest:testGetAllPokemonInPC())
print("BoxUITest:testChangeBox()", BoxUITest:testChangeBox())
print("BoxUITest:testChangeBoxExisting()", BoxUITest:testChangeBoxExisting())
print("BoxUITest:testPerformDepositMenuActions()",  BoxUITest:testPerformDepositMenuActions())