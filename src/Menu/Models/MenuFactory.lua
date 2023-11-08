MenuFactory = {}

function MenuFactory:loadModel()
    Common:resetRequires({"GSCMenu"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCMenu")
    end
    return {}
end