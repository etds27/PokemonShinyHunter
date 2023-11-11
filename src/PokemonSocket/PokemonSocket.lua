json = require "json"

PokemonSocket = {
    host = "127.0.0.1",
    port = 57373,
    timeout = 1000
}

EventTypes = {
    ENCOUNTER = "encounter",
    TEAM = "team",
    COLLECTION = "collection",
}

function PokemonSocket:sendTable(tab, eventType)
    trainerId = Trainer:getTrainerID()
    time = Trainer:getPlayTime()

    -- Add meta data to the package before sending over
    payload = {botId = Bot.botId,
               playTime = time,
               timestamp = os.time(),
               eventType = eventType,
               content = tab}

    jsonString = json.encode(payload)
    -- Data delimiter
    comm.socketServerSend(jsonString .. "|||")
end

function PokemonSocket:logEncounter(pokemonTable)
    PokemonSocket:sendTable(pokemonTable, EventTypes.ENCOUNTER)
end

function PokemonSocket:logCollection(pokemonTable)
    Log:debug("PokemonSocket:logCollection: init")
    PokemonSocket:sendTable(pokemonTable, EventTypes.COLLECTION)
    Log:debug("PokemonSocket:logCollection: complete")
end

-- PokemonSocket:logEncounter({test = "TEST"})