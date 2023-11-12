json = require "json"

PokemonSocket = {
    host = "127.0.0.1",
    port = 57373,
    timeout = 1000
}


---@enum EventType
EventType = {
    ENCOUNTER = "encounter",
    TEAM = "team",
    COLLECTION = "collection",
}

---@class Payload
---@field botId string Bot ID of the current Bot
---@field playTime Time Total playtime of the bot
---@field timestamp number Current system timestamp
---@field eventType EventType Event type
---@field content table Table to send to server 

---Send table to server
---@param tab table Table to send to server
---@param eventType EventType What event was sent to the server 
---@return Payload payload Payload that was sent to the server
function PokemonSocket:sendTable(tab, eventType)
    local trainerId = Trainer:getTrainerID()
    local time = Trainer:getPlayTime()

    -- Add meta data to the package before sending over
    local payload = {botId = Bot.botId,
                     playTime = time,
                     timestamp = os.time(),
                     eventType = eventType,
                     content = tab}

    local jsonString = json.encode(payload)
    -- Data delimiter
    comm.socketServerSend(jsonString .. "|||")
    return payload
end

---Send encounter data to the server
---@param pokemonTable table Pokemon to send to server
function PokemonSocket:logEncounter(pokemonTable)
    PokemonSocket:sendTable(pokemonTable, EventType.ENCOUNTER)
end

---Send collection data to the server
---@param pokemonTable table A table containing the entire collection of pokemon
function PokemonSocket:logCollection(pokemonTable)
    Log:debug("PokemonSocket:logCollection: init")
    PokemonSocket:sendTable(pokemonTable, EventType.COLLECTION)
    Log:debug("PokemonSocket:logCollection: complete")
end
