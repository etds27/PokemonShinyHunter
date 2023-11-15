BagFactory = {}

function BagFactory:loadModel()
    local factoryMap = {
        CrystalBag = {Games.CRYSTAL},
        GSBag = GameGroups.GOLD_SILVER
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
