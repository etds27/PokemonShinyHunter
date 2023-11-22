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
    ALL_BALLS = gameDirectory .. "AllBalls.State",
    AUTO_CATCH_SAVE_STATE = gameDirectory .. "AutoCatch.State",
    BAG_TEST = gameDirectory .. "BagTests.State",
    BOX_1_6 = gameDirectory .. "Box1_6.State",
    BOX_4 = gameDirectory .. "Box4.State",
    BOXUI_OVERWORLD = gameDirectory .. "PCOverworldBox3.State",
    DAY_CARE_MAN = gameDirectory .. "DayCareMan.State",
    DAY_CARE_PC = gameDirectory .. "DayCarePC.State",
    EEVEE = gameDirectory .. "Eevee.State",
    EGG_READY = gameDirectory .. "EggReady2Pokemon.State",
    EGG_RESET_POINT = gameDirectory .. "EggResetPoint.State",
    FISH_OFF_LINE = gameDirectory .. "FishOffLine.State",
    FISH_ON_LINE = gameDirectory .. "FishOnLine.State",
    HEADBUTT_ENCOUNTER = gameDirectory .. "HeadbuttEncounter.State",
    HEADBUTT_NO_ENCOUNTER = gameDirectory .. "HeadbuttNoEncounter.State",
    MENU_OPEN = gameDirectory .. "MenuOpen.State",
    NO_BALLS = gameDirectory .. "NoBallsOverworld.State",
    POKE_GEAR_MENU = gameDirectory .. "PokegearMenuTest.State",
    POKEDEX = gameDirectory .. "Pokedex.State",
    POKEMON_DEPOSIT = gameDirectory .. "PokemonDeposit.State",
    POKEMON_PARTY = gameDirectory .. "PokemonParty.State",
    POKEMON_TESTS = gameDirectory .. "PokemonTests.State",
    POSITIONING_BIKE = gameDirectory .. "PositioningBike.State",
    POSITIONING_NO_BIKE = gameDirectory .. "PositioningNoBike.State",
    POST_CATCH_TEST = gameDirectory .. "PostCatchTests.State",
    PRE_FISHING = gameDirectory .. "PreFishing.State",
    SHUCKLE = gameDirectory .. "Shuckle.State",
    SHUCKLE_PARTY_TEST = gameDirectory .. "ShucklePartyTest.State",
    START_OF_BATTLE_SAVE_STATE = gameDirectory .. "StartOfBattle.State",
    STARTER_CHIKORITA = gameDirectory .. "StarterResetChikorita.State",
    STARTER_CYNDAQUIL = gameDirectory .. "StarterResetCyndaquil.State",
    STARTER_TOTODILE = gameDirectory .. "StarterResetTotodile.State",
    TRAINER_TESTS = gameDirectory .. "TrainerTests.State"
}