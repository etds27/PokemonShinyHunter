require "Common"

BoxFactory = {}
BoxUIFactory = {}

function BoxFactory:loadModel()
    local factoryMap = {
        CrystalBox = {Games.CRYSTAL},
        GSBox = GameGroups.GOLD_SILVER
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

function BoxUIFactory:loadModel()
    local factoryMap = {
        CrystalBoxUI = {Games.CRYSTAL},
        GSBoxUI = GameGroups.GOLD_SILVER
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