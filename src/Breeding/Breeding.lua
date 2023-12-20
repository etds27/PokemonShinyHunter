require "Common"
require "Factory"
require "Input"
require "Log"
require "Memory"
require "Positioning"

---@type FactoryMap
local factoryMap = {
    GSBreeding = GameGroups.GOLD_SILVER,
    CrystalBreeding = {Games.CRYSTAL}
}

Breeding = {}

---Walk the remaining steps needed to complete an egg cycle
---
---This must be ran while in the path between the reset and turnaround points. 
---The trainer will complete the egg cycle at any arbitrary point in the movement cycle.
---There is no logic to complete the egg cycle at a certain position
---
---@return boolean true when the cycle has been completed
function Breeding:completeEggCycle()
    local direction = false
    local eggSteps = 0
    local remainingSteps = 0
    local newPos = {x = 0, y = 0}
    local totalSteps = 0

    Log:debug("Breeding:completeEggCycle - init")
    while Positioning:inOverworld()
    do
        remainingSteps = 0
        eggSteps = Memory:readFromTable(Breeding.EggCycleCounter)
        Log:debug("Breeding:completeEggCycle - eggSteps: " .. tostring(eggSteps))
        Log:debug("Breeding:completeEggCycle - totalSteps: " .. tostring(totalSteps))
        Log:debug("Breeding:completeEggCycle - remainingSteps" .. tostring(remainingSteps))

        if eggSteps == Breeding.EggCycleCounter.RESET and totalSteps > 0 then
            Log:debug("Breeding:completeEggCycle - cycle reset found")
            return true
        end

        if eggSteps >= Breeding.EggCycleCounter.RESET then
            remainingSteps = 0xFF - eggSteps
            eggSteps = 0
        end

        remainingSteps = remainingSteps + Breeding.EggCycleCounter.RESET - eggSteps

        -- This only works for straight paths
        if direction then
            newPos = Breeding:calculateAdjustedMovementPoint(remainingSteps, Breeding.MovementTurnAroundPoint)
        else
            newPos = Breeding:calculateAdjustedMovementPoint(remainingSteps, Breeding.MovementResetPoint)
        end

        Log:debug("Adjusted egg point: " .. Common:coordinateToString(newPos))
        local tab = Positioning:moveToPoint(newPos.x, newPos.y, 100, false)
        if not tab.ret then
            Log:error("Unable to move to adjusted point")
            break
        end

        totalSteps = totalSteps + tab.steps
        direction = not direction
    end

    return false
end

---Determine which eggs have hatched between two party egg snapshots
---@param previousEggSlots table Table representing the egg status at each position in the party
---@param newEggSlots table Table representing the egg status at each position in the party
---@return table indices Tables of indices of the pokemon that hatched
---         {2, 5, 6}
function Breeding:determineHatchedPokemon(previousEggSlots, newEggSlots)
    Log:debug("Breeding:determineHatchedPokemon - init")
    local t = {}
    for i, eggStatus in ipairs(previousEggSlots)
    do
        if eggStatus ~= newEggSlots[i] then
            Log:debug("Breeding:determineHatchedPokemon - hatched pokemon at index " .. tostring(i))
            table.insert(t, i)
        end
    end
    return t
end

---Complete the animation for egg hatching and skip nicknaming
---@param pressLimit integer? Maximum number of button presses
---@return boolean true if the player is back in the overworld after inputs
function Breeding:hatchEgg(pressLimit)
    Log:debug("Breeding:hatchEgg - init")
    if pressLimit == nil then pressLimit = 200 end
    local i = 0
    while not Positioning:inOverworld() and i < pressLimit
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=14, waitFrames=2}
        i = i + 1
    end

    return Positioning:inOverworld()
end

---Calculate the destination point given the desired destination point and
---the maximum number of steps available to take
---@param remainingSteps integer Maximum number of steps to take
---@param endPoint Position Position to move to
---@return Coordinate position Table of adjusted destination point
function Breeding:calculateAdjustedMovementPoint(remainingSteps, endPoint)
    local newX = endPoint.x
    local newY = endPoint.y
    local pos = Positioning:getPosition()
    local adjustedX = 0
    local adjustedY = 0

    Log:debug("Breeding:calculateAdjustedMovementPoint - init")

    if endPoint.direction == Positioning.Direction.NORTH then
        adjustedY = math.max(pos.y - remainingSteps, newY)
        adjustedX = newX
    elseif endPoint.direction == Positioning.Direction.SOUTH then
        adjustedY = math.min(pos.y + remainingSteps, newY)
        adjustedX = newX
    elseif endPoint.direction == Positioning.Direction.EAST then
        adjustedX = math.min(pos.x + remainingSteps, newX)
        adjustedY = newY
    elseif endPoint.direction == Positioning.Direction.WEST then
        adjustedX = math.max(pos.x - remainingSteps, newX)
        adjustedY = newY
    end
    
    Log:debug("Breeding:calculateAdjustedMovementPoint - adjustedPos: " .. Common:coordinateToString{x = adjustedX, y = adjustedY})
    return {x = adjustedX, y = adjustedY}
end

---Determine if the Day Care man has an egg ready to be picked up
---@return boolean true if the egg is ready
function Breeding:eggReadyForPickup()
    return Memory:readFromTable(Breeding.EggAvailable) == Breeding.EggAvailable.EGG_READY
end

---Interact with the Day Care person and accepts the egg
---@param pressLimit integer? Maximum number of presses to take to complete interaction
---@return boolean true if an egg is no longer available to be picked up
function Breeding:pickUpEggs(pressLimit)
    if pressLimit == nil then
        pressLimit = 100
    end
    Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    local i = 0
    while Memory:readFromTable(Positioning.MovementEnabled) == Positioning.MovementEnabled.MOVEMENT_DISABLED and i < pressLimit
    do
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
        i = i + 1
    end

    -- Wait for old man to go back into house
    Common:waitFrames(300)
    return Memory:readFromTable(Breeding.EggAvailable) == Breeding.EggAvailable.EGG_NOT_READY
end

-- WALKING COMMANDS
---Walk from wherever the user is in the defined pacing path to the reset point
---@return MovementReturn true if the player ends at the reset point
function Breeding:walkToResetPoint()
    return Positioning:moveToPosition(Breeding.MovementResetPoint)
end

---@return boolean true If trainer moves to correct position
function Breeding:walkToPCFromReset()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the pacing reset point to the Day Care PC
    ]]
    return false
end

---@return boolean true If trainer moves to correct position
function Breeding:walkToResetPointFromPC()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the Day Care PC to the pacing reset point
    ]]
    return false
end

---@return boolean true If trainer moves to correct position
function Breeding:walkToDayCareManFromReset()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the pacing reset point to the daycare man holding a new egg
    ]]
    return false
end

---@return boolean true If trainer moves to correct position
function Breeding:walkToResetFromDayCareMan()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the daycare man holding a new egg to the pacing reset point
    ]]
    return false
end

local Model = {}
Model.EggCycleCounter = {}
Model.MovementResetPoint = {}
Model.MovementTurnAroundPoint = {}
Model.EggAvailable = {}
Model = Factory:loadModel(factoryMap)

Breeding = Common:tableMerge(Breeding, Model)