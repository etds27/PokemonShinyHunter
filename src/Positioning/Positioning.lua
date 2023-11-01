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
    return Common:waitForState(Positioning.MovementEnabled, Positioning.MovementEnabled.MOVEMENT_ENABLED, frameLimit)
end

function Positioning:inOverworld() 
    return Memory:readFromTable(Battle.PokemonTurnCounter) == Positioning.MovementEnabled.MOVEMENT_ENABLED
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
    t.map = Memory:readFromTable(Positioning.Map)
    return t
end

function Positioning:faceDirection(direction)
    --[[
        Turn to face the specified direction
    ]]
    if Memory:readFromTable(Positioning.Direction) == direction then
        return true
    end
    local button = ""
    if direction == Positioning.Direction.NORTH then
        button = Buttons.UP
    elseif direction == Positioning.Direction.EAST then
        button = Buttons.RIGHT
    elseif direction == Positioning.Direction.SOUTH then
        button = Buttons.DOWN
    elseif direction == Positioning.Direction.WEST then
        button = Buttons.LEFT
    end

    -- If the person is moving, then they should be able to turn without end lag
    local waitFrames = 0
    if Memory:readFromTable(Positioning.Motion) == Positioning.Motion.NO_MOTION then
        waitFrames = 20
    else
        Log:debug("Currently in motion for turn")
        waitFrames = 0
    end

    Input:pressButtons{buttonKeys={button}, duration=5, waitFrames=waitFrames}
    return Memory:readFromTable(Positioning.Direction) == direction
end

function Positioning:moveToPosition(newPos, maxAttempts)
    --[[
        Move the character to a specified position

        Arguments:
            - newPos: Position table with the following structure
                {x: y: ...}
            - maxAttempts: Number of turns the trainer will attempt to make when pathing
    ]]
    return Positioning:moveToPoint(newPos.x, newPos.y)
end

function Positioning:moveToPoint(newX, newY, maxAttempts)
    --[[
        Very dumb walk from one position to another method.
    ]]

    if maxAttempts == nil then
        maxAttempts = 100
    end
    -- true = N/S, false = E/W
    local axis = true 
    local currentX = 0
    local currentY = 0
    local direction = 0
    local position = {x = 0, y = 0}
    local adjustedSteps = 0

    local totalAttempts = 0
    while totalAttempts < maxAttempts
    do

        position = Positioning:getPosition()
        currentX = position.x
        currentY = position.y

        -- Break if destination has been reached
        if currentX == newX and currentY == newY then
            Log:info("Navigated to x: " .. tostring(newX) .. " y: " .. tostring(newY))
            return true
        end

        -- North South movement
        if currentY == newY then
            axis = false
        end
        if currentX == newX then
            axis = true
        end
      
        if axis then
            if currentY > newY then
                direction = Positioning.Direction.NORTH
            elseif currentY < newY then
                direction = Positioning.Direction.SOUTH
            end
            -- Move at a maximum, the total delta in the y direction
            adjustedSteps = math.abs(newY - currentY)
        else
            if currentX < newX then
                direction = Positioning.Direction.EAST
            elseif currentX > newX then
                direction = Positioning.Direction.WEST
            end
            -- Move at a maximum, the total delta in the x direction
            adjustedSteps = math.abs(newX - currentX)
        end

        local ret = Positioning:moveStepsInDirection(adjustedSteps, direction)
        if ret == 2 then
            return false
        end
        axis = not axis
        totalAttempts = totalAttempts + 1
    end
end

function Positioning:moveStepsInDirection(maxSteps, direction) 
    local position = Positioning:getPosition()
    local startX = position.x
    local startY = position.y
    local startingMap = position.map

    local currentX = 0
    local currentY = 0
    local map = 0

    local buttonDuration = 0
    local waitFrames = 0
    local localWait = 0
    
    -- If this changes, then we collided
    local initialCollision = Memory:readFromTable(Positioning.Collision)
    local button = 0
    if direction == Positioning.Direction.NORTH then
        Log:debug("Moving N")
        button = Buttons.UP
    elseif direction == Positioning.Direction.SOUTH then
        Log:debug("Moving S")
        button = Buttons.DOWN
    elseif direction == Positioning.Direction.EAST then
        Log:debug("Moving E")
        button = Buttons.RIGHT
    elseif direction == Positioning.Direction.WEST then
        Log:debug("Moving W")
        button = Buttons.LEFT
    end
    Positioning:faceDirection(direction)


    -- Update the input durations for bike or not
    if Memory:readFromTable(Positioning.Bicycle) == Positioning.Bicycle.ACTIVE then
        buttonDuration = 3
        waitFrames = 0
        localWait = 5
    else
        buttonDuration = 6
        waitFrames = 0
        localWait = 10
    end

    local i = 0
    while true
    do
        position = Positioning:getPosition()
        currentX = position.x
        currentY = position.y
        map = position.map

        -- Terminate if we are in a new map
        if startingMap ~= map then
            Log:debug("Left current map during navigation")
            return 2
        end

        Input:pressButtons{buttonKeys={button}, duration=buttonDuration, waitFrames=waitFrames}
        -- Check if we are colliding with anything after the first half press
        if Memory:readFromTable(Positioning.Collision) ~= initialCollision then
            Log:debug("Detected collision")
            return 1
        end

        -- Check if we are 1 tile away from the goal
        if math.abs(startX - currentX) + math.abs(startY - currentY) >= maxSteps - 1 then
            break
        end

        -- We are not near our goal so continue to hold button for direction
        Input:pressButtons{buttonKeys={button}, duration=localWait, waitFrames=waitFrames}
    end        

    -- Perform partial press to continue movement into goal square
    Common:waitFrames(localWait)

    return 0
end

-- Positioning:moveStepsInDirection(19, Positioning.Direction.SOUTH) 