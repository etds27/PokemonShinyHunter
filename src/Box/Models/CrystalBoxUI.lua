require "Menu"
local Model = {
    PCMainMenu = {
        BILL = 1,
        TRAINER = 2,
        PROF_OAK = 3,
        TURN_OFF = 4
    },

    PCBillsMenu = {
        WITHDRAW = 1,
        DEPOSIT = 2,
        CHANGE_BOX = 3,
        MOVE_PKMN = 4
    },

    PCBoxCursor = {
        addr = 0xD106,
        size = 1,
        CANCEL = 255
    },

    PCBoxEdit = {
        addr = Menu.Cursor.addr,
        size = Menu.Cursor.size,
        SWITCH = 1,
        NAME = 2,
        PRINT = 3,
        QUIT = 4,
    },

    Action = {
        DEPOSIT = 1,
        WITHDRAW = 2,
        RELEASE = 3,
    },

    CurrentPokemonCursor = {
        ViewOffset = {
            addr = 0xCA2A,
            size = 1,
            memdomain = Memory.WRAM
        },
        CursorOffset = {
            addr = 0xCA2B,
            size = 1,
            memdomain = Memory.WRAM
        }
    },

    DepositMenu = {
        DEPOSIT = 1,
        STATS = 2,
        RELEASE = 3,
    }
}

function Model:currentPokemonIndex()
    --[[
        This index is calcuated by adding the view offset to the cursor offset
    ]]
    return Memory:readFromTable(Model.CurrentPokemonCursor.ViewOffset) + Memory:readFromTable(Model.CurrentPokemonCursor.CursorOffset)
end

return Model