PokedexTest = {}

function PokedexTest:testPokemonNavigate()
    local pokemonNums = {163, 200, 244}
    for i, num in ipairs(pokemonNums)
    do
        savestate.load(TestStates.POKEDEX)
        if not Pokedex:navigateToPokemon(num) then
            return false
        end
    end
    return true
end

print("PokedexTest:testPokemonNavigate()", PokedexTest:testPokemonNavigate())
