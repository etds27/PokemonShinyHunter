require "Common"
require "GameSettings"

PokegearFactory = {}

function PokegearFactory:loadModel()
    Common:resetRequires({"GSCPokegear"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require ("src.Pokegear.Models.GSCPokegear")
    end
    return {}
end
