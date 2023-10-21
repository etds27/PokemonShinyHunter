Fishing = {
    addr = 0xD1EF,
    size = 1,
    FISH = 1,
    NO_FISH = 2,
}

Rods = {
    Items.OLD_ROD,
    Items.GOOD_ROD,
    Items.SUPER_ROD
}

function Fishing:fish() 
    --[[
        Handle all interation after the rod has been selected from the bag

        Returns: true if a fish was hooked, false, if it didnt fish or nothing was caught
    ]]
    catchStatus = Memory:readFromTable(Fishing)
    if catchStatus == Fishing.FISH then
        Common:waitFrames(310)
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        Common:waitFrames(210)
        return true
    elseif catchStatus == Fishing.NO_FISH then
        Common:waitFrames(180)
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        Log:debug("Not a nibble")
        return false
    else
        Log:debug("Never fished")
        return false
    end
end