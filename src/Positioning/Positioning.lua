require "Common"
require "Log"
require "Memory"
require "Input"

Positioning = {}

Direction = {
    addr = 0xD4DE,
    size = 1,
    NORTH = 4,
    EAST = 12,
    SOUTH = 0,
    WEST = 8,
}

PositionX = {
    addr = 0xDCB8,
    size = 1,
}

PositionY = {
    addr = 0xDCB7,
    size = 1,
}

Map = {
    addr = 0xDC86,
    size = 1,
    NewBarkTown = 6,
    Route29 = 62,
}

function Positioning:waitForOverworld(frameLimit)
    --[[
        Advance frames until the player is in the overworld

        This does not guarantee that movement is available 
        Arguments:
            - frameLimit: Maximum number of frames to wait
    ]]
    Common:waitForState(Battle.PokemonTurnCounter, 0, frameLimit)
end

function Positioning:inOverworld() 
    return Memory:readFromTable(Battle.PokemonTurnCounter) ~= 0
end