-- The purpose of this object is to provide functinoality for getting
-- all pokemon obtained so far and comparing to the requirements

require "Box"
require "Common"
require "Log"
require "Memory"
require "Party"
require "Pokemon"

Collection = {}

function Collection:getAllPokemon()
    local allPokemon = Box:getAllPokemonInPC()
    local partyPokemon = Party:getAllPokemonInParty()
    Common:tableMerge(allPokemon, partyPokemon)
    return allPokemon
end

function Collection:getAllShinyPokemon()
    --[[
        Get all of the shiny pokemon owned by the player

        Return: A table of shiny pokemon
            - {<species>: <num_caught>}
    ]]
    local shinyPokemon = {}

    for i, pokemon in pairs(Collection:getAllPokemon())
    do
        if pokemon.isShiny then
            table.insert(shinyPokemon, pokemon)
        end
    end
    return shinyPokemon
end

function Collection:isNewShinyPokemon(species, pokemon)
    --[[
        Determine if the pokemon found is a new shiny
    ]]

    if pokemon == nil then
        pokemon = Collection:getAllShinyPokemon()
    end

    for i, currentPokemon in ipairs(pokemon)
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
    return Collection:requiredShiniesRemaining(species, pokemonData) > 0
end

function Collection:requiredShiniesRemaining(species, pokemonData)
    --[[
        Determine the number of shinies needed for the evolutionary line
    ]]
    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end
    local reqCount = PokemonData:getPokemonByNumber(species).required
    local numOfShinies = Collection:numberOfShiniesCaught(species, pokemonData)
    return reqCount - numOfShinies    
end

function Collection:numberOfShiniesCaught(species, pokemonData)
    --[[
        Determine the number of shinies needed for the evolutionary line
    ]]
    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end

    PokemonData:getPokemonByNumber(species)
    local currentCount = 0

    for i, currentPokemon in ipairs(pokemonData)
    do
        if currentPokemon.species == species and currentPokemon.isShiny then
            currentCount = currentCount + 1
        end
    end
    return currentCount
end

-- Log.loggingLevel = LogLevels.INFO
-- print(Collection:getAllPokemon())
-- print(Collection:getAllShinyPokemon())
-- print(Collection:requiredShiniesRemaining(158))
-- print(Collection:isShinyPokemonNeeded(159))