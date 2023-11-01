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

local defaultSettings = readJson("..\\BotConfigs\\default.json")
-- local gameSettings = readJson("BotConfigs\\game.json")
local botSettings = readJson("..\\BotConfigs\\" .. Bot:getBotId() .. ".json")
local settings = Common:tableMerge(defaultSettings, botSettings)
Bot.mode = settings.BotMode
print(Bot.mode)
Bot:run()
