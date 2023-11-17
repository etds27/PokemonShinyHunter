CRYSTAL_NAME = "PM_CRYSTAL"
GOLD_NAME = "POKEMON_GLD"
SILVER_NAME = "POKEMON_SLV"

Games = {
	CRYSTAL = {name = CRYSTAL_NAME,
			   hex = {0x50, 0x4D, 0x5F, 0x43, 0x52, 0x59, 0x53, 0x54, 0x41, 0x4C}, -- PM_CRYSTAL
			   addr = 0x134,
			   size = 10,
			   memdomain = "ROM",
			   pokemonData = "pokemon_gen2.json",
			   routeEncounterData = "route_encounter_crystal.json"
			},
	GOLD = {name = GOLD_NAME,
			hex = {0x50, 0x4F, 0x4B, 0x45, 0x4D, 0x4F, 0x4E, 0x5F, 0x47, 0x4C, 0x44}, -- POKEMON_GLD
			addr = 0x134,
			size = 11,
			memdomain = "ROM",
			pokemonData = "pokemon_gen2.json",
			routeEncounterData = "route_encounter_gold.json"
			},
	SILVER = {name = SILVER_NAME,
			  hex = {0x50, 0x4F, 0x4B, 0x45, 0x4D, 0x4F, 0x4E, 0x5F, 0x53 , 0x4C, 0x56}, -- POKEMON_GLD
			  addr = 0x134,
			  size = 11,
			  memdomain = "ROM",
			  pokemonData = "pokemon_gen2.json",
			  routeEncounterData = "route_encounter_silver.json"
			},
}

-- Convenience groups to associate similar games
GameGroups = {
	GEN_2 = {Games.CRYSTAL, Games.GOLD, Games.SILVER},
	GOLD_SILVER = {Games.GOLD, Games.SILVER},
}

GameSettings = {
	game = 0,
	gamename = "",
	gamecolor = 0,
	mapbank = 0,
	mapid = 0,
	enemypokemon = {0, 0, 0, 0, 0, 0},
	version = 0,
	language = 0,
	trainerpointer = 0,
	partypokemon = {0, 0, 0, 0, 0, 0},
	posx = 0,
	posy = 0,
	wildpokemon = 0,
	roamerpokemonoffset = 0,
	menuCursor = 0,
	bagCursor = 0,
	frameCounter = 0
}

GameSettings.VERSIONS = {
    G = 1,
    S = 2,
    C = 3
}
GameSettings.LANGUAGES = {
	U = 1,
	J = 2,
	F = 3,
	S = 4,
	G = 5,
	I = 6
}

local function determineIfGame(gameTable)
	for i = 0, gameTable.size - 1
	do
		local currentMemByte =  memory.readbyte(gameTable.addr + i, gameTable.memdomain)
		local currentGameByte = gameTable.hex[i + 1]
		if currentMemByte ~= currentGameByte then
			Log:debug("Game is not " .. gameTable.name .. ". " .. tostring(currentGameByte) .. " ~= " .. tostring(currentMemByte))
			return false
		end
	end
	Log:debug("Verified " .. gameTable.name .. " is loaded")
	Log:info("Detected Game: " .. gameTable.name)
	return true
end

function GameSettings.initialize()

	local gamecode = memory.read_u32_be(0x013A, "ROM")
	for _, game in pairs(Games)
	do
		if determineIfGame(game) then
			GameSettings.game = game
		end
	end

	if gamecode == 0x4E5F474C then -- N_GL

	elseif gamecode == 0x4E5F534C then -- N_SL


	-- https://archives.glitchcity.info/forums/board-76/thread-1342/page-0.html
	elseif gamecode == 0x5354414C then -- STAL
		GameSettings.wildpokemon = 0xD206
	else
		GameSettings.game = 0
		GameSettings.gamename = "Unsupported game"
		GameSettings.encountertable = 0
	end
end
GameSettings.initialize()