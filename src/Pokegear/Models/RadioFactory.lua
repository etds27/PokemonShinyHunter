require "Common"
require "GameSettings"

RadioFactory = {}

function RadioFactory:loadModel()
    Common:resetRequires({"GSCRadio"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("src.Pokegear.Models.GSCRadio")
    end
    return {}
end
