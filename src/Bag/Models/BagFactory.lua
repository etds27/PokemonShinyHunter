BagFactory = {}

function BagFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBag")
    end
end