PartyTest = {}

function PartyTest:testNumPokemonInParty()
    savestate.load(TestStates.POKEMON_PARTY)
    return Party:numOfPokemonInParty() == 5
end

function PartyTest:testGetPokemonAtIndex()
    savestate.load(TestStates.POKEMON_PARTY)
    tab = Party:getPokemonAtIndex(5)
    return tab.species == 155 and tab.isShiny
end

function PartyTest:testGetAllPokemonInParty()
    savestate.load(TestStates.POKEMON_PARTY)
    tab = Party:getAllPokemonInParty()
    species = {161, 165, 010, 019, 155}
    for i, pokemonTable in ipairs(tab)
    do
        if pokemonTable.species ~= species[i] then
            return false
        end
    end
    return true
end

print("PartyTest:testNumPokemonInParty()", PartyTest:testNumPokemonInParty())
print("PartyTest:testGetPokemonAtIndex()", PartyTest:testGetPokemonAtIndex())
print("PartyTest:testGetAllPokemonInParty()", PartyTest:testGetAllPokemonInParty())