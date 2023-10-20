--[[
    The purpose of this object is to read the current game state determined from pokemon_state_machine.py and provide that information on demand
]]
GameState = {
    gameStateMmapFile = "pokemon-bot-game-state",
    gameStateRequestMmapFile = "pokemon-bot-gsrequest",
    requestCounter = 0
}

json = require "json"
comm.mmfWrite(GameState.gameStateRequestMmapFile, string.rep("\x00", 1028))


function GameState:getCurrentGameState(args) 
    --[[
        Get the current game state per request.

        Returns: String of current game state
    ]]
    GameState.requestCounter = GameState.requestCounter + 1
    Log:debug("Sending game state request: " .. GameState.requestCounter)
    writeScreenshotToMmap()

    if args == nil then
        args = {}
    end

    if args.keys == nil then
        keys = {"all"}
    else
        keys = args.keys
    end

    if args.timeout == nil then
        timeout = 5
    else
        timeout = args.timeout
    end

    print(GameState.gameStateRequestMmapFile, json.encode({GameState.requestCounter, keys}))
    comm.mmfWrite(GameState.gameStateRequestMmapFile, 
                  json.encode({GameState.requestCounter, keys}) .. "\x00")

    startTime = os.clock()
    requestNumber = -1

    while requestNumber ~= GameState.requestCounter or os.clock() - startTime < timeout do
        local pcallResult, gameState= pcall(comm.mmfRead, GameState.gameStateMmapFile, 4096)
        if not pcallResult then
            Log.error("Unable to read gamestate from " .. GameState.gameStateMmapFile)
            Log.error("Perhaps pokemon_state_machine.py is not running?")
            return nil
        end
        -- print("Game State, " .. gameState)

        -- Find last character written to mmap
        endIndex = string.find(gameState, "]")
        -- Remove empty characters after the last character
        gameState = string.sub(gameState, 0, endIndex)

        -- print(gameState)
        -- Decode the json gameState
        gameState = json.decode(gameState)

        -- First element is the request number
        requestNumber = gameState[1]
        -- Second element is the game state
        gameState = gameState[1]
        Log:debug("GameState: " .. gameState)
    end
    print(os.clock () - startTime)

    return gameState
end



print(GameState:getCurrentGameState())
-- print(GameState:getCurrentGameState())