PartyTest = {}

function PartyTest:testNumPokemonInParty()
    savestate.load(TestStates.POKEMON_PARTY)
    return Party:numOfPokemonInParty() == 5
end

function PartyTest:testGetPokemonAtIndex()
    savestate.load(TestStates.POKEMON_PARTY)
    local tab = Party:getPokemonAtIndex(5)
    return tab.species == "155" and tab.isShiny
end

function PartyTest:testGetAllPokemonInParty()
    savestate.load(TestStates.POKEMON_PARTY)
    local tab = Party:getAllPokemonInParty()
    local species = {"161", "165", "10", "19", "155"}

    for i, pokemonTable in ipairs(tab)
    do
        if pokemonTable.species ~= species[i] then
            return false
        end
    end
    return true
end

function PartyTest:testNavigateToPokemon()
    savestate.load(TestStates.SHUCKLE_PARTY_TEST)
    return Party:navigateToPokemon(6)
end

print("PartyTest:testNumPokemonInParty()", PartyTest:testNumPokemonInParty())
print("PartyTest:testGetPokemonAtIndex()", PartyTest:testGetPokemonAtIndex())
print("PartyTest:testGetAllPokemonInParty()", PartyTest:testGetAllPokemonInParty())
print("PartyTest:testNavigateToPokemon()", PartyTest:testNavigateToPokemon())