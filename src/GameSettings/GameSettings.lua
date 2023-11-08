require "Memory"

GameID = {
	CRYSTAL = {name = "PM_CRYSTAL",
			   hex = {0x50, 0x4D, 0x5F, 0x43, 0x52, 0x59, 0x53, 0x54, 0x41, 0x4C}, -- PM_CRYSTAL
			   addr = 0x134,
			   size = 10,
			   memdomain = "ROM"},
	GOLD = {name = "POKEMON_GLD",
			hex = {0x50, 0x4F, 0x4B, 0x45, 0x4D, 0x4F, 0x4E, 0x5F, 0x47, 0x4C, 0x44}, -- POKEMON_GLD
			addr = 0x134,
			size = 11,
			memdomain = "ROM"},
	SILVER = {name = "POKEMON_SLV",
			hex = {0x50, 0x4F, 0x4B, 0x45, 0x4D, 0x4F, 0x4E, 0x5F, 0x53 , 0x4C, 0x56}, -- POKEMON_GLD
			addr = 0x134,
			size = 11,
			memdomain = "ROM"},
}

-- Convenience groups to associate similar games
GameGroups = {
	GEN_2 = {GameID.CRYSTAL, GameID.GOLD, GameID.SILVER},
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

MenuCursor = {
	addr = 0,
	size = 0,
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
		currentMemByte =  memory.readbyte(gameTable.addr + i, gameTable.memdomain)
		currentGameByte = gameTable.hex[i + 1]
		if currentMemByte ~= currentGameByte then
			Log:debug("Game is not " .. gameTable.name .. ". " .. tostring(currentGameByte) .. " ~= " .. tostring(currentMemByte))
			return false
		end
	end
	Log:debug("Verified " .. gameTable.name .. " is loaded")

	return true
end

function GameSettings.initialize()

	local gamecode = memory.read_u32_be(0x013A, "ROM")
	local pstats = {0x3004360, 0x20244EC, 0x2024284, 0x3004290, 0x2024190, 0x20241E4} -- Player stats
	local estats = {0x30045C0, 0x2024744, 0x202402C, 0x30044F0, 0x20243E8, 0x2023F8C} -- Enemy stats
	local rng    = {0x3004818, 0x3005D80, 0x3005000, 0x3004748, 0x3005AE0, 0x3005040} -- RNG address
	local coords = {0x30048B0, 0x2037360, 0x2036E48, 0x30047E0, 0x2037000, 0x2036D7C} -- X/Y coords
	local rng2   = {0x0000000, 0x0000000, 0x20386D0, 0x0000000, 0x0000000, 0x203861C} -- RNG encounter (FRLG only)
	local wram	 = {0x0000000, 0x2020000, 0x2020000, 0x0000000, 0x0000000, 0x201FF4C} -- WRAM address
	local mapbank = {0x20392FC, 0x203BC80, 0x203F3A8, 0x2038FF4, 0x203B94C, 0x203F31C} -- Map Bank
	local mapid = {0x202E83C, 0x203732C, 0x2036E10, 0x202E59C, 0x2036FCC, 0x2036D44} -- Map ID
	local trainerpointer = {0xDCDF, 0xDD0F, 0xDD3F, 0xDD6F, 0xDD9F, 0xDDCF} -- Trainer Data Pointer
	local roamerpokemonoffset = {0x39D4, 0x4188, 0x4074, 0x39D4, 0x4188, 0x4074}
	
	for name, game in pairs(GameID)
	do
		if determineIfGame(game) then
			GameSettings.game = game
		end
	end




	if gamecode == 0x4E5F474C then -- N_GL
		GameSettings.game = 1
		GameSettings.gamename = "Pokemon Gold (U)"
		GameSettings.gamecolor = 0xFFF01810
		GameSettings.encountertable = 0x839D454
		GameSettings.version = GameSettings.VERSIONS.G
		GameSettings.language = GameSettings.LANGUAGES.U
	elseif gamecode == 0x4E5F534C then -- N_SL
		GameSettings.game = 2
		GameSettings.gamename = "Pokemon Silver (U)"
		GameSettings.gamecolor = 0xFF123AE5
		GameSettings.encountertable = 0x839D29C
		GameSettings.version = GameSettings.VERSIONS.S
		GameSettings.language = GameSettings.LANGUAGES.U

	-- https://archives.glitchcity.info/forums/board-76/thread-1342/page-0.html
	elseif gamecode == 0x5354414C then -- STAL
		GameSettings.wildpokemon = 0xD206
	else
		GameSettings.game = 0
		GameSettings.gamename = "Unsupported game"
		GameSettings.encountertable = 0
	end
	
	console.log("Detected game: " .. GameSettings.gamename)

end
GameSettings.initialize()