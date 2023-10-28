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
        addr = MenuCursor.addr,
        size = MenuCursor.size,
        SWITCH = 1,
        NAME = 2,
        PRINT = 3,
        QUIT = 4,
    },
}
return Model