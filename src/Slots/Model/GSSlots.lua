require "Input"
require "Memory"
require "Positioning"
require "Trainer"

local Model = {
    ColumnsSpinning = {
        [1] = {
            addr = 0xC5D6,
            size = 1,
            memdomain = Memory.WRAM,
        },
        [2] = {
            addr = 0xC5E6,
            size = 1,
            memdomain = Memory.WRAM,
        },
        [3] = {
            addr = 0xC5F6,
            size = 1,
            memdomain = Memory.WRAM,
        },
        SPINNING = 4,
        NOT_SPINNING = 1,
    },
    Columns = {
        [1] = {
            addr = 0xC5D4,
            size = 1,
            memdomain = Memory.WRAM,
        },
        [2] = {
            addr = 0xC5E4,
            size = 1,
            memdomain = Memory.WRAM,
        },
        [3] = {
            addr = 0xC5F4,
            size = 1,
            memdomain = Memory.WRAM,
        },
        SEVEN = 0,
        ALMOST_SEVEN = 0xE,
    },
    Payout = {
        addr = 0xC611,
        size = 2,
        memdomain = Memory.WRAM
    }
}

function Model:playSlotUntilAmount(amount)
    local coins = Trainer:getTrainerCoins()
    local i = 0
    local waitFrames = 60
    while true
    do
        coins = Trainer:getTrainerCoins()
        if coins >= amount then
            Log:info("playSlotUntilAmount: finshed gambling")
            break
        end

        if coins <=3 then
            Log:error("Not enough coins to gamble")
            break
        end

        if Memory:readFromTable(Model.ColumnsSpinning[1]) == Model.ColumnsSpinning.SPINNING then
            i = 0
            while i < waitFrames
            do
                if Memory:readFromTable(Model.Columns[1]) == Model.Columns.SEVEN then
                    Input:pressButtons{buttonKeys={Buttons.A}, duration=4, waitFrames=2}
                    break
                end
                emu.frameadvance()
                i = i + 1
            end

            i = 0
            while i < waitFrames
            do
                if Memory:readFromTable(Model.Columns[2]) == Model.Columns.SEVEN then
                    Input:pressButtons{buttonKeys={Buttons.A}, duration=4, waitFrames=2}
                    break
                end
                emu.frameadvance()
                i = i + 1
            end

            i = 0
            while i < waitFrames
            do
                if Memory:readFromTable(Model.Columns[3]) == Model.Columns.ALMOST_SEVEN then
                    Input:pressButtons{buttonKeys={Buttons.A}, duration=4, waitFrames=2}
                    break
                end
                emu.frameadvance()
                i = i + 1
            end
        end
        Input:pressButtons{buttonKeys={Buttons.A}, duration=14, waitFrames=2}
    end
    while not Positioning:inOverworld()
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=14, waitFrames=2}
    end
    return Positioning:inOverworld() and coins >= amount
end

return Model