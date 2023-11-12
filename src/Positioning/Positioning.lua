require "Common"
require "Input"
require "Log"
require "Memory"
require "PositioningFactory"

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

---@class Coordinate
---@field x integer X coordinate
---@field y integer Y coordinate

---@class Position
---@field x integer X coordinate
---@field y integer Y coordinate
---@field direction integer Direction
---@field map integer Map ID code

---@class MovementReturn
---@field ret boolean
---@field steps integer

---Calculate the Manhattan distance between 2 points
---This is useful to determine the number of steps travelled
---between two points assuming an optimal path
---@param pos1 Position|Coordinate Starting point
---@param pos2 Position|Coordinate End point
---@return integer distance The Manhattan distance between the two points
function Positioning:manhattanDistance(pos1, pos2)
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

---Advance frames until the player is in the overworld
---This does not guarantee that movement is available 
---@param frameLimit integer Maximum number of frames to wait
---@return boolean true if trainer is in the overworld
function Positioning:waitForOverworld(frameLimit)
    return Common:waitForState(Positioning.MovementEnabled, Positioning.MovementEnabled.MOVEMENT_ENABLED, frameLimit)
end

---Check if trainer is in the overworld
---@return boolean true if trainer is in the overworld
function Positioning:inOverworld()
    return Memory:readFromTable(Positioning.MovementEnabled) == Positioning.MovementEnabled.MOVEMENT_ENABLED
end

---Get trainer's current X position
---@return integer x
function Positioning:getX()
    return Memory:readFromTable(Positioning.PositionX)
end

---Get trainer's current Y position
---@return integer y
function Positioning:getY()
    return Memory:readFromTable(Positioning.PositionY)
end

---Get trainer's current direction
---@return integer direction
function Positioning:getDirection()
    return Memory:readFromTable(Positioning.Direction)
end


---Get trainer's current map ID
---@return integer mapID
function Positioning:getMap()
    return Memory:readFromTable(Positioning.Map)
end

---Get all position data for the player
---@return Position position Current position of the player
function Positioning:getPosition()
    return {
        x = Positioning:getX(),
        y = Positioning:getY(),
        direction = Positioning:getDirection(),
        map = Positioning:getMap()
    }
end

---Turn to face the specified direction
---@param direction integer Direction to face
---@return boolean true if the trainer faces the correct direction
function Positioning:faceDirection(direction)
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
        Log:debug("Waiting frames after turn")
        waitFrames = 20
    else
        Log:debug("Currently in motion for turn")
        waitFrames = 0
    end

    Input:pressButtons{buttonKeys={button}, duration=5, waitFrames=waitFrames}
    return Memory:readFromTable(Positioning.Direction) == direction
end

---Move the character to a specified position
---@param newPos Coordinate|Position
---@param maxSteps integer Number of turns the trainer will attempt to make when pathing
---@param releaseEnd boolean Bool to have frames at the end of the movement without any input
---@return MovementReturn
function Positioning:moveToPosition(newPos, maxSteps, releaseEnd)
    return Positioning:moveToPoint(newPos.x, newPos.y, maxSteps, releaseEnd)
end

---Move the character to a specified position
---
---Very dumb walk from one position to another method.
---@param newX integer X coordinate to move to
---@param newY integer Y coordinate to move to
---@param maxSteps integer Number of turns the trainer will attempt to make when pathing
---@param releaseEnd boolean Bool to have frames at the end of the movement without any input
---@return MovementReturn
function Positioning:moveToPoint(newX, newY, maxSteps, releaseEnd)
    if maxSteps == nil then
        maxSteps = 100
    end
    -- true = N/S, false = E/W
    local axis = true
    local currentX = 0
    local currentY = 0
    local direction = 0
    local position = {x = 0, y = 0}
    local adjustedSteps = 0
    local totalSteps = 0

    while totalSteps < maxSteps and Positioning:inOverworld()
    do
        position = Positioning:getPosition()
        currentX = position.x
        currentY = position.y

        -- Break if destination has been reached
        if currentX == newX and currentY == newY then
            Log:info("Navigated to x: " .. tostring(newX) .. " y: " .. tostring(newY))
            return {ret = true, steps = totalSteps}
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

        local t = Positioning:moveStepsInDirection(adjustedSteps, direction, releaseEnd)
        if t.ret == 2 then
            return {ret = false, steps = totalSteps}
        end
        totalSteps = totalSteps + math.max(t.steps, 1)

        axis = not axis
    end
    return {ret = false, steps = totalSteps}
end

---Move N steps in a particular direction
---
--- will attempt to take a maximum number of steps in a specified direction
---If a collision is detected, it will immediately return
---If the trainer leaves the current map area, it will immediately return
---
---@param maxSteps integer Maximum number of steps to take before returning
---@param direction integer Direction to walk towards
---@param releaseEnd boolean [true] Bool to have frames at the end of the movement without any input
---@return MovementReturn
function Positioning:moveStepsInDirection(maxSteps, direction, releaseEnd)
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

    -- If this changes, then we collided. This value isn't constant for some reason
    local initialCollision = Memory:readFromTable(Positioning.Collision)
    local button = ""
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
        buttonDuration = Positioning.Bicycle.initialMoveFrames
        localWait = Positioning.Bicycle.postMoveFrames
    else
        buttonDuration = Positioning.Walking.initialMoveFrames
        localWait = Positioning.Walking.postMoveFrames
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
            return {ret = 2, steps = -1}
        end

        Input:pressButtons{buttonKeys={button}, duration=buttonDuration, waitFrames=waitFrames}
        -- Check if we are colliding with anything after the first half press
        if Memory:readFromTable(Positioning.Collision) ~= initialCollision then
            Log:debug("Detected collision")
            return {ret = 1, steps = Positioning:manhattanDistance({x = startX, y = startY}, position)}
        end

        -- Check if we are 1 tile away from the goal
        -- If we are one tile away, then the partial press we are doing will move
        -- the trainer onto the correct tile
        if math.abs(startX - currentX) + math.abs(startY - currentY) >= maxSteps - 1 then
            Log:debug("Within 1 step of destination, breaking")
            break
        end

        -- We are not near our goal so continue to hold button for direction
        Input:pressButtons{buttonKeys={button}, duration=localWait, waitFrames=waitFrames}
    end

    -- Release the second portion of the press to stop moving
    if releaseEnd == nil or releaseEnd then
        Log:debug("Releasing positioning inputs")
        Common:waitFrames(localWait)
    end


    return {ret = 0, steps = Positioning:manhattanDistance({x = startX, y = startY}, Positioning:getPosition())}
end
