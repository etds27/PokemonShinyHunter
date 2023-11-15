BattleFactory = {}

function BattleFactory:loadModel()
    local factoryMap = {
        CrystalBattle = {Games.CRYSTAL},
        GSBattle = GameGroups.GOLD_SILVER
    }
    for library, compatibleGames in pairs(factoryMap)
    do
        Common:resetRequires({library})

        if Common:contains(compatibleGames, GameSettings.game) then
            return require(library)
        end
    end
    return {}
end
