require "Common"
require "GameSettings"

MainMenuFactory = {}

function MainMenuFactory:loadModel()
    Common:resetRequires({"GSCMainMenu"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCMainMenu")
    end
    return {}
end