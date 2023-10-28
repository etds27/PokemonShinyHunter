BoxFactory = {}
BoxUIFactory = {}

function BoxFactory:loadModel()
    Common:resetRequires({"GSCBox"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBox")
    end
    return {}
end

function BoxUIFactory:loadModel()
    Common:resetRequires({"GSCBoxUI"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCBoxUI")
    end
    return {}
end