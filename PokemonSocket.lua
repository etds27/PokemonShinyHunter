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

json = require "json"

function PokemonSocket:sendTable(tab, eventType)
    trainerId = Trainer:getTrainerID()
    time = Trainer:getPlayTime()

    -- Add meta data to the package before sending over
    package = {botId = trainerId,
               playTime = time,
               eventType = eventType,
               content = tab}

    jsonString = json.encode(package)
    -- print(jsonString, package, eventType)
    comm.socketServerSend(jsonString)
end

function PokemonSocket:logEncounter(pokemonTable)
    PokemonSocket:sendTable(pokemonTable, EventTypes.ENCOUNTER)
end


-- PokemonSocket:logEncounter({test = "TEST"})