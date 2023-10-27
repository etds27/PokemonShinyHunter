BoxFactory = {}

function BoxFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBox")
    end
end

function BoxUIFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBoxUI")
    end
end