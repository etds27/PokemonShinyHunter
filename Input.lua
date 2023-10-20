Input = {}

Buttons = {
    A = "A",
    B = "B",
    DOWN = "Down",
    LEFT = "Left",
    POWER = "Power",
    RIGHT = "Right",
    SELECT = "Select",
    START = "Start",
    UP = "Up"
}

Duration = {
    TAP = 1,
    PRESS = 15,
    LONG_PRESS = 20,
    TURN = 5,
    STEP = 19,
    MENU_TAP = 5
}

function Input:pressButtons(args) 
    --[[
    Press the given button combination

    Arguments:
        - buttonKeys: A list of Buttons enums to press
        - duration: Int to determine how long to press the buttons for
        - releaseStart: Bool to release all keys before pressing the buttons
        - releaseEnd: Bool to release all keys after they have been pressed
        - waitFrames: Number of frames to wait after the action to respolve animations
    --]]
    -- Log:debug("Input:pressButtons init")
    input = joypad.get()
    buttonKeys = args.buttonKeys

    if args.duration == nil then
        duration = Duration.PRESS
    else 
        duration = args.duration 
    end

    if args.releaseStart == nil then
        releaseStart = true
    else 
        releaseStart = args.releaseStart
    end

    if args.releaseEnd == nil then
        releaseEnd = true
    else
        releaseEnd = args.releaseEnd
    end

    if args.waitFrames == nil then
        waitFrames = 20
    else
        waitFrames = args.waitFrames
    end

    if releaseStart then
        Input:releaseAllKeys()
    end

    for _, buttonKey in pairs(buttonKeys) do
        input[buttonKey] = true
    end

    for i = 1, duration, 1 do
        joypad.set(input)
        emu.frameadvance()
    end

    if releaseEnd then
        Input:releaseAllKeys()
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitFrames)
end

function Input:repeatedlyPressButton(args) 
    --[[
        Press a button combination repeatedly

        Arguments:
            - iterations: Number of times to press the button combination
            - waitEnd: Frames to wait after all presses have been performed
    ]]
    -- Log:debug("Input:repeatedlyPressButton init")
    if args.iterations == nil then
        iterations = 1
    else
        iterations = args.iterations
    end

    if args.waitEnd == nil then
        waitEnd = 0
    else
        waitEnd = args.waitEnd
    end

    for _ = 1, iterations do
        Input:pressButtons(args)
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitEnd)
end

function Input:performButtonSequence(args)
    --[[
        Perform a sequence of button actions
        
        Arguments:
            - buttonSequence: A table of tables where each leaf table holds the Button identifer to press
            - waitEnd: Frames to wait after all presses have been performed
            - SEE Input:pressButtons
    ]]
    Log:debug("Input:performButtonSequence init")

    if args.waitEnd == nil then
        waitEnd = 0
    else
        waitEnd = args.waitEnd
    end

    if args.buttonSequence == nil then print("ERROR: Button sequence not provided") end
    for _, buttonKeys in pairs(args.buttonSequence) do
        arg = Common:shallowcopy(args)
        arg.buttonSequence = nil
        arg.buttonKeys = buttonKeys

        Input:pressButtons(arg)
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitEnd)
end

function Input:performButtonSequenceUntil(args)
    --[[
        Perform a sequence of button actions until a criteria is met
        
        Arguments:
            - buttonSequence: A table of tables where each leaf table holds the Button identifer to press
            - waitEnd: Frames to wait after all presses have been performed
            - callback: Function to run and compare return result
            - expectedResult: Object to compare the callback functions return status to
            - timeout: Maximum number of times to run the callback function
            - SEE Input:pressButtons
    ]]
    i = 0

    if args.waitEnd == nil then
        waitEnd = 0
    else
        waitEnd = args.waitEnd
    end

    if args.timeout == nil then
        timeout = 1
    else
        timeout = args.timeout
    end

    if args.callback == nil then
        Log:error("No callback function provided")
    end

    func = load(args.callback)

    while i < timeout do
        Input:performButtonSequence{args}
        if func() == expectedResult then
            -- Wait for X frames after pressing buttons
            Common:waitFrames(waitEnd)
            return true
        end
    end

    return false
end

    

function Input:releaseAllKeys()
    --[[
        Release all set keys
    ]]
    input = joypad.get()
    for key in pairs(input) do
        input[key] = false
    end
    joypad.set(input)
end


-- TESTS

--[[
Input:performButtonSequence{
    buttonSequence={{Buttons.START}, {Buttons.DOWN}, {Buttons.A}}
}

Input:releaseAllKeys()

Input:pressButtons{buttonKeys={Buttons.START}}
Input:pressButtons{buttonKeys={Buttons.DOWN}}
Input:pressButtons{buttonKeys={Buttons.A}}

--Input:pressButtons{buttonKeys={Buttons.LEFT}}

--[[
Input:repeatedlyPressButton{buttonKeys={Buttons.RIGHT}, 
                            releaseEnd=false, 
                            duration=Duration.PRESS, 
                            iterations=10,
                            waitFrames=10}
--]]
