require "Bag"
require "Battle"
require "BotModes"
require "Box"
require "Breeding"
require "ButtonSequences"
require "Collection"
require "Common"
require "Fishing"
require "GameSettings"
require "Headbutt"
require "Input"
require "Log"
require "Memory"
require "Pokemon"
require "PokemonData"
require "PokemonSocket"
require "Positioning"
require "PostCatch"
require "StaticEncounters"
require "Text"
require "Trainer"

Bot = {
    mode = BotModes.WILD_GRASS,
    SEARCH_SPIN_MAXIMUM = 100,
    FISH_MAXIMUM = 50,
    POKEMON_SEARCH_MAX = 100,
    botId = "NONE0000"
}

function Bot:run() 
    local savestatePath = "StaticEncounter.State"
    local i = 1
    savestate.save(savestatePath)

    while true
    do
        print(i)
        savestate.load(savestatePath)
        for i=1,10 do emu.frameadvance() end
        savestate.save(savestatePath)
        for i=1,10 do emu.frameadvance() end
        i = i + 1
    end


    Bot:initializeBot()
    if Common:contains({BotModes.WILD_GRASS, 
                        BotModes.FISHING,
                        BotModes.HEADBUTT}, Bot.mode) then
        Bot:runModeWildPokemon()
    elseif Common:contains(
        {BotModes.STARTER,
         BotModes.SHUCKLE_GSC,
         BotModes.EEVEE_GSC}, 
        Bot.mode) then
        Bot:runModeStaticEncounter(Bot.mode)
    elseif Bot.mode == BotModes.EGG then
        Bot:runModeHatchEggs()
    end
end

function Bot:runModeWildPokemon()
    local encounters = 1
    while not Box:isCurrentBoxFull()
    do
        if Bot.mode == BotModes.WILD_GRASS then
            Bot:searchForWildPokemon()
        elseif Bot.mode == BotModes.FISHING then
            Bot:fishForWildPokemon()
        elseif Bot.mode == BotModes.HEADBUTT then
            Bot:headbuttForWildPokemon()
        end
        Battle:waitForBattleMenu(300)

        local wildPokemon = Pokemon:new(Pokemon.PokemonType.WILD, GameSettings.wildpokemon)
        Log:info(tostring(encounters) .." is shiny: " .. tostring(wildPokemon.isShiny))
        Bot:reportEncounter(wildPokemon)

        Bot:handleWildPokemon(wildPokemon)

        encounters = encounters + 1
    end
    Log:info("Current box is full")
end

function Bot:runModeStaticEncounter(staticEncounter)
    --[[
        Assumes that we are standing in front of a pokemon that is given to player and not caught
    ]]
    staticEncounterSave = Bot.BOT_STATE_PATH .. "StaticEncounter1.State"
    savestate.save(staticEncounterSave)
    local newPokemonSlot = Party:numOfPokemonInParty() + 1
    if newPokemonSlot == Party.maxPokemon + 1 then 
        Log:error("Already at max pokemon") 
        return 
    end
    resets = 1
    while true
    do
        Log:info("Reset number: " .. tostring(resets))
        Common:waitFrames(40)
        savestate.load(Bot.BOT_STATE_PATH .. "StaticEncounter" .. tostring(resets) .. ".State")
        Log:debug("Bot:runModeStaticEncounter loaded static encounter state")
        -- Need to advance the game one frame each reset so that 
        -- the random seed can update and Pokemon values will be 
        -- different
        Common:waitFrames(1)
        Log:debug("Bot:runModeStaticEncounter saved new static encounter state")
        savestate.save(Bot.BOT_STATE_PATH .. "StaticEncounter" .. tostring(resets + 1) .. ".State")
        Log:debug("Bot:runModeStaticEncounter running static encounter")
        StaticEncounters[staticEncounter]()
        Party:navigateToPokemon(newPokemonSlot)
        pokemon = Party:getPokemonAtIndex(newPokemonSlot)
        pokemon.caught = true
        Bot:reportEncounter(pokemon)
        Log:debug("Bot:runModeStaticEncounter logged encounter for " .. staticEncounter)
        if pokemon.isShiny then
            break
        end
        resets = resets + 1
    end

    Log:info("Found shiny pokemon after: " .. tostring(resets) .. " resets")
end

function Bot:runModeStaticWildEncounter(staticEncounter)
    --[[
        Assumes that we are standing in front of a pokemon that needs to be caught
    ]]
    local staticEncounterSave = Bot.BOT_STATE_PATH .. "StaticEncounter.State"
    savestate.save(staticEncounterSave)
    local resets = 1
    while true
    do
        Log:info("Reset number: " .. tostring(resets))
        savestate.load(staticEncounterSave)
        -- Need to advance the game one frame each reset so that 
        -- the random seed can update and Pokemon values will be 
        -- different
        emu.frameadvance()
        savestate.save(staticEncounterSave)
        CustomSequences:starterEncounter()
        local wildPokemon = Pokemon:new(Pokemon.PokemonType.WILD, GameSettings.wildpokemon)
        Log:info(tostring(resets) .." is shiny: " .. tostring(Pokemon:isShiny(wildPokemon)))
        
        Bot:handleWildPokemon(wildPokemon)
        Bot:reportEncounter(wildPokemon)

        if pokemon.isShiny then
            break
        end
        resets = resets + 1
    end

    Log:info("Found shiny pokemon after: " .. tostring(resets) .. " resets")
end    

function Bot:runModeHatchEggs()
    --[[
        Egg Cycle completion process:
        - Take step to reset Egg Cycle Counter
        - Progress through hatching animations
        - Move to reset point
        - Release non shiny hatches
        - Deposit shiny hatches
        - Pick up new egg if applicable
    ]]
    local eggSlots = Party:getEggMask()
    local previousEggSlots = Party:getEggMask()
    local hatchedEggs = {}
    -- Contiains the pokemon indices and desired actions to take with that pokemon at the PC
    local pcActionList = {}

    if Bag:getSelectedItem() ~= Items.BICYCLE then
        Bag:openPack()
        KeyPocket:selectItem(Items.BICYCLE)
        Bag:closePack()
    end

    while true
    do
        Log:debug("runModeHatchEggs: cycle init")
        -- Get back on bike for next egg cycle
        if Memory:readFromTable(Positioning.Bicycle) == Positioning.Bicycle.INACTIVE then
            if Bag:getSelectedItem() == Items.BICYCLE then
                Input:pressButtons{buttonKeys={Buttons.SELECT}, duration=Duration.PRESS, waitFrames=60}
            else
                Bag:openPack()
                Bag:useItem(Bag.Pocket.KEY_ITEMS, Items.BICYCLE)
                Common:waitFrames(60)
            end
        end

        -- This was set before when ghost cycles would happen
        -- Not sure if it is still needed
        Common:waitFrames(1)
        -- Walk until a potential breeding event
        Breeding:completeEggCycle()

        -- Determine what eggs were hatched after the egg cycle
        if not Positioning:inOverworld() then
            -- About 30 frames to update the hatched pokemon after movement is disabled
            Common:waitFrames(30)
            eggSlots = Party:getEggMask()
            hatchedEggs = Breeding:determineHatchedPokemon(previousEggSlots, eggSlots)
            for i, index in ipairs(hatchedEggs) do
                Breeding:hatchEgg()
                local hatchedPokemon = Pokemon:new(Pokemon.PokemonType.TRAINER, Party:getPokemonAddress(index), Memory.WRAM)
                Log:info("Hatched pokemon " .. tostring(hatchedPokemon.species))
                hatchedPokemon.caught = true
                Bot:reportEncounter(hatchedPokemon)
                if hatchedPokemon.isShiny then
                    table.insert(pcActionList, {index = index, action = BoxUI.Action.DEPOSIT})
                else
                    table.insert(pcActionList, {index = index, action = BoxUI.Action.RELEASE})
                end
            end
            previousEggSlots = Party:getEggMask()
        end

        -- If something hatched, and we have a new egg to pick up and the party is full, then deposit
        if Common:tableLength(pcActionList) > 0 and Breeding:eggReadyForPickup() and Party:numOfPokemonInParty() == Party.maxPokemon then
            if not Breeding:walkToResetPoint() then return false end
            if not Breeding:walkToPCFromReset() then return false end
            -- Perform PC Actions
            if not BoxUI:performDepositMenuActions(pcActionList) then return false end
            pcActionList = {}
            if not Breeding:walkToResetPointFromPC() then return false end
            previousEggSlots = Party:getEggMask()
        end

        -- Determine if room in party
        if Breeding:eggReadyForPickup() and Party:numOfPokemonInParty() < Party.maxPokemon then 
            if not Breeding:walkToDayCareManFromReset() then return false end
            -- Pick up new eggs
            if not Breeding:pickUpEggs() then return false end
            if not Breeding:walkToResetFromDayCareMan() then return false end
            previousEggSlots = Party:getEggMask()
        end
    end
end

function Bot:fishForWildPokemon() -- Does not work if we cant escape battle
    local isRodSelected = Common:contains(Rods, Bag:getSelectedItem())
    local i = 0
    while i < Bot.FISH_MAXIMUM
    do
        Log:debug("Starting fishing loop")
        if isRodSelected then
            -- Fishing status updates in memory at around 24 frames
            Input:pressButtons{buttonKeys={Buttons.SELECT}, duration=Duration.PRESS, waitFrames=30}
        else
            Bag:openPack()
            Bag:useItem(Bag.Pocket.KEY_ITEMS, Items.OLD_ROD)
        end
        if Fishing:fish() then
            Log:debug("Hooked a fish!")
            break
        end

        -- Wait to return to overworld after not hooking a fish
        Log:debug("Waiting to return to overworld after fishing")
        if not Positioning:waitForOverworld(600) then
            Log:error("Did not return to overworld after not catching fish")
            return false
        end
        
        i = i + 1
    end
end

function Bot:searchForWildPokemon() 
    local i = 0
    while Positioning:inOverworld() and i < Bot.SEARCH_SPIN_MAXIMUM
    do
        local direction = Positioning:getDirection()
        -- If we are facing north, spin in a circle starting from the south
        -- If we are facing not north, spin in a circle starting from the north
        Log:debug("Searching for pokemon " .. i .. " Dir: " .. direction)
        if direction == Positioning.Direction.NORTH then
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

function Bot:headbuttForWildPokemon()
    local i = 0
    while Positioning:inOverworld() and i < Bot.POKEMON_SEARCH_MAX
    do
        if Headbutt:headbuttTree() then
            break
        end
        i = i + 1
    end

    if i == Bot.POKEMON_SEARCH_MAX then
        Log:warning("Unable to find pokemon after " .. Bot.SEARCH_SPIN_MAXIMUM .. " spins")
        Bot:waitForHuman()
    end
end

function Bot:handleWildPokemon(pokemon)
    local ret = 0
    local i = 0
    local isNeeded = Collection:isShinyPokemonNeeded(pokemon.species)
    Log:debug("Bot:handleWildPokemon: isNeeded " .. tostring(isNeeded))
    if pokemon.isShiny and isNeeded then
        while BallPocket:hasPokeballs() and i < 10
        do
            Battle:openPack()
            Bag:useBestBall()
            ret = Battle:getCatchStatus()
            if ret == 1 then -- SHINY WAS CAUGHT!
                PostCatch:continueUntilOverworld()
                break
            end
            i = i + 1
        end 

        if ret == 1 then
            pokemon.caught = true
            Log:info("You caught the shiny pokemon!")
        else
            pokemon.caught = false
            Log:info("You did not catch the shiny pokemon")
        end
        Bot:handleShiny(pokemonTable)
        -- Bot:waitForHuman() 
    else
        pokemon.caught = false
        Battle:runFromPokemon()
    end

    return pokemon
end

function Bot:reportEncounter(pokemonTable)
    PokemonSocket:logEncounter(pokemonTable)
end

function Bot:handleShiny(pokemonTable)
    --[[
        Responsible for handling whatever needs to be done after catching a shiny
    ]]
    Log:debug("Caught: " .. tostring(pokemonTable.caught))
    local timestamp = os.date("%Y%m_T%H%M%S")
    local savestatePath = Bot.SAVESTATE_PATH  .. timestamp .."_shiny_save" .. ".State"
    Log:debug("Bot:handleShiny: savestatePath: " .. savestatePath)
    savestate.save(savestatePath)
    Log:debug("Bot:handleShiny: saved game")

    pokemon = Collection:getAllShinyPokemon()
    PokemonSocket:logCollection(pokemon)
end

function Bot:initializeBot()
    --[[
        Needs to be ran when the game has started and has named the character
    ]]
    Bot.botId = Bot:getBotId()
    Bot.BOT_STATE_PATH = os.getenv("PSH_ROOT") .. "\\BotStates\\" .. Bot.botId .. "\\"
    Bot.SAVESTATE_PATH = Bot.BOT_STATE_PATH .. "ShinyStates\\"
    os.execute("mkdir " .. Bot.BOT_STATE_PATH)
    os.execute("mkdir " .. Bot.SAVESTATE_PATH)

    pokemon = Collection:getAllShinyPokemon()
    PokemonSocket:logCollection(pokemon)
end

function Bot:getBotId()
    return Trainer:getName() .. tostring(Trainer:getTrainerID())
end

function Bot:waitForHuman() 
    while true
    do
        emu.yield()
    end
end
