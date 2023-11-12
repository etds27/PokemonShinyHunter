require "Radio"

MenuTest = {}

function MenuTest:testActiveNavigateMenuFromTable()
    savestate.load(TestStates.POKE_GEAR_MENU)
    return Menu:activeNavigateMenuFromTable(Radio.Station, Radio.Station.POKE_FLUTE, {duration = 2, waitFrames = 10, downIsUp = false})
end


print("MenuTest:testActiveNavigateMenuFromTable()", MenuTest:testActiveNavigateMenuFromTable())