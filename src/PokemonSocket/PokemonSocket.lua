local json = require "json"

PokemonSocket = {
    host = "127.0.0.1",
    port = 57373,
    timeout = 1000
}
local url = comm.httpGetPostUrl()

---@enum EventType
EventType = {
    ENCOUNTER = "encounter",
    TEAM = "team",
    COLLECTION = "collection",
    GAME = "game"
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
    local time = Trainer:getPlayTime()

    -- Add meta data to the package before sending over
    local payload = {botId = Bot.botId,
                     playTime = time,
                     timestamp = os.time(),
                     eventType = eventType,
                     content = tab}

    local jsonString = json.encode(payload)
    -- Data delimiter
    -- comm.socketServerSend(jsonString .. "|||")
    Log:debug("Sending HTTP request: " .. Bot.botId .. " " .. url .. "/bot_data_receive")
    comm.httpPost(url .. "/bot_data_receive", jsonString)
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

function PokemonSocket:logGameStats()
    Log:debug("PokemonSocket:logGameStats: init")
    local tab = {
        playTime = Trainer:getPlayTime(),
        money = Trainer:getTrainerMoney(),
        id = Trainer:getTrainerID(),
        name = Trainer:getName(),
        map = Positioning:getMap(),
        position = Positioning:getPosition(),
        gameTime = ""
    }
    PokemonSocket:sendTable(tab, EventType.GAME)
    Log:debug("PokemonSocket:logGameStats: complete")
end
