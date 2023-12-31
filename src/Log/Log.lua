---@enum LogLevels
LogLevels = {
    OFF = {4, "OFF"},
    ERROR = {3, "ERROR"},
    WARNING = {2, "WARNING"},
    INFO = {1, "INFO"},
    DEBUG = {0, "DEBUG"}
}

Log = {
    loggingLevel = LogLevels.DEBUG
}

---Log message to the console
---@param type LogLevels
---@param message string Message to write
function Log:message(type, message) 
    -- Skip if the logging level is too high
    if type[1] < Log.loggingLevel[1] then return end  
    local timestamp = os.date("%Y-%m-%d-T%H:%M:%S")
    print(timestamp .. ": " .. type[2] .. ": " .. " ".. message)
end

function Log:error(message)
    Log:message(LogLevels.ERROR, message)
end

function Log:info(message)
    Log:message(LogLevels.INFO, message)
end

function Log:warning(message)
    Log:message(LogLevels.WARNING, message)
end

function Log:debug(message)
    Log:message(LogLevels.DEBUG, message)
end

function Log:intToLogLevel(num)
    for _, value in pairs(LogLevels)
    do
        if value[1] == num then
            return value
        end
    end
    return LogLevels.OFF
end