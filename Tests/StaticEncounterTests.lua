require "StaticEncounters"
require "Party"
require "Positioning"

StaticEncounterTest = {}

function StaticEncounterTest:testShuckle()
    savestate.load(TestStates.SHUCKLE)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters.shuckleEncounter)
end

function StaticEncounterTest:testEevee()
    savestate.load(TestStates.EEVEE)
    return StaticEncounterTest:performStaticEncounter(StaticEncounters.eeveeEncounter)
end


function StaticEncounterTest:performStaticEncounter(encounterFunction)
    local startNumPokemon = Party:numOfPokemonInParty()
    encounterFunction()
    return Positioning:inOverworld() and Party:numOfPokemonInParty() > startNumPokemon
end

print("StaticEncounterTest:testShuckle()", StaticEncounterTest:testShuckle())
print("StaticEncounterTest:testEevee()", StaticEncounterTest:testEevee())