PokedexFactory = {}

function PokedexFactory:loadModel()
    Common:resetRequires({"GSCPokedex"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCPokedex")
    end
    return {}
end
