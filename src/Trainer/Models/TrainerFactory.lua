TrainerFactory = {}

function TrainerFactory:loadModel()
    Common:resetRequires({"GSCTrainer"})
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCTrainer")
    end

    return {}
end
