BagFactory = {}

function BagFactory:loadModel()
    Common:resetRequires({"GSCBag"})
    if Games.CRYSTAL == GameSettings.game then
        return require ("CrystalBag")
    end
    if Common:contains(GameGroups.GOLD_SILVER, GameSettings.game) then
        return require ("GSBag")
    end
    return {}
end
