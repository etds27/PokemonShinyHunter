require "Menu"

local Model = {
    Pocket = {
        addr = 0xCE65,
        size = 1,
        ITEMS = 0,
        BALLS = 1,
        KEY_ITEMS = 2,
        TM_HM = 3,
    },

    Cursor = Menu.Cursor,

    ItemPocket = {
        addr = 0xD589,
        size = 1
    },

    BallPocket = {
        addr = 0xD5FC,
        size = 1
    },

    KeyPocket = {
        addr = 0xD616,
        size = 1
    },

    TMHMPocket = {
        addr = 0xD57E,
        size = 1
    },

    BattleItem = {
        USE = 1,
        QUIT = 2,
    },

    BagOpen = {
        addr = 0xD199,
        size = 1,
        OPEN = 19,
    },

    SelectedItem = {
        addr = 0xD681,
        size = 1
    },
}

return Model