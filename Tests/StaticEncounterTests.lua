require "BotModes"
require "StaticEncounters"
require "Party"
require "Positioning"

StaticEncounterTest = {}

function StaticEncounterTest:testShuckle()
    savestate.load(TestStates.SHUCKLE)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters[BotModes.SHUCKLE_GSC])
end

function StaticEncounterTest:testEevee()
    savestate.load(TestStates.EEVEE)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters[BotModes.EEVEE_GSC])
end

function StaticEncounterTest:testCyndaquil()
    savestate.load(TestStates.STARTER_CYNDAQUIL)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters[BotModes.STARTER])
end

function StaticEncounterTest:testTotodile()
    savestate.load(TestStates.STARTER_TOTODILE)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters[BotModes.STARTER])
end

function StaticEncounterTest:testChikorita()
    savestate.load(TestStates.STARTER_CHIKORITA)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters[BotModes.STARTER])
end

function StaticEncounterTest:performStaticEncounter(encounterFunction)
    local startNumPokemon = Party:numOfPokemonInParty()
    encounterFunction()
    Party:navigateToPokemon(startNumPokemon + 1)
    return Party:numOfPokemonInParty() > startNumPokemon
end



print("StaticEncounterTest:testShuckle()", StaticEncounterTest:testShuckle())
print("StaticEncounterTest:testEevee()", StaticEncounterTest:testEevee())
print("StaticEncounterTest:testCyndaquil()", StaticEncounterTest:testCyndaquil())
print("StaticEncounterTest:testTotodile()", StaticEncounterTest:testTotodile())
print("StaticEncounterTest:testChikorita()", StaticEncounterTest:testChikorita())
