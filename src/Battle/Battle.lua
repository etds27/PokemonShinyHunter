require "Common"
require "Factory"
require "GameSettings"
require "Input"
require "Log"
require "Memory"

---@type FactoryMap
local factoryMap = {
    CrystalBattle = {Games.CRYSTAL},
    GSBattle = GameGroups.GOLD_SILVER
}

Battle = {}

-- Abstract tables
local Model = {}
Model.Catch = {}
-- When this value is 0, we are at the start of a battle
Model.PokemonTurnCounter = {}
Model.EnemyPokemonTurnCounter = {}
Model.MenuPointer = {}
Model = Factory:loadModel(factoryMap)

-- Load in default tables

-- Merge model into class
Battle = Common:tableMerge(Battle, Model)

--- Run from the current pokemon battle
--- This assumes that the battle menu has or is loading
function Battle:runFromPokemon()

    Battle:waitForBattleMenu(100)
    Input:performButtonSequence(ButtonSequences.BATTLE_RUN)
    Input:pressButtons{buttonKeys={Buttons.B}, duration=80, waitFrames=1}
    Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.TAP}
    return Positioning:waitForOverworld(2000)
end

---Open the pack from the battle menu
function Battle:openPack()
    Battle:waitForBattleMenu(100)
    Input:performButtonSequence(ButtonSequences.BATTLE_PACK)
    Common:waitFrames(30)
end

---comment
---@param bIterations integer? Maximum number of times to press button before battle menu appears
---@return boolean true if the battle menu appears
function Battle:waitForBattleMenu(bIterations)
    bIterations = bIterations or 1000
    local i = 0
    local cursor = {x = 0, y = 0}
    while i < bIterations
    do
        cursor = Menu:getMultiCursorPosition()
        if cursor.x == Battle.MenuCursor.FIGHT.x and cursor.y == Battle.MenuCursor.FIGHT.y then
            return true
        end
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        i = i + 1
    end

    return false
end

---Determine if the pokemon was caught
---
---This will continously poll the catch status memory until it changes from
---a reset state or the maximum frame count is reached
---@return integer
---|0: Catch status wasn't updated
---|1: Pokemon was caught
---|2: Pokemon was not caught
function Battle:getCatchStatus()
    Common:waitForState(Battle.Catch, {Battle.Catch.CAUGHT, Battle.Catch.MISSED})
    return Memory:readFromTable(Battle.Catch)
end