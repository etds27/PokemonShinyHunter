require "StartMenuFactory"
require "Memory"
require "Positioning"

StartMenu = {}

-- Abstract tables
local Model = {}
Model.size = 0
Model.addr = 0
Model = StartMenuFactory:loadModel()
StartMenu = Common:tableMerge(StartMenu, Model)

---Open the start menu
---@return boolean true if the user is no longer in the overworld
function StartMenu:open()
    if not Positioning:inOverworld() then
        Log:error("Not in overworld")
        return false
    end

    Input:pressButtons{buttonKeys={Buttons.START}, duration=Duration.PRESS, waitFrames=30}

    return not Positioning:inOverworld()
end

---Move the cursor to the desired option. Assumes the menu is open
---@param option StartMenu.Option Menu Option to naivgate to
---@param maxAttempts integer? Total number of button presses to take to reach the desired option
---@return boolean true if the option was reached
function StartMenu:navigateToOption(option, maxAttempts)
    if maxAttempts == nil then maxAttempts = 20 end
    local i = 0
    while i < maxAttempts
    do
        if Memory:readFromTable(StartMenu) == option then
            return true
        end
        Input:pressButtons{buttonKeys={Buttons.DOWN}, duration=5, waitFrames=5}
        i = i + 1
    end

    return false
end

---Navigate to option and select it
---@param option StartMenu.Option Menu Option to naivgate to
---@param maxAttempts integer? Total number of button presses to take to reach the desired option
---@return boolean true if the option was reached
function StartMenu:selectOption(option, maxAttempts)
    if not StartMenu:navigateToOption(option, maxAttempts) then
        Log:error("Unable to find menu option: " .. tostring(option))
        return false
    end
    Input:pressButtons{buttonKeys={Buttons.A}, duration=Duration.PRESS}
    return true
end

