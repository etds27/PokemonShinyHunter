require "Menu"

local Model = {
    Pocket = {
        addr = 0xCF65,
        size = 1,
        ITEMS = 0,
        BALLS = 1,
        KEY_ITEMS = 2,
        TM_HM = 3,
    },

    Cursor = Menu.Cursor,

    ItemPocket = {
        addr = 0xD892,
        size = 1
    },

    BallPocket = {
        addr = 0xD8D7,
        size = 1
    },

    KeyPocket = {
        addr = 0xD8BC,
        size = 1
    },

    TMHMPocket = {
        addr = 0xD859,
        size = 1
    },

    BattleItem = {
        USE = 1,
        QUIT = 2,
    },

    BagOpen = {
        addr = 0xCFCC,
        size = 1,
        OPEN = 19,
    },

    SelectedItem = {
        addr = 0xD95C,
        size = 1
    },

    KeyMenu = {
        addr = Menu.Cursor.addr,
        size = Menu.Cursor.size,
        USE = 1,
        SEL = 2,
        QUIT = 3,
    }
}

return Model