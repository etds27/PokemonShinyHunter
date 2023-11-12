require "Common"
require "Log"
require "StartMenu"
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


---Get the starting address of a pokemon in the trainers party.
---Index starts at 1
---@param index integer The position of the pokemon in the party
---@return address address The address of the pokemon in the party
function Party:getPokemonAddress(index)
    return Party.addr + 8 + (index - 1) * Party.pokemonSize
end

---Get the pokemonTable for a pokemon in the party at a specific index
---@param index integer The position of the pokemon in the party
---@return Pokemon pokemon The pokemon at the specified index
function Party:getPokemonAtIndex(index)
    local addr = Party:getPokemonAddress(index)
    return Pokemon:new(Pokemon.PokemonType.TRAINER, addr)
end

---Get a table of all of the pokemon tables in your party
---@return table table A table of `Pokemon` 
function Party:getAllPokemonInParty()
    local tab = {}
    for i = 1, Party:numOfPokemonInParty()
    do
        table.insert(tab, Party:getPokemonAtIndex(i))
    end
    return tab
end

---Get a table containing all of the eggs in the party
---@return table table A table of the egg pokemon in your party
function Party:getAllEggsInParty()
    local tab = {}
    for _, pokemon in pairs(Party:getAllPokemonInParty())
    do
        if pokemon:isEgg() then
            table.insert(tab, pokemon)
        end
    end
    return tab
end

---Get a table that specifies true or false for egg status of each slot in your party
---@return table
function Party:getEggMask()
    local tab = {}
    for i, pokemon in pairs(Party:getAllPokemonInParty())
    do
        if pokemon:isEgg() then
            table.insert(tab, true)
        else
            table.insert(tab, false)
        end
    end
    return tab
end

---Determine the current number of eggs in your party
---@return integer eggs Number of eggs in your party
function Party:getNumberOfEggsInParty()
    return Common:tableLength(Party:getAllEggsInParty())
end

---Open the party menu and move cursor to the specified pokemon
---@param num integer Index of the pokemon to navigate to within your party
function Party:navigateToPokemon(num)
    StartMenu:open()
    StartMenu:navigateToOption(StartMenu.POKEMON)
    Input:pressButtons{buttonKeys={Buttons.A},
                    duration=Duration.PRESS,
                    waitFrames=60}
    Menu:navigateMenuFromTable(Menu.Cursor, num)

    Input:repeatedlyPressButton{buttonKeys={Buttons.A},
                                duration=Duration.PRESS,
                                waitFrames=25,
                                iterations=3}
    Common:waitFrames(30)
end
