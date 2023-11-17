require "Common"
require "Factory"
require "Input"
require "Memory"
require "Menu"

---@type FactoryMap
local factoryMap = {
    GSPokedex = GameGroups.GOLD_SILVER,
    CrystalPokedex = {Games.CRYSTAL}
}

Pokedex = {}

-- Abstract tables
local Model = {}
Model.currentPosition = function() end
Model = Factory:loadModel(factoryMap)

-- Load in default tables

-- Merge model into class
Pokedex = Common:tableMerge(Pokedex, Model)

function Pokedex:navigateToPosition(position)
    local button = ""
    local currentPos = Pokedex:currentPosition()
    local small_button = ""
    local large_button = ""

    while true
    do
        currentPos = Pokedex:currentPosition()
        Log:debug("Current: " .. tostring(currentPos) .. " Dest: " .. tostring(position))
        if currentPos == position then 
            return true
        elseif currentPos < position then
            small_button = Buttons.DOWN
            large_button = Buttons.RIGHT
        else
            small_button = Buttons.UP
            large_button = Buttons.LEFT
        end

        if math.abs(currentPos - position) > Pokedex.maxView then
            button = large_button
        else
            button = small_button
        end
        Input:pressButtons{buttonKeys={button}, duration=2}
    end
    return Pokedex:currentPosition() == position
end

function Pokedex:currentPokemonNo()
    return Memory:readFromTable(Pokedex.pokemonNumber)
end

function Pokedex:navigateToPokemon(pokemonNo)
    local button = ""
    local currentPokemon = -1
    local direction = true
    local previousPos = -1
    local currentPos = -1
    while true
    do
        currentPokemon = Pokedex:currentPokemonNo()
        currentPos = Pokedex:currentPosition()
        if currentPos == previousPos then 
            -- If we already changed direction, then exit
            if not direction then
                return false
            end
            direction = not direction
        end
        previousPos = currentPos
        Log:debug("Current: " .. tostring(currentPokemon) .. " Dest: " .. tostring(pokemonNo) .. " Pos: " .. tostring(currentPos))
        if currentPokemon == pokemonNo then 
            return true
        elseif direction then
            button = Buttons.DOWN
        else
            button = Buttons.UP
        end

        Input:pressButtons{buttonKeys={button}, duration=16, waitFrames=1}
    end
end
