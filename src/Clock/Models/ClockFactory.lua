require "Common"

ClockFactory = {}

function ClockFactory:loadModel()
    Common:resetRequires({"GSCClock"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("GSCClock")
    end
    return {}
end
