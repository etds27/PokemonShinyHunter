-- The purpose of this object is to provide functinoality for getting
-- all pokemon obtained so far and comparing to the requirements

require "Box"
require "Common"
require "Log"
require "Memory"
require "Party"
require "Pokemon"
require "PokemonData"

Collection = {}

function Collection:getAllPokemon()
    local allPokemon = Box:getAllPokemonInPC()
    local partyPokemon = Party:getAllPokemonInParty()
    for _, pokemon in ipairs(partyPokemon) 
    do
        table.insert(allPokemon, pokemon)
    end
    return allPokemon
end


---Get all of the shiny pokemon owned by the player
---@return table shinyPokemon A table of shiny pokemon
---     {<species>: <num_caught>}
function Collection:getAllShinyPokemon()
    local shinyPokemon = {}

    for _, pokemon in pairs(Collection:getAllPokemon())
    do
        if pokemon.isShiny and not pokemon:isEgg() then
            table.insert(shinyPokemon, pokemon)
        end
    end
    return shinyPokemon
end

---Determine if the pokemon found is a new shiny
---@param species string A string of the pokemon's ID
---@param pokemonData table A table of pokemon
---@return boolean true If the shiny pokemon has not been seen
function Collection:isNewShinyPokemon(species, pokemonData)
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

---Determine if we already have the needed amount of pokemon to complete the evolutionary line
---@param species string A string of the pokemon's ID
---@param pokemonData table A table of pokemon
---@return boolean true If the shiny pokemon is needed
function Collection:isShinyPokemonNeeded(species, pokemonData)
    return Collection:requiredShiniesRemaining(species, pokemonData) > 0
end

---Determine the number of shinies needed for the evolutionary line
---@param species string A string of the pokemon's ID
---@param pokemonData table A table of pokemon
---@return integer numRemaining The number of remaining shinies required to complete evolutionary line
function Collection:requiredShiniesRemaining(species, pokemonData)
    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end
    local reqCount = PokemonData:getPokemonByNumber(species).required

    local numOfShinies = Collection:numberOfShiniesCaught(species, pokemonData)
    return reqCount - numOfShinies
end

---Determine the number of shinies needed for the evolutionary line
---@param species string A string of the pokemon's ID
---@param pokemonData table A table of pokemon
---@return integer The number of shinies caught in the evolutionary line
function Collection:numberOfShiniesCaught(species, pokemonData)
    if pokemonData == nil then
        pokemonData = Collection:getAllShinyPokemon()
    end

    local currentPokemonData = PokemonData:getPokemonByNumber(species)

    local futurePokemonSpecies = Common:shallowcopy(currentPokemonData.evolution.post)
    local previousPokemonSpecies = Common:shallowcopy(currentPokemonData.evolution.pre)
    local evolutionSpecies = {species}

     -- Determine all of the pokemon ahead of it in the evolutionary line
     if futurePokemonSpecies ~= nil then
        for i, futurePokemon in ipairs(futurePokemonSpecies)
        do
            table.insert(evolutionSpecies, futurePokemon)
            local currentPokemonData = PokemonData:getPokemonByNumber(futurePokemon)
            if currentPokemonData.evolution.post ~= nil then
                for i, futureFuturePokemon in ipairs(currentPokemonData.evolution.post)
                do
                    if not Common:contains(evolutionSpecies, futureFuturePokemon) then
                        table.insert(evolutionSpecies, futureFuturePokemon)
                    end
                end
            end
        end
    end

    -- Determine all of the pokemon behind of it in the evolutionary line
    if previousPokemonSpecies ~= nil then
        for i, pastPokemon in ipairs(previousPokemonSpecies)
        do
            table.insert(evolutionSpecies, pastPokemon)
            local currentPokemonData = PokemonData:getPokemonByNumber(pastPokemon)
            if currentPokemonData.evolution.pre ~= nil then
                for i, pastPastPokemon in ipairs(currentPokemonData.evolution.pre)
                do
                    if not Common:contains(evolutionSpecies, pastPastPokemon) then
                        table.insert(evolutionSpecies, pastPastPokemon)
                    end
                end
            end
        end
    end

    local currentCount = 0

    for i, currentPokemon in ipairs(pokemonData)
    do
        if Common:contains(evolutionSpecies, currentPokemon.species) and currentPokemon.isShiny and not currentPokemon:isEgg() then
            currentCount = currentCount + 1
        end
    end
    return currentCount
end
