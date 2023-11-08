require "Common"
require "Log"
require "MainMenu"
require "Memory"
require "Menu"
require "PartyFactory"
require "Pokemon"

Party = {
    numEggs = 0
}
local Model = PartyFactory:loadModel()

-- Merge model into class
Party = Common:tableMerge(Party, Model)


function Party:numOfPokemonInParty()
    return Memory:readFromTable(Party)
end

function Party:getPokemonAddress(index)
    --[[
        Get the starting address of a pokemon in the trainers party.
        Index starts at 1
        Returns: addr
    ]]
    return Party.addr + 8 + (index - 1) * Party.pokemonSize
end

function Party:getPokemonAtIndex(index)
    --[[
        Return the pokemonTable for a pokemon in the party at a specific index
    ]]
    local addr = Party:getPokemonAddress(index)
    return Pokemon:new(Pokemon.PokemonType.TRAINER, addr)
end

function Party:getAllPokemonInParty()
    --[[
        Get a table of all of the pokemon tables in your party
    ]]
    local tab = {}
    for i = 1, Party:numOfPokemonInParty()
    do
        table.insert(tab, Party:getPokemonAtIndex(i))
    end
    return tab
end

function Party:getAllEggsInParty()
    --[[
        Get a table containing all of the eggs in the party
    ]]
    local tab = {}
    for i, pokemon in pairs(Party:getAllPokemonInParty())
    do
        if pokemon:isEgg() then
            table.insert(tab, pokemon)
        end
    end
    return tab
end

function Party:getEggMask()
    local tab = {false, false, false, false, false, false}
    for i, pokemon in pairs(Party:getAllPokemonInParty())
    do
        if pokemon:isEgg() then
            tab[i] = true
        end
    end
    return tab
end

function Party:getNumberOfEggsInParty()
    return Common:tableLength(Party:getAllEggsInParty())
end 

function Party:navigateToPokemon(num)    
    MainMenu:open()
    MainMenu:navigateToOption(MainMenu.POKEMON)
    Input:pressButtons{buttonKeys={Buttons.A},
                    duration=Duration.PRESS,
                    waitFrames=60}
    Menu:navigateMenuFromTable(MenuCursor, num)

    Input:repeatedlyPressButton{buttonKeys={Buttons.A},
                                duration=Duration.PRESS,
                                waitFrames=25,
                                iterations=3}
end
