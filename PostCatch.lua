PostCatch = {
    iterations = 20
}

function PostCatch:continueUntilOverworld() 
    i = 0
    while not Positioning:inOverworld() and i < PostCatch.iterations
    do
        Input:pressButtons({buttonKeys={Buttons.B}, duration=Duration.LONG_PRESS})
        i = i + 1
    end

    return Positioning:inOverworld()
end