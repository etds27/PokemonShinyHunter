require "Common"
require "Input"
require "Log"
require "Memory"
require "Positioning"

PostCatch = {
    iterations = 100
}

---Continue from after the pokemon is confirmed to be caught to the overworld
---
---This will skip the pokedex and new name screens
---@return boolean true if the player is returned to the overworld
function PostCatch:continueUntilOverworld()
    local i = 0
    Log:debug("PostCatch:continueUntilOverworld - init")
    while not Positioning:inOverworld() and i < PostCatch.iterations
    do
        Input:pressButtons({buttonKeys={Buttons.B}, duration=Duration.LONG_PRESS, waitFrames=2})
        i = i + 1
    end
    Log:debug("PostCatch:continueUntilOverworld - complete")
    return Positioning:inOverworld()
end