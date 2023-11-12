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

---Get the pokemon's data from its ID
---@param pokemonNumber string Pokemon's ID as a string
---@return unknown
function PokemonData:getPokemonByNumber(pokemonNumber)
	return PokemonData[pokemonNumber]
end


---Get the pokemon's data from its name
---@param pokemonName string Name of pokemon
---@return table pokemonData Game data of pokemon
function PokemonData:getPokemonByName(pokemonName)
	for pokemonNumber, currentName in pairs(PokemonData)
	do
		if currentName == pokemonName then
			return PokemonData:getPokemonByNumber(pokemonNumber)
		end
	end
	return {}
end
