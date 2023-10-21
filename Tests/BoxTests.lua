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
    box = Box:getCurrentBox()
    pokemon = box[1]
    return pokemon.species == 167
end

function BoxTest:testGetBox()
    savestate.load(TestStates.BOX_1_6)
    box = Box:getBox(1)
    pokemon = box[2]
    return pokemon.species == 163
end

function BoxUITest:testChangeBox()
    savestate.load(TestStates.BOXUI_OVERWORLD)
    return BoxUI:changeBox(14)
end

function BoxUITest:testChangeBoxExisting()
    savestate.load(TestStates.BOXUI_OVERWORLD)
    return BoxUI:changeBox(3)
end



print("BoxTest:testCurrentBoxNumber()", BoxTest:testCurrentBoxNumber())
print("BoxTest:testGetCurrentBox()", BoxTest:testGetCurrentBox())
print("BoxTest:testGetBox()", BoxTest:testGetBox())
print("BoxTest:testGetAllPokemonInPC()", BoxTest:testGetAllPokemonInPC())
print("BoxUITest:testChangeBox()", BoxUITest:testChangeBox())
print("BoxUITest:testChangeBoxExisting()", BoxUITest:testChangeBoxExisting())