BotModes = {
    WILD_POKEMON = 1,
    STARTER = 2,
}

Bot = {
    mode = BotModes.STARTER,
    SEARCH_SPIN_MAXIMUM = 100,
}

function Bot:run() 
    if Bot.mode == BotModes.WILD_POKEMON then
        Bot:runModeWildPokemon()
    elseif Bot.mode == BotModes.STARTER then
        Bot:runModeStarterPokemon()
    end
end

function Bot:runModeWildPokemon()
    while true
    do
        Bot:searchForWildPokemon()
        wildPokemon = PokemonMemory:getPokemonTable(MemoryPokemonType.WILD, GameSettings.wildpokemon)

        Log:info("Is shiny: " .. tostring(PokemonMemory:isShiny(wildPokemon)))
        if wildPokemon.isShiny then
            ret = 0
            i = 0
            while BallPocket:hasPokeballs() and i < 10
            do
            Battle:openPack()
            Bag:useBestBall()
            ret = Battle:getCatchStatus()
            if ret == 1 then -- SHINY WAS CAUGHT!
                PostCatch:continueUntilOverworld()
                break
            else

            end
            i = i + 1
            end 

            if ret == 1 then
                Log:info("You caught the shiny pokemon!")
            else
                Log:info("You did not catch the shiny pokemon")
            end
            -- Bot:waitForHuman() 
        else
            Battle:runFromPokemon()
        end        
    end
end

function Bot:runModeStarterPokemon()
    --[[
        Assumes that we are standing in front of the starter pokeball that we want
    ]]
    starterSaveState = "BotStates\\StarterResetState.State"
    savestate.save(starterSaveState)
    resets = 1
    while true
    do
        Log:info("Reset number: " .. tostring(resets))
        savestate.load(starterSaveState)
        -- Need to advance the game one frame each reset so that 
        -- the random seed can update and Pokemon values will be 
        -- different
        emu.frameadvance()
        savestate.save(starterSaveState)
        CustomSequences:starterEncounter()
        starter = PokemonMemory:getPokemonTable(MemoryPokemonType.TRAINER, GameSettings.partypokemon[1])
        
        if starter.isShiny then
            break
        end
        resets = resets + 1
    end

    Log:info("Found shiny starter after: " .. tostring(resets) .. " resets")
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
    while true
    do
        emu.yield()
    end
end