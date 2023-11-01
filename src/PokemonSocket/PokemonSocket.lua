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
    -- print(jsonString, package, eventType)
    -- Data delimiter
    comm.socketServerSend(jsonString .. "|||")
end

function PokemonSocket:logEncounter(pokemonTable)
    PokemonSocket:sendTable(pokemonTable, EventTypes.ENCOUNTER)
end

function PokemonSocket:logCollection(pokemonTable)
    PokemonSocket:sendTable(pokemonTable, EventTypes.COLLECTION)
end

-- PokemonSocket:logEncounter({test = "TEST"})