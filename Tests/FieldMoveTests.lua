require "Headbutt"
require "Common"

FieldMoveTest = {}

function FieldMoveTest:testHeadbuttEncounter()
    savestate.load(TestStates.HEADBUTT_ENCOUNTER)
    return Headbutt:headbuttTree()
end


function FieldMoveTest:testHeadbuttNoEncounter()
    savestate.load(TestStates.HEADBUTT_NO_ENCOUNTER)
    return not Headbutt:headbuttTree()
end

print("FieldMoveTest:testHeadbuttEncounter()", FieldMoveTest:testHeadbuttEncounter())
print("FieldMoveTest:testHeadbuttNoEncounter()", FieldMoveTest:testHeadbuttNoEncounter())
