local json = require "json"
local open = io.open

local function readJson(filepath)
    local f = open(filepath, "rb")
    if not f then return {} end

    local content = f:read "*all"
    f:close()
    return json.decode(content)
end

PokemonData = {}
Common:tableMerge(PokemonData, readJson(os.getenv("PSH_ROOT") .. "\\GameData\\Pokemon\\" .. GameSettings.game.pokemonData))

function PokemonData:getPokemonByNumber(pokemonNumber)
	return PokemonData[tostring(pokemonNumber)]
end

function PokemonData:getPokemonByName(pokemonName)
	for pokemonNumber, currentName in ipairs(PokemonData)
	do
		if currentName == pokemonName then
			return PokemonData:getPokemonByNumber(pokemonNumber)
		end
	end
	return {}
end
