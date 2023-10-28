require "Common"
require "Log"
require "Memory"
require "Input"

Positioning = {}

-- Abstract tables
local Model = {}
Model.Direction = {}
Model.PositionX = {}
Model.PositionY = {}
Model.Map = {}
local Model = PositioningFactory:loadModel()

-- Merge model into class
Positioning = Common:tableMerge(Positioning, Model)

function Positioning:waitForOverworld(frameLimit)
    --[[
        Advance frames until the player is in the overworld

        This does not guarantee that movement is available 
        Arguments:
            - frameLimit: Maximum number of frames to wait
    ]]
    return Common:waitForNotState(Battle.PokemonTurnCounter, 0, frameLimit)
end

function Positioning:inOverworld() 
    return Memory:readFromTable(Battle.PokemonTurnCounter) ~= 0
end

function Positioning:getPosition()
    --[[
        Get all position data for the player

        Returns: Table with position data
            {x: y: direction: map:}
    ]]
    t = {}
    t.x = Memory:readFromTable(Positioning.PositionX)
    t.y = Memory:readFromTable(Positioning.PositionY)
    t.direction = Memory:readFromTable(Positioning.Direction)
    t.map = Memorty:readFromTable(Positioning.Map)
    return t
end