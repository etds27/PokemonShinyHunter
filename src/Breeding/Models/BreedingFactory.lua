BreedingFactory = {}

function BreedingFactory:loadModel()
    Common:resetRequires({"GSCBreeding"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBreeding")
    end
    return {}
end