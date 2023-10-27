BattleFactory = {}

function BattleFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBattle")
    end
end
