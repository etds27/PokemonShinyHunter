PositioningTest = {}

function PositioningTest:testFaceDirectionNoBike()
    savestate.load(TestStates.POSITIONING_NO_BIKE)
    for i, direction in pairs({Positioning.Direction.EAST, Positioning.Direction.SOUTH, Positioning.Direction.WEST, Positioning.Direction.NORTH})
    do
        if not Positioning:faceDirection(direction) then
            return false
        end
    end
    return true
end

function PositioningTest:testFaceDirectionBike()
    savestate.load(TestStates.POSITIONING_BIKE)
    for i, direction in pairs({Positioning.Direction.EAST, Positioning.Direction.SOUTH, Positioning.Direction.WEST, Positioning.Direction.NORTH})
    do
        if not Positioning:faceDirection(direction) then
            return false
        end
    end
    return true
end

function PositioningTest:testMoveStepsInDirectionNoBikeS()
    savestate.load(TestStates.POSITIONING_NO_BIKE)
    return Positioning:moveStepsInDirection(8, Positioning.Direction.SOUTH).steps == 8
end

function PositioningTest:testMoveStepsInDirectionBikeS()
    savestate.load(TestStates.POSITIONING_BIKE)
    return Positioning:moveStepsInDirection(8, Positioning.Direction.SOUTH).steps == 8
end

function PositioningTest:testMoveToPointNoBikeNW()
    savestate.load(TestStates.POSITIONING_NO_BIKE)
    return Positioning:moveToPoint(8, 0).ret
end

function PositioningTest:testMoveToPointBikeNW()
    savestate.load(TestStates.POSITIONING_BIKE)
    return Positioning:moveToPoint(8, 0).ret
end


function PositioningTest:testMoveToPointNoBikeSE()
    savestate.load(TestStates.POSITIONING_NO_BIKE)
    return Positioning:moveToPoint(16, 23).ret
end

function PositioningTest:testMoveToPointBikeSE()
    savestate.load(TestStates.POSITIONING_BIKE)
    return Positioning:moveToPoint(16, 23).ret
end


GameSettings.initialize()
Log.loggingLevel = LogLevels.DEBUG


print("PositioningTest:testFaceDirectionNoBike()", PositioningTest:testFaceDirectionNoBike())
print("PositioningTest:testFaceDirectionBike()", PositioningTest:testFaceDirectionBike())
print("testMoveStepsInDirectionNoBikeS", PositioningTest:testMoveStepsInDirectionNoBikeS())
print("testMoveStepsInDirectionBikeS", PositioningTest:testMoveStepsInDirectionBikeS())
print("PositioningTest:testMoveToPointNoBikeNW()", PositioningTest:testMoveToPointNoBikeNW())
print("PositioningTest:testMoveToPointBikeNW()", PositioningTest:testMoveToPointBikeNW())
print("PositioningTest:testMoveToPointNoBikeSE()", PositioningTest:testMoveToPointNoBikeSE())
print("PositioningTest:testMoveToPointBikeSE()", PositioningTest:testMoveToPointBikeSE())