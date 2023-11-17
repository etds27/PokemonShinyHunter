require "Common"
require "Factory"
require "Log"
require "Memory"

---@type FactoryMap
local factoryMap = {
    GSCPokemon = GameGroups.GEN_2,
}

---@class Pokemon
---@field address number 
---@field attackEv number 
---@field attackStat number 
---@field caught boolean
---@field caughtData number 
---@field currentHp number 
---@field defenseEv number 
---@field defenseStat number 
---@field expPoints number 
---@field friendship number 
---@field heldItem number 
---@field hpEv number 
---@field hpStat number 
---@field isEgg function
---@field isShiny boolean
---@field ivData number 
---@field level number 
---@field move1 number 
---@field move2 number 
---@field move3 number 
---@field move4 number 
---@field movePp1 number 
---@field movePp2 number 
---@field movePp3 number 
---@field movePp4 number 
---@field pokerus number 
---@field spAttackStat number 
---@field spDefenseStat number 
---@field specialEv number 
---@field species number
---@field speedEv number 
---@field speedStat number 
---@field status number 
---@field trainerId number 

Pokemon = {
    address = -1,
    species = -1,
    heldItem = -1,
    move1 = -1,
    move2 = -1,
    move3 = -1,
    move4 = -1,
    trainerId = -1,
    expPoints = -1,
    hpEv = -1,
    attackEv = -1,
    defenseEv = -1,
    speedEv = -1,
    specialEv = -1,
    ivData = -1,
    movePp1 = -1,
    movePp2 = -1,
    movePp3 = -1,
    movePp4 = -1,
    friendship = -1,
    pokerus = -1,
    caughtData = -1,
    level = -1,
    status = -1,
    currentHp = -1,
    hpStat = -1,
    attackStat = -1,
    defenseStat = -1,
    speedStat = -1,
    spAttackStat = -1,
    spDefenseStat = -1
}

---Create a new pokemon table
---@param pokemonType PokemonType Where the pokemon is. Party, Wild, Box
---@param startingAddress address Starting address of the pokemon
---@param memdomain Memory? Domain of pokemon
---@return Pokemon
function Pokemon:new(pokemonType, startingAddress, memdomain)
    local o = {
            memoryType = pokemonType, 
            addr = startingAddress, 
            memdomain = memdomain
    }
    
    self.__index = self
    setmetatable(o, {__index = self})
    o:update()
    o:determineIvs()
    o.isShiny = o:determineShininess()
    return o
end


function Pokemon:update()
    for key, value in pairs(self.memoryType) do
        local offset = value[1]
        local size = value[2]

        ---@type string|number
        key = key
        ---@type string|number
        local memValue = Memory:read(self.addr + offset, size, self.memdomain)

        if key == "species" then memValue = tostring(memValue) end
        self[key] = memValue
    end
end

function Pokemon:determineIvs() 
    local ivData = self.ivData
    local attackIv = (ivData >> 12) & 0x000F
    local defenseIv = (ivData >> 8) & 0x000F
    local speedIv = (ivData >> 4) & 0x000F
    local specialIv = ivData & 0x000F
    local hpIv = (attackIv & 0x1) * 8 + (defenseIv & 0x1) * 4 + (speedIv & 0x1) * 2 + (specialIv & 0x1)

    self.attackIv = attackIv
    self.defenseIv = defenseIv
    self.speedIv = speedIv
    self.specialIv = specialIv
    self.hpIv = hpIv
end

function Pokemon:determineShininess()
    local attackReq = Common:contains({2, 3, 6, 7, 10, 11, 14, 15}, self.attackIv)
    local defenseReq = self.defenseIv == 10
    local speedReq = self.speedIv == 10
    local specialReq = self.specialIv == 10

    return speedReq and attackReq and defenseReq and specialReq
end

function Pokemon:isEgg(update)
    if update then
        self:update()
    end
    return self.caughtData == 0
end

---Determine how many egg cycles remain for the current pokemon
---
---This value is determined from the friendship memory address
---@return integer cycles Number of remaining egg cycles
function Pokemon:eggCyclesRemaining()
    self:update()
    if self:isEgg() then
        return self.friendship
    else
        return -1
    end
end

-- Abstract tables
local Model = {}
Model.TrainerPokemonOffsets = {}
Model.BoxPokemonOffsets = {}
Model.WildPokemonOffsets = {}
Model = Factory:loadModel(factoryMap)

-- Merge model into class
Pokemon = Common:tableMerge(Pokemon, Model)

---@enum PokemonType
Pokemon.PokemonType = {
    TRAINER = Pokemon.TrainerPokemonOffsets,
    WILD = Pokemon.WildPokemonOffsets,
    BOX = Pokemon.BoxPokemonOffsets
}