TextFactory = {}

function TextFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCText")
    end
end
