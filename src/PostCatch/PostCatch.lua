require "Common"
require "Log"
require "Memory"
require "Input"
require "Positioning"

PostCatch = {
    iterations = 100
}

function PostCatch:continueUntilOverworld() 
    i = 0
    Log:debug("PostCatch:continueUntilOverworld - init")
    while not Positioning:inOverworld() and i < PostCatch.iterations
    do
        Input:pressButtons({buttonKeys={Buttons.B}, duration=Duration.LONG_PRESS, waitFrames=2})
        i = i + 1
    end
    Log:debug("PostCatch:continueUntilOverworld - complete")
    return Positioning:inOverworld()
end