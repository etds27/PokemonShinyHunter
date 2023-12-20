SAVE_STATE_PATH = TestStates.POST_CATCH_TEST

PostCatchTest = {}

function PostCatchTest:testContinueToOverworld()
    savestate.load(SAVE_STATE_PATH)
    return PostCatch:continueUntilOverworld() 
end

print("PostCatchTest:testContinueToOverworld()", PostCatchTest:testContinueToOverworld())