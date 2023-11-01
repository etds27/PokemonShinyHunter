BagFactory = {}

function BagFactory:loadModel()
    Common:resetRequires({"GSCBag"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("GSCBag")
    end
    return {}
end
