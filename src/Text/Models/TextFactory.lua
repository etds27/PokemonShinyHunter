TextFactory = {}

function TextFactory:loadModel()
    Common:resetRequires({"GSCText"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCText")
    end
    return {}
end
