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
		GameSettings.game = 3
		GameSettings.gamename = "Pokemon Crystal (U)"
		GameSettings.gamecolor = 0xFF009D07
		GameSettings.encountertable = 0x8552D48
		GameSettings.version = GameSettings.VERSIONS.C
		GameSettings.language = GameSettings.LANGUAGES.U
		GameSettings.partypokemon = {0xDCDF, 0xDD0F, 0xDD3F, 0xDD6F, 0xDD9F, 0xDDCF}
		GameSettings.enemypokemon = {0xD288, 0xD2B8, 0xD2E8, 0xD318, 0xD348, 0xD378}
		GameSettings.wildpokemon = 0xD206
		GameSettings.posx = 0xDCB8
		GameSettings.posy = 0xDCB7
		GameSettings.menupointer = 0xC5E5
		GameSettings.menuCursor = 0xCFA9
		GameSettings.bagCursor = 0xCF65
		GameSettings.battleCursor = 0xCFA8 -- 2 Bytes
		GameSettings.frameCounter = 0xD4C8
		MenuCursor = {
			addr = 0xCFA9,
			size = 1
		}
	else
		GameSettings.game = 0
		GameSettings.gamename = "Unsupported game"
		GameSettings.encountertable = 0
	end
	
	if GameSettings.game > 0 then
		GameSettings.pstats  = pstats[GameSettings.game]
		GameSettings.estats  = estats[GameSettings.game]
		GameSettings.rng     = rng[GameSettings.game]
		GameSettings.rng2    = rng2[GameSettings.game]
		GameSettings.wram	 = wram[GameSettings.game]
		GameSettings.mapbank = mapbank[GameSettings.game]
		GameSettings.mapid = mapid[GameSettings.game]
		GameSettings.trainerpointer = trainerpointer[GameSettings.game]
		GameSettings.coords = coords[GameSettings.game]
		GameSettings.roamerpokemonoffset = roamerpokemonoffset[GameSettings.game]
	end
	
	if GameSettings.game % 3 == 1 then
		GameSettings.rngseed = 0x5A0
	else
		GameSettings.rngseed = Memory:readword(GameSettings.wram)
	end
	console.log("Detected game: " .. GameSettings.gamename)

end
GameSettings.initialize()