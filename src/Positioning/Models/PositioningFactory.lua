PositioningFactory = {}

function PositioningFactory:loadModel()
    Common:resetRequires({"GSCPositioning"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCPositioning")
    end
end