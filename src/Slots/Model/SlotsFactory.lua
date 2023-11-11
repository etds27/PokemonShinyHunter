SlotsFactory = {}

function SlotsFactory:loadModel()
    Common:resetRequires({"GSCSlots"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCSlots")
    end

    return {}
end
