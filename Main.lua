-- Memory = require "Memory"
-- require "GameSettings"

-- Test Game
-- print(Memory.read(0x134, 2)) -- == 0d20557
-- print(Memory.read(0x134, 4)) -- == 0d1347247939

-- mem = Memory.read(0x136, 4)
-- print(string.format("%x", mem))
-- print(mem == 0x5F435259)

-- Test Pokemon Cyndaquil (First Party)
--[[PokemonMemory = require "PokemonMemory" 
pokemonNo = Memory.read(PartyAddress[1], 1)
print(string.format("%x", PartyAddress[1]))
print(pokemonNo == 155)
print(PokemonNames[pokemonNo])
--]]
--[[
-- Test Game initialize
GameSettings.initialize()
-- pokemonNo = Memory.read(GameSettings.trainerpointer, 1)
-- print(pokemonNo)

-- Test Pokemon Data
-- print(GameSettings.partypokemon)
pokemon1 = getTrainerPokemonTable(GameSettings.partypokemon[1])
pokemon2 = getTrainerPokemonTable(GameSettings.enemypokemon[1])
enemyPokemon = getWildPokemonTable(GameSettings.wildpokemon)
print(pokemon1)
print(pokemon2) 
print(enemyPokemon)
--]]
GameSettings.initialize()
-- Battle:runFromPokemon()
-- enemyPokemon = PokemonMemory:getWildPokemonTable(GameSettings.wildpokemon)
-- print(enemyPokemon)
-- exit()
Bot:run()
-- pokemon1 = PokemonMemory:getTrainerPokemonTable(GameSettings.partypokemon[1])
-- print(pokemon1)
-- print(PokemonMemory:isShiny(pokemon1))