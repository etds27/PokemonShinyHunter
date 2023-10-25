require "Common"
require "GameSettings"
require "Log"
require "Memory"
require "Input"

Battle = {}

--[[
    Resets to 0 when user's turn starts
]]
Catch = {
    addr = 0x11416,
    size = 1,
    memdomain = Memory.WRAM,
    waitFrames = 700, -- 600 in testing
    RESET = 0,
    CAUGHT = 1,
    MISSED = 2
}

-- When this value is 0, we are at the start of a battle
PokemonTurnCounter = {
    addr = 0xC6DD,
    size = 1,
}

EnemyPokemonTurnCounter = {
    addr = 0xC6DC,
    size = 1,
}

BattleMenuPointer = {
    addr = GameSettings.battleCursor,
    size = 2,
    FIGHT = 257, -- 0101
    PKMN = 258,  -- 0102
    PACK = 513,  -- 0201
    RUN = 514,   -- 0202
}

function Battle:attackByIndex(moveIndex)
    --[[
    Perform an attack action by nevaigting through the fight menu and selecting the move at the specified index

    This will navigate from either the battle menu or fight menu to select the current 

    Arguements:
        - moveIndex: Number to represent the position of the move being used. Indexed at 1
    --]]
    gameState = GameState:getCurrentGameState() 
    if string.find(gameState, "battle_menu") ~= nil then
        Input:performButtonSequence(ButtonSequences.BATTLE_FIGHT)
    end
    -- print(ButtonSequences.BATTLE_FIGHT)

    gameState = GameState:getCurrentGameState()
    if string.find(gameState, "fight_menu") ~= nil then
        currentMove = Memory:readbyte(GameSettings.currentMove)
    end

    if currentMove == nil then Log.error("Unable to find current move index") end
    Log:info("Current Move: " .. currentMove .. " |  Move Index: " .. moveIndex)

    if currentMove > moveIndex then
        Input:repeatedlyPressButton{buttonKeys = {Buttons.UP}, 
                                    iterations = currentMove - moveIndex,
                                    duration = Duration.TAP,
                                    waitFrames = 20}
    elseif currentMove < moveIndex then
        Input:repeatedlyPressButton{buttonKeys = {Buttons.DOWN}, 
                                    iterations = moveIndex - currentMove,
                                    duration = Duration.TAP,
                                    waitFrames = 20}
    end

    Input:pressButtons{buttonKeys = {Buttons.A}}
end

function Battle:runFromPokemon()
    --[[
        Run from the current pokemon battle
        This assumes that the battle menu has or is loading
    ]]
    Battle:waitForBattleMenu(100)
    Input:performButtonSequence(ButtonSequences.BATTLE_RUN)
    Input:pressButtons{buttonKeys={Buttons.B}, duration=80, waitFrames=1}
    Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.TAP}
    Common:waitFrames(60) -- Wait for overworld
end

function Battle:openPack()
    Battle:waitForBattleMenu(100)
    Input:performButtonSequence(ButtonSequences.BATTLE_PACK)
    Common:waitFrames(30)
end


function Battle:waitForBattleMenu(bIterations) 
    i = 0
    while Memory:readFromTable(BattleMenuPointer) == 0 and i < bIterations
    do
        Input:pressButtons{buttonKeys={Buttons.B}, duration=Duration.PRESS}
        i = i + 1
    end

    return i < bIterations
end

function Battle:continueUntilNewTurn()

end
    

function Battle:getCatchStatus()
    --[[
        Determine if the pokemon was caught

        This will continously poll the catch status memory until it changes from
        a reset state or the maximum frame count is reached

        Returns:
            - 0: Catch status wasn't updated
            - 1: Pokemon was caught
            - 2: Pokemon was not caught
    ]]
    i = 0

    while Memory:readFromTable(Catch) == Catch.RESET and i < Catch.waitFrames
    do
        emu.frameadvance()
    end

    return Memory:readFromTable(Catch)
end

-- GameSettings.initialize()

-- Battle:attackByIndex(1)