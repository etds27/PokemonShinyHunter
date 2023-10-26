-- The purpose of this object is to provide functinoality for getting
-- all pokemon obtained so far and comparing to the requirements

require "Box"
require "Common"
require "Log"
require "Memory"
require "Party"
require "PokemonMemory"

Collection = {}

function Collection:getAllShinyPokemon()
    --[[
        Get all of the shiny pokemon owned by the player

        Return: A table of shiny pokemon
            - {<species>: <num_caught>}
    ]]
    boxPokemon = Box:getAllPokemonInPC()
    partyPokemon = Party:getAllPokemonInParty()
    speciesTable = {}

    for i, pokemonTable in ipairs(boxPokemon)
    do
        if pokemonTable.isShiny then
            table.insert(speciesTable, pokemonTable)
        end
    end

    for i, pokemonTable in ipairs(partyPokemon)
    do
        if pokemonTable.isShiny then
            table.insert(speciesTable, pokemonTable)
        end
    end
    return speciesTable
end

function Collection:isNewShinyPokemon(species, pokemonData)
    --[[
        Determine if the pokemon found is a new shiny
    ]]

    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end

    for i, currentPokemon in ipairs(pokemonData)
    do
        if currentPokemon.species == species and currentPokemon.isShiny then
            return false
        end
    end
    return true
end

function Collection:isShinyPokemonNeeded(species, pokemonData)
    --[[
        Determine if we already have the needed amount of pokemon to complete the evolutionary line
    ]]
    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end

    reqCount = PokemonReqs[species]
    currentCount = 0

    for i, currentPokemon in ipairs(pokemonData)
    do
        if currentPokemon.species == species and currentPokemon.isShiny then
            currentCount = currentCount + 1
        end
    end
    return currentCount < reqCount
end


-- print(Collection:getAllShinyPokemon())