require "BreedingFactory"
require "Common"
require "Log"
require "Memory"
require "Input"
require "Positioning"

Breeding = {}

function Breeding:completeEggCycle()
    --[[
        Walk the remaining steps needed to complete an egg cycle

        This must be ran while in the path between the reset and turnaround points. 
        The trainer will complete the egg cycle at any arbitrary point in the movement cycle.
        There is no logic to complete the egg cycle at a certain position

        Returns: true, when the cycle has been completed
    ]]
    local direction = false
    local eggSteps = 0
    local remainingSteps = 0
    local newPos = {x = 0, y = 0}
    local hasMoved = false
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
            print(newX, newY, Positioning:getPosition())
            Log:error("Unable to move to adjusted point")
            break
        end

        totalSteps = totalSteps + tab.steps
        direction = not direction
    end

    return false
end

function Breeding:determineHatchedPokemon(previousEggSlots, newEggSlots)
    --[[
        Determine which eggs have hatched between two party egg snapshots

        Returns: List of indices of the pokemon that hatched
            i.e {2, 5, 6}
    ]]
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

function Breeding:hatchEgg(pressLimit)
    --[[
        Complete the animation for egg hatching and skip nicknaming

        Returns: true if the player is back in the overworld after inputs
    ]]
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

function Breeding:calculateAdjustedMovementPoint(remainingSteps, endPoint)
    --[[
        Calculate the destination point given the desired destination point and
        the maximum number of steps available to take

        Returns: Position table of adjust destination point
            {x: y:}
    ]]
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

function Breeding:eggReadyForPickup()
    --[[
        Determine if the Day Care man has an egg ready to be picked up
    ]]
    return Memory:readFromTable(Breeding.EggAvailable) == Breeding.EggAvailable.EGG_READY
end


function Breeding:pickUpEggs(pressLimit)
    --[[
        Interacts with the Day Care person and accepts the egg

        Returns: true if an egg is no longer available to be picked up
    ]]
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
function Breeding:walkToResetPoint()
    --[[
        Walk from wherever the user is in the defined pacing path to the reset point

        Returns: true if the player ends at the reset point
    --]]
    return Positioning:moveToPosition(Breeding.MovementResetPoint)
end

function Breeding:walkToPCFromReset()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the pacing reset point to the Day Care PC
    ]]
end

function Breeding:walkToResetPointFromPC()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the Day Care PC to the pacing reset point
    ]]
end

function Breeding:walkToDayCareManFromReset()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the pacing reset point to the daycare man holding a new egg
    ]]
end

function Breeding:walkToResetFromDayCareMan()
    --[[
        ABSTRACT FUNCTION. Define per game as this path will change
        Walk from the daycare man holding a new egg to the pacing reset point
    ]]
end

-- Abstract tables
local Model = {}
Model.EggCycleCounter = {}
Model.MovementResetPoint = {}
Model.MovementTurnAroundPoint = {}
Model.EggAvailable = {}
local Model = BreedingFactory:loadModel()

Breeding = Common:tableMerge(Breeding, Model)

Log.loggingLevel = LogLevels.INFO
-- Breeding:hatchEgg()
