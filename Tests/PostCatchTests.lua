SAVE_STATE_PATH = "States\\PostCatchTests.State"

PostCatchTest = {}

function PostCatchTest:testContinueToOverworld()
    savestate.load(SAVE_STATE_PATH)
    return PostCatch:continueUntilOverworld() 
end

print("PostCatchTest:testContinueToOverworld", PostCatchTest:testContinueToOverworld())