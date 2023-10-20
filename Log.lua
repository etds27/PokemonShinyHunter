LogLevels = {
    ERROR = 3,
    WARNING = 2,
    INFO = 1,
    DEBUG = 0
}

Log = {
    loggingLevel = LogLevels.DEBUG
}



function Log:message(type, message) 
    -- Skip if the logging level is too high
    if type < Log.loggingLevel then return end
    
    -- timestamp = os.date()
    print(type .. ": " .. " ".. message)
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