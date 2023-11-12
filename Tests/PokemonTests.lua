PokemonTest = {}

function Pokemon:testPartyPokemon()
    savestate.load(TestStates.POKEMON_TESTS)
    local pokemon = Party:getPokemonAtIndex(1)
    return pokemon.species == "155" and pokemon.movePp3 == 20 and pokemon.speedStat == 18
end

function Pokemon:testEnemyPokemon()
    savestate.load(TestStates.POKEMON_TESTS)
    local pokemon = Pokemon:new(Pokemon.PokemonType.WILD, GameSettings.wildpokemon, Memory.WRAM)
    return pokemon.species == "167" and pokemon.level == 4
end

function Pokemon:testBoxPokemon()
    savestate.load(TestStates.POKEMON_TESTS)
    local pokemon = Box:getBox(1)[1]
    return pokemon.species == "167" and pokemon.trainerId == 51032
end

print("Pokemon:testPartyPokemon()", Pokemon:testPartyPokemon())
print("Pokemon:testEnemyPokemon()", Pokemon:testEnemyPokemon())
print("Pokemon:testBoxPokemon()", Pokemon:testBoxPokemon())