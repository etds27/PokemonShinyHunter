require "Bot"
require "Common"
require "GameSettings"

local json = require "json"
local open = io.open

local function readJson(filepath)
    local f = open(filepath, "rb")
    if not f then return {} end

    local content = f:read "*all"
    f:close()
    return json.decode(content)
end

local botConfigsPath = os.getenv("PSH_ROOT") .. "\\BotConfigs\\"
local defaultSettings = readJson(botConfigsPath .. "default.json")
-- local gameSettings = readJson("BotConfigs\\game.json")
local botSettings = readJson(botConfigsPath ..  Bot:getBotId() .. ".json")
local settings = Common:tableMerge(defaultSettings, botSettings)
Log.loggingLevel = Log:intToLogLevel(settings.LogLevel)

-- Add logic to load ROM from here
client.setwindowsize(tonumber(settings.WindowSize))
client.speedmode(tonumber(settings.SpeedMode))

Bot.mode = settings.BotMode
Bot:run()
