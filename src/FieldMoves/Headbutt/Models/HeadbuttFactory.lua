require "Common"

HeadbuttFactory = {}

function HeadbuttFactory:loadModel()
    Common:resetRequires({"GSCHeadbutt"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("GSCHeadbutt")
    end
    return {}
end
