require "Common"
require "GameSettings"

StaticEncountersFactory = {}

function StaticEncountersFactory:loadModel()
    Common:resetRequires({"GSCStaticEncounters"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("GSCStaticEncounters")
    end
    return {}
end
