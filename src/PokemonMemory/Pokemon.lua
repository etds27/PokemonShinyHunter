require "Common"
require "Log"
require "Memory"

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


function Pokemon:new(pokemonType, startingAddress, memdomain)
    o = Pokemon:getPokemonTable(pokemonType, startingAddress, memdomain)
    self.__index = self
    setmetatable(o, {__index = self})
    o:determineIvs()
    o.isShiny = o:determineShininess()
    return o
end

function Pokemon:getPokemonTable(pokemonType, startingAddress, memdomain)
    pokemonTable = {
        address = startingAddress,
        pokemonType = pokemonType
    }
    for key, value in pairs(pokemonType) do
        offset = value[1]
        size = value[2]
        memValue = Memory:read(startingAddress + offset, size, memdomain)
        pokemonTable[key] = memValue
    end

    return pokemonTable
end

function Pokemon:determineIvs() 
    ivData = self.ivData
    attackIv = (ivData >> 12) & 0x000F
    defenseIv = (ivData >> 8) & 0x000F
    speedIv = (ivData >> 4) & 0x000F
    specialIv = ivData & 0x000F
    hpIv = (attackIv & 0x1) * 8 + (defenseIv & 0x1) * 4 + (speedIv & 0x1) * 2 + (specialIv & 0x1)

    self.attackIv = attackIv
    self.defenseIv = defenseIv
    self.speedIv = speedIv
    self.specialIv = specialIv
    self.hpIv = hpIv
end

function Pokemon:determineShininess()
    attackReq = Common:contains({2, 3, 6, 7, 10, 11, 14, 15}, self.attackIv)
    defenseReq = self.defenseIv == 10
    speedReq = self.speedIv == 10
    specialReq = self.specialIv == 10

    Log:debug("Shiny Attack:  " .. tostring(attackReq))
    Log:debug("Shiny Defense: " .. tostring(defenseReq))
    Log:debug("Shiny Speed:   " .. tostring(speedReq))
    Log:debug("Shiny Special: " .. tostring(specialReq))

    return speedReq and attackReq and defenseReq and specialReq
end

-- Abstract tables
local Model = {}
Model.TrainerPokemonOffsets = {}
Model.BoxPokemonOffsets = {}
Model.WildPokemonOffsets = {}
local Model = PokemonFactory:loadModel()

-- Merge model into class
Pokemon = Common:tableMerge(Pokemon, Model)

Pokemon.PokemonType = {
    TRAINER = Pokemon.TrainerPokemonOffsets,
    WILD = Pokemon.WildPokemonOffsets,
    BOX = Pokemon.BoxPokemonOffsets
}