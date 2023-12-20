local Model = {
    EggCycleCounter = {
        addr = 0xDC73,
        size = 1,
        memdomain = "WRAM",
        RESET = 128 -- Eggs only hatch on 
    },

    -- Part of the constant path to walk between
    MovementResetPoint = {
        x = 8,
        y = 15,
        map = Positioning.Map.ROUTE34,
        deltaX = 0,
        deltaY = 15,
        direction = Positioning.Direction.SOUTH -- Relative to other point
    },

    MovementTurnAroundPoint = {
        x = 8,
        y = 0,
        map = Positioning.Map.ROUTE34,
        deltaX = 0,
        deltaY = -15,
        direction = Positioning.Direction.NORTH -- Relative to other point
    },

    EggAvailable = {
        addr = 0xDEF5,
        size = 1,
        bit = 6,
        EGG_READY = 1,
        EGG_NOT_READY = 0,
    },

    PCPoint = {
        x = 7,
        y = 2
    }
}

function Model:walkToPCFromReset() 
    -- Move to right outside the day care house
    if not Positioning:moveToPoint(11, 15).ret then return false end
    -- Step into daycare house.
    Positioning:moveStepsInDirection(1, Positioning.Direction.EAST) 
    Common:waitFrames(60)
    -- Walk to front of PC
    if not Positioning:moveToPosition(Model.PCPoint).ret then return false end
    -- Face the PC
    -- if not Positioning:faceDirection(Positioning.Direction.NORTH) then return false end
    Positioning:faceDirection(Positioning.Direction.NORTH)
    Common:waitFrames(60)
    return true
end

function Model:walkToResetPointFromPC() 
    -- Move to door of Day Care room
    if not Positioning:moveToPoint(0, 6).ret then return false end
    -- Step out of daycare house. 
    Positioning:moveStepsInDirection(1, Positioning.Direction.WEST)
    -- Walk to reset point
    if not Positioning:moveToPosition(Model.MovementResetPoint).ret then return false end
    return true
end

function Model:walkToDayCareManFromReset() 
    -- Move to right outside the day care house
    if not Positioning:moveToPoint(11, 15).ret then return false end
    -- Step into daycare house.
    Positioning:moveStepsInDirection(1, Positioning.Direction.EAST)
    Common:waitFrames(60)
    -- Walk to doorway to yard
    if not Positioning:moveToPoint(2, 7).ret then return false end
    -- Step into the Day Care yard.
    Positioning:moveStepsInDirection(1, Positioning.Direction.SOUTH)
    Common:waitFrames(60)
    -- Face the Day Care man
    if not Positioning:moveToPoint(14, 16).ret then return false end
    if not Positioning:faceDirection(Positioning.Direction.EAST) then return false end
    return true
end

function Model:walkToResetFromDayCareMan() 
    -- Step into the Day Care house.
    if not Positioning:moveToPoint(13, 16).ret then return false end
    Positioning:moveStepsInDirection(1, Positioning.Direction.NORTH)
    -- Move to door of Day Care room
    if not Positioning:moveToPoint(0, 6).ret then return false end
    -- Step out of daycare house. 
    Positioning:moveStepsInDirection(1, Positioning.Direction.WEST)
    -- Walk to reset point
    if not Positioning:moveToPosition(Model.MovementResetPoint) then return false end
    return true
end

return Model