FishingFactory = {}

function FishingFactory:loadModel()
    Common:resetRequires({"GSCFishing"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCFishing")
    end
    return {}
end