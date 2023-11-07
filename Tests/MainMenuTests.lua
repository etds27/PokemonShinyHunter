require "MainMenu"

MainMenuTest = {}

function MainMenuTest:testOpen()
    savestate.load(TestStates.EEVEE)
    return MainMenu:open()
end

function MainMenuTest:testSelectPokedex()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.POKEDEX)
end

function MainMenuTest:testSelectPokemon()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.POKEMON)
end

function MainMenuTest:testSelectPack()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.PACK)
end

function MainMenuTest:testSelectPokegear()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.POKEGEAR)
end

function MainMenuTest:testSelectTrainer()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.TRAINER)
end

function MainMenuTest:testSelectSave()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.SAVE)
end

function MainMenuTest:testSelectOption()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.OPTION)
end

function MainMenuTest:testSelectExit()
    savestate.load(TestStates.MENU_OPEN)
    return MainMenu:selectOption(MainMenu.EXIT)
end

print("MainMenuTest:testOpen()", MainMenuTest:testOpen())
print("MainMenuTest:testSelectPokedex()", MainMenuTest:testSelectPokedex())
print("MainMenuTest:testSelectPokemon()", MainMenuTest:testSelectPokemon())
print("MainMenuTest:testSelectPack()", MainMenuTest:testSelectPack())
print("MainMenuTest:testSelectPokegear()", MainMenuTest:testSelectPokegear())
print("MainMenuTest:testSelectTrainer()", MainMenuTest:testSelectTrainer())
print("MainMenuTest:testSelectSave()", MainMenuTest:testSelectSave())
print("MainMenuTest:testSelectOption()", MainMenuTest:testSelectOption())
print("MainMenuTest:testSelectExit()", MainMenuTest:testSelectExit())
