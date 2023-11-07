require "MainMenuFactory"
require "Memory"
require "Positioning"

-- Abstract tables
local Model = {}
Model.size = 0
Model.addr = 0
local Model = MainMenuFactory:loadModel()

-- 
MainMenu = {}
MainMenu = Common:tableMerge(MainMenu, Model)

function MainMenu:open()
    if not Positioning:inOverworld() then
        Log:error("Not in overworld")
        return false
    end

    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS, waitFrames=30}

    return not Positioning:inOverworld()
end

function MainMenu:navigateToOption(option, maxAttempts)
    --[[
        Move the cursor to the desired option. Assumes the menu is open
    ]]
    if maxAttempts == nil then maxAttempts = 20 end
    local i = 0
    while i < maxAttempts
    do
        if Memory:readFromTable(MainMenu) == option then
            return true
        end
        Input:pressButtons{buttonKeys={Buttons.DOWN}, duration=5, waitFrames=5}
        i = i + 1
    end

    return false
end

function MainMenu:selectOption(option, maxAttempts)
    if not MainMenu:navigateToOption(option, maxAttempts) then
        Log:error("Unable to find menu option: " .. tostring(option))
        return false
    end
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end

