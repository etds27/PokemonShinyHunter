PartyFactory = {}

function PartyFactory:loadModel()
    Common:resetRequires({"GSCParty"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCParty")
    end
    return {}
end