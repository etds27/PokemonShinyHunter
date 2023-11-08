require "StartMenu"

StartMenuTest = {}

function StartMenuTest:testOpen()
    savestate.load(TestStates.EEVEE)
    return StartMenu:open()
end

function StartMenuTest:testSelectPokedex()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.POKEDEX)
end

function StartMenuTest:testSelectPokemon()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.POKEMON)
end

function StartMenuTest:testSelectPack()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.PACK)
end

function StartMenuTest:testSelectPokegear()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.POKEGEAR)
end

function StartMenuTest:testSelectTrainer()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.TRAINER)
end

function StartMenuTest:testSelectSave()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.SAVE)
end

function StartMenuTest:testSelectOption()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.OPTION)
end

function StartMenuTest:testSelectExit()
    savestate.load(TestStates.MENU_OPEN)
    return StartMenu:selectOption(StartMenu.EXIT)
end

print("StartMenuTest:testOpen()", StartMenuTest:testOpen())
print("StartMenuTest:testSelectPokedex()", StartMenuTest:testSelectPokedex())
print("StartMenuTest:testSelectPokemon()", StartMenuTest:testSelectPokemon())
print("StartMenuTest:testSelectPack()", StartMenuTest:testSelectPack())
print("StartMenuTest:testSelectPokegear()", StartMenuTest:testSelectPokegear())
print("StartMenuTest:testSelectTrainer()", StartMenuTest:testSelectTrainer())
print("StartMenuTest:testSelectSave()", StartMenuTest:testSelectSave())
print("StartMenuTest:testSelectOption()", StartMenuTest:testSelectOption())
print("StartMenuTest:testSelectExit()", StartMenuTest:testSelectExit())
