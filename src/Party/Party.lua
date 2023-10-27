require "Common"
require "Log"
require "Memory"
require "PokemonMemory"

Party = {}
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
    return PokemonMemory:getPokemonTable(MemoryPokemonType.TRAINER, addr)
end

function Party:getAllPokemonInParty()
    --[[
        Get a table of all of the pokemon tables in your party
    ]]
    tab = {}
    for i = 1, Party:numOfPokemonInParty()
    do
        table.insert(tab, Party:getPokemonAtIndex(i))
    end
    return tab
end