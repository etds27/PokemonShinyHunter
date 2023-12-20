local Model = {
    DayOfWeek = {
        addr = 0xD4CB,
        size = 1,
        memdomain = Memory.WRAM,
        SUNDAY = 0,
        MONDAY = 1,
        TUESDAY = 2,
        WEDNESDAY = 3,
        THURSDAY = 4,
        FRIDAY = 5,
        SATURDAY = 6
    },
    Hour = {
        addr = 0x14,
        size = 1,
        memdomain = Memory.HRAM
    },
    Minute = {
        addr = 0x16,
        size = 1,
        memdomain = Memory.HRAM
    },
    Second = {
        addr = 0x18,
        size = 1,
        memdomain = Memory.HRAM
    },
    TimeOfDay = {
        Morning = {
            start = 4,
            finish = 10,
        },
        Day = {
            start = 10,
            finish = 18,
        },
        Night = {
            start = 18,
            finish = 4,
        }
    }
}

return Model