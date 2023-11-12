require "Common"
require "Log"

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
---@class ButtonDuration
---@field duration integer? [20] Int to determine how long to press the buttons for
---@field waitFrames number? [20] Number frames to wait after the action to resolve animations

---@class ButtonPress
---@field buttonKeys table A list of Buttons enums to press
---@field duration integer? [20] Int to determine how long to press the buttons for
---@field releaseStart boolean? to release all keys before pressing the buttons
---@field releaseEnd boolean? to release all keys after they have been pressed
---@field waitFrames number? [20] Number frames to wait after the action to resolve animations
---@field iterations integer? Number of times to perform action for repeatedlyPressButton
---@field waitEnd integer? Number of frames to wait after perform action sequence

---@class ButtonPresses
---@field duration integer? [20] Int to determine how long to press the buttons for
---@field releaseStart boolean? to release all keys before pressing the buttons
---@field releaseEnd boolean? to release all keys after they have been pressed
---@field waitFrames number? [20] Number frames to wait after the action to resolve animations
---@field buttonSequence table? Sequence of buttons as list of list
---@field waitEnd integer? Number of frames to wait after perform action sequence

---Press the given button combination
---@param args ButtonPress
function Input:pressButtons(args)
    local input = joypad.get()
    local buttonKeys = args.buttonKeys
    local duration = 0
    local releaseEnd = true
    local releaseStart = true
    local waitFrames = 0

    duration = args.duration or Duration.PRESS

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

    waitFrames = args.waitFrames or 20

    if releaseStart then
        Input:releaseAllKeys()
    end

    for _, buttonKey in pairs(buttonKeys) do
        input[buttonKey] = true
    end

    for _ = 1, duration, 1 do
        joypad.set(input)
        emu.frameadvance()
    end

    if releaseEnd then
        Input:releaseAllKeys()
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitFrames)
end

---Press a button combination repeatedly
---@param args ButtonPress
function Input:repeatedlyPressButton(args)
    local iterations
    local waitEnd

    iterations = args.iterations or 1
    waitEnd = args.waitEnd or 0

    for _ = 1, iterations do
        Input:pressButtons(args)
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitEnd)
end


---Perform a sequence of button actions
---@param args ButtonPresses
function Input:performButtonSequence(args)
    Log:debug("Input:performButtonSequence init")

    local waitEnd = args.waitEnd or 0

    if args.buttonSequence == nil then Log:error("Button sequence not provided") end

    for _, buttonKeys in pairs(args.buttonSequence) do
        arg = Common:shallowcopy(args)
        arg.buttonSequence = nil
        arg.buttonKeys = buttonKeys
        Input:pressButtons(arg)
    end

    -- Wait for X frames after pressing buttons
    Common:waitFrames(waitEnd)
end

---Release all keys
function Input:releaseAllKeys()
    local input = joypad.get()
    for key in pairs(input) do
        input[key] = false
    end
    joypad.set(input)
end
