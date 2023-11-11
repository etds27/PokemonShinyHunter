require "ClockFactory"
require "Common"
require "Memory"

Clock = {}

-- Abstract tables
local Model = {}
Model.DayOfWeek = {}
Model.Hour = {}
Model.Minute = {}
Model.Second = {}
Model.TimeOfDay = {
    Morning = {},
    Day = {},
    Night = {},
}
Model = ClockFactory:loadModel()

-- Merge model into class
Clock = Common:tableMerge(Clock, Model)

function Clock:getDayOfWeek()
    return Memory:readFromTable(Clock.DayOfWeek)
end

function Clock:getHour()
    return Memory:readFromTable(Clock.Hour)
end

function Clock:getMinute()
    return Memory:readFromTable(Clock.Minute)
end

function Clock:getSecond()
    return Memory:readFromTable(Clock.Second)
end

function Clock:getGameTime()

    return {
        day = Clock:getDayOfWeek(),
        hour = Clock:getHour(),
        minute = Clock:getMinute(),
        second = Clock:getSecond()
    }
end

function Clock:getTimeOfDay()
    local hour = Clock:getHour()
    if hour >= Clock.TimeOfDay.Morning.start and hour < Clock.TimeOfDay.Morning.finish then
        return Clock.TimeOfDay.Morning
    elseif hour >= Clock.TimeOfDay.Day.start and hour < Clock.TimeOfDay.Day.finish then
        return Clock.TimeOfDay.Day
    elseif hour >= Clock.TimeOfDay.Night.start or hour < Clock.TimeOfDay.Night.finish then
        return Clock.TimeOfDay.Night
    end 
end