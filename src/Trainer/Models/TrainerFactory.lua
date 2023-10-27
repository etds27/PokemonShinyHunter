TrainerFactory = {}

function TrainerFactory:loadModel()
    if Common:contains(GameGroups.GEN_2, GameSettings.game) then
        return require("GSCTrainer")
    end
end
