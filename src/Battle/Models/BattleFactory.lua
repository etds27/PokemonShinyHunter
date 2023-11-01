BattleFactory = {}

function BattleFactory:loadModel()
    Common:resetRequires({"GSCBattle"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBattle")
    end
    return {}
end
