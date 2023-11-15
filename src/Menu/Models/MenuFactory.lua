MenuFactory = {}

function MenuFactory:loadModel()
    Common:resetRequires({"GSCMenu"})
    if Games.CRYSTAL == GameSettings.game then
        return require("CrystalMenu")
    end
    if Common:contains(GameGroups.GOLD_SILVER, GameSettings.game) then
        return require("GSMenu")
    end
    return {}
end