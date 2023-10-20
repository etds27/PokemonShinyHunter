
Bot = {
    SEARCH_SPIN_MAXIMUM = 100
}

function Bot:run() 
    while true
    do
        Bot:searchForWildPokemon()
        wildPokemon = PokemonMemory:getWildPokemonTable(GameSettings.wildpokemon)

        if not PokemonMemory:isShiny(wildPokemon) then
            Battle:openPack()
            Bag:useBestBall()
            Bot:waitForHuman() 
        else
            Battle:runFromPokemon()
        end        
    end
end


function Bot:searchForWildPokemon() 
    i = 0
    while Positioning:inOverworld() and i < Bot.SEARCH_SPIN_MAXIMUM
    do
        -- If we are facing north, spin in a circle starting from the south
        -- If we are facing not north, spin in a circle starting from the north
        -- print(Memory:read(Direction.addr, Direction.size))
        direction = Memory:readFromTable(Direction)
        Log:debug("Searching for pokemon " .. i .. " Dir: " .. direction)
        if direction == Direction.NORTH then
            Input:performButtonSequence(ButtonSequences.SEARCH_ALL_DIR_S)
        else
            Input:performButtonSequence(ButtonSequences.SEARCH_ALL_DIR_N)
        end

        i = i + 1
    end

    if i == Bot.SEARCH_SPIN_MAXIMUM then
        Log:warning("Unable to find pokemon after " .. Bot.SEARCH_SPIN_MAXIMUM .. " spins")
        Bot:waitForHuman()
    end
end

function Bot:waitForHuman() 
    exit()
    while true
    do
        emu.yield()
    end
end