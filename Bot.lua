require "Bag"
require "Battle"
require "Box"
require "ButtonSequences"
require "Collection"
require "Common"
require "Fishing"
require "GameSettings"
require "Input"
require "Log"
require "PokemonMemory"
require "PokemonSocket"
require "Positioning"
require "PostCatch"

BotModes = {
    WILD_GRASS = 1,
    STARTER = 2,
    FISHING = 3,
}

Bot = {
    mode = BotModes.WILD_GRASS,
    SEARCH_SPIN_MAXIMUM = 100,
    FISH_MAXIMUM = 50,
}

function Bot:run() 
    Bot:initializeBot()
    if Common:contains({BotModes.WILD_GRASS, BotModes.FISHING}, Bot.mode) then
        Bot:runModeWildPokemon()
    elseif Bot.mode == BotModes.STARTER then
        Bot:runModeStarterPokemon()
    end
end

function Bot:runModeWildPokemon()
    encounters = 1
    while true
    do
        if Bot.mode == BotModes.WILD_GRASS then
            Bot:searchForWildPokemon()
        elseif Bot.mode == BotModes.FISHING then
            Bot:fishForWildPokemon()
        end
        wildPokemon = PokemonMemory:getPokemonTable(MemoryPokemonType.WILD, GameSettings.wildpokemon)

        Log:info(tostring(encounters) .." is shiny: " .. tostring(PokemonMemory:isShiny(wildPokemon)))
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

            encounters = 1

            if ret == 1 then
                wildPokemon.caught = true
                Log:info("You caught the shiny pokemon!")
            else
                wildPokemon.caught = false
                Log:info("You did not catch the shiny pokemon")
            end
            -- Bot:waitForHuman() 
        else
            wildPokemon.caught = false
            Battle:runFromPokemon()
        end
        Bot:handleEncounter(wildPokemon)
        encounters = encounters + 1
    end
end

function Bot:runModeStarterPokemon()
    --[[
        Assumes that we are standing in front of the starter pokeball that we want
    ]]
    starterSavestate = Bot.BOT_STATE_PATH .. "StarterResetState.State"
    savestate.save(starterSavestate)
    resets = 1
    while true
    do
        Log:info("Reset number: " .. tostring(resets))
        savestate.load(starterSavestate)
        -- Need to advance the game one frame each reset so that 
        -- the random seed can update and Pokemon values will be 
        -- different
        emu.frameadvance()
        savestate.save(starterSavestate)
        CustomSequences:starterEncounter()
        starter = PokemonMemory:getPokemonTable(MemoryPokemonType.TRAINER, GameSettings.partypokemon[1])
        starter.caught = true
        Bot:handleEncounter(starter)
        if starter.isShiny then
            break
        end
        resets = resets + 1
    end

    Log:info("Found shiny starter after: " .. tostring(resets) .. " resets")
end

function Bot:fishForWildPokemon() -- Does not work if we cant escape battle
    isRodSelected = Common:contains(Rods, Bag:getSelectedItem())
    i = 0
    while i < Bot.FISH_MAXIMUM
    do
        if isRodSelected then
            Input:pressButtons{buttonKeys={Buttons.SELECT}, duration=Duration.TAP, waitFrames=0}
        else
            Bag:openPack()
            Bag:useItem(BagPocket.KEY_ITEMS, Items.OLD_ROD)
        end
        if Fishing:fish() then
            break
        end
        i = i + 1
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
    -- Common:waitFrames(120)
end

function Bot:handleEncounter(pokemonTable)
    PokemonSocket:logEncounter(pokemonTable)
    if pokemonTable.isShiny then
        Bot:handleShiny(pokemonTable)
    end
end

function Bot:handleShiny(pokemonTable)
    --[[
        Responsible for handling whatever needs to be done after catching a shiny
    ]]
    if pokemonTable.caught then
        savestatePath = Bot.SAVESTATE_PATH .. "shiny_save_"  .. tostring(os.clock() .. ".State")
        savestate.save(savestatePath)

        pokemon = Collection:getAllShinyPokemon()
        PokemonSocket:logCollection(pokemon)
    end
end

function Bot:initializeBot()
    Bot.BOT_STATE_PATH = "BotStates\\" .. tostring(Trainer:getTrainerID()) .. "\\"
    Bot.SAVESTATE_PATH = Bot.BOT_STATE_PATH .. "ShinyStates\\"
    os.execute("mkdir " .. Bot.BOT_STATE_PATH)
    os.execute("mkdir " .. Bot.SAVESTATE_PATH)
end

function Bot:waitForHuman() 
    while true
    do
        emu.yield()
    end
end