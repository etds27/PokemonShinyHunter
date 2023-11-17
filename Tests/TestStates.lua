require  "Common"
require "GameSettings"
GameSettings.initialize()

local gameDirectory = ""
if Common:contains(GameGroups.GOLD_SILVER, GameSettings.game) then
    gameDirectory = "States\\GoldSilver\\"
elseif GameSettings.game == Games.CRYSTAL then
    gameDirectory = "States\\Crystal\\"
end

---@enum TestStates
TestStates = {
    POST_CATCH_TEST = gameDirectory .. "PostCatchTests.State",
    AUTO_CATCH_SAVE_STATE = gameDirectory .. "AutoCatch.State",
    START_OF_BATTLE_SAVE_STATE = gameDirectory .. "StartOfBattle.State",
    BAG_TEST = gameDirectory .. "BagTests.State",
    NO_BALLS = gameDirectory .. "NoBallsOverworld.State",
    ALL_BALLS = gameDirectory .. "AllBalls.State",
    BOX_4 = gameDirectory .. "Box4.State",
    BOX_1_6 = gameDirectory .. "Box1_6.State",
    BOXUI_OVERWORLD = gameDirectory .. "PCOverworldBox3.State",
    STARTER_CYNDAQUIL = gameDirectory .. "StarterResetCyndaquil.State",
    STARTER_TOTODILE = gameDirectory .. "StarterResetTotodile.State",
    STARTER_CHIKORITA = gameDirectory .. "StarterResetChikorita.State",
    FISH_ON_LINE = gameDirectory .. "FishOnLine.State",
    FISH_OFF_LINE = gameDirectory .. "FishOffLine.State",
    PRE_FISHING = gameDirectory .. "PreFishing.State",
    POKEMON_PARTY = gameDirectory .. "PokemonParty.State",
    POKEMON_TESTS = gameDirectory .. "PokemonTests.State",
    POSITIONING_NO_BIKE = gameDirectory .. "PositioningNoBike.State",
    POSITIONING_BIKE = gameDirectory .. "PositioningBike.State",
    DAY_CARE_MAN = gameDirectory .. "DayCareMan.State",
    DAY_CARE_PC = gameDirectory .. "DayCarePC.State",
    EGG_RESET_POINT = gameDirectory .. "EggResetPoint.State",
    POKEMON_DEPOSIT = gameDirectory .. "PokemonDeposit.State",
    EGG_READY = gameDirectory .. "EggReady2Pokemon.State",
    SHUCKLE = gameDirectory .. "Shuckle.State",
    EEVEE = gameDirectory .. "Eevee.State",
    MENU_OPEN = gameDirectory .. "MenuOpen.State",
    POKEDEX = gameDirectory .. "Pokedex.State",
    HEADBUTT_ENCOUNTER = gameDirectory .. "HeadbuttEncounter.State",
    HEADBUTT_NO_ENCOUNTER = gameDirectory .. "HeadbuttNoEncounter.State",
    POKE_GEAR_MENU = gameDirectory .. "PokegearMenuTest.State",
    SHUCKLE_PARTY_TEST = gameDirectory .. "ShucklePartyTest.State"
}