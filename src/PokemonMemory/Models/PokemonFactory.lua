PokemonFactory = {}

function PokemonFactory:loadModel()
    Common:resetRequires({"GSCPokemon"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCPokemon")
    end
end