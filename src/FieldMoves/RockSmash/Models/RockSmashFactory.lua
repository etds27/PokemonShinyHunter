require "Common"

RockSmashFactory = {}

function RockSmashFactory:loadModel()
    Common:resetRequires({"GSCRockSmash"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("GSCRockSmash")
    end
    return {}
end
