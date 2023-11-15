BattleFactory = {}

function BattleFactory:loadModel()
    Common:resetRequires({"GSCBattle"})
    if Games.CRYSTAL == GameSettings.game then
        return require("CrystalBattle")
    end
    if Common:contains(GameGroups.GOLD_SILVER, GameSettings.game) then
        return require("GSBattle")
    end
    return {}
end
