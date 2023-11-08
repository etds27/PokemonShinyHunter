require "Common"
require "GameSettings"

StartMenuFactory = {}

function StartMenuFactory:loadModel()
    Common:resetRequires({"GSCStartMenu"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCStartMenu")
    end
    return {}
end