PokemonMemory = {}

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

TrainerPokemonOffsets = {
    species = {0x00, 1},
    heldItem = {0x01, 1},
    move1 = {0x02, 1},
    move2 = {0x03, 1},
    move3 = {0x04, 1},
    move4 = {0x05, 1},
    trainerId = {0x06, 2},
    expPoints = {0x08, 3},
    hpEv = {0x0B, 2},
    attackEv = {0x0D, 2},
    defenseEv = {0x0F, 2},
    speedEv = {0x11, 2},
    specialEv = {0x13, 2},
    ivData = {0x15, 2},
    movePp1 = {0x17, 1},
    movePp2 = {0x18, 1},
    movePp3 = {0x19, 1},
    movePp4 = {0x1A, 1},
    friendship = {0x1B, 1},
    pokerus = {0x1C, 1},
    caughtData = {0x1D, 2},
    level = {0x1F, 1},
    status = {0x20, 1},
    currentHp = {0x22, 2},
    hpStat = {0x24, 2},
    attackStat = {0x26, 2},
    defenseStat = {0x28, 2},
    speedStat = {0x2A, 2},
    spAttackStat = {0x2C, 2},
    spDefenseStat = {0x2E, 2},
}

BoxPokemonOffsets = {
    species = {0x00, 1},
    heldItem = {0x01, 1},
    move1 = {0x02, 1},
    move2 = {0x03, 1},
    move3 = {0x04, 1},
    move4 = {0x05, 1},
    trainerId = {0x06, 2},
    expPoints = {0x08, 3},
    hpEv = {0x0B, 2},
    attackEv = {0x0D, 2},
    defenseEv = {0x0F, 2},
    speedEv = {0x11, 2},
    specialEv = {0x13, 2},
    ivData = {0x15, 2},
    movePp1 = {0x17, 1},
    movePp2 = {0x18, 1},
    movePp3 = {0x19, 1},
    movePp4 = {0x1A, 1},
    friendship = {0x1B, 1},
    pokerus = {0x1C, 1},
    caughtData = {0x1D, 2},
    level = {0x1F, 1}  
}

WildPokemonOffsets = {
    species = {0x00, 1},
    heldItem = {0x01, 1},
    move1 = {0x02, 1},
    move2 = {0x03, 1},
    move3 = {0x04, 1},
    move4 = {0x05, 1},
    ivData = {0x06, 2},
    movePp1 = {0x08, 1},
    movePp2 = {0x09, 1},
    movePp3 = {0x0A, 1},
    movePp4 = {0x0B, 1},
    friendship = {0x0C, 1},
    level = {0x0D, 1},
    status = {0x0E, 1},
    currentHp = {0x10, 2},
    hpStat = {0x12, 2},
    attackStat = {0x14, 2},
    defenseStat = {0x16, 2},
    speedStat = {0x18, 2},
    spAttackStat = {0x1A, 2},
    spDefenseStat = {0x1C, 2},
}

MemoryPokemonType = {
    TRAINER = TrainerPokemonOffsets,
    WILD = WildPokemonOffsets,
    BOX = BoxPokemonOffsets
}

function PokemonMemory:getPokemonTable(pokemonType, startingAddress, memdomain)
    pokemonTable = {
        address = startingAddress
    }
    for key, value in pairs(pokemonType) do
        offset = value[1]
        size = value[2]
        memValue = Memory:read(startingAddress + offset, size, memdomain)
        pokemonTable[key] = memValue
        --[[
        print("Key " .. key)
        -- print("StartingAddess " ..  string.format("%x", startingAddress))
        print("Offset " .. value[1])
        print("Address " .. string.format("%x", startingAddress + offset))
        print("Size " .. value[2])
        print("MemValue " .. memValue)
        -- print("-----------")
        --]]
    end
    PokemonMemory:determineIvs(pokemonTable)
    pokemonTable.isShiny = PokemonMemory:isShiny(pokemonTable)
    return pokemonTable
end

function PokemonMemory:determineIvs(pokemonTable) 
    ivData = pokemonTable.ivData
    attackIv = (ivData >> 12) & 0x000F
    defenseIv = (ivData >> 8) & 0x000F
    speedIv = (ivData >> 4) & 0x000F
    specialIv = ivData & 0x000F
    hpIv = (attackIv & 0x1) * 8 + (defenseIv & 0x1) * 4 + (speedIv & 0x1) * 2 + (specialIv & 0x1)

    pokemonTable.attackIv = attackIv
    pokemonTable.defenseIv = defenseIv
    pokemonTable.speedIv = speedIv
    pokemonTable.specialIv = specialIv
    pokemonTable.hpIv = hpIv


end

function PokemonMemory:isShiny(pokemonTable)
    attackReq = Common:contains({2, 3, 6, 7, 10, 11, 14, 15}, pokemonTable.attackIv)
    defenseReq = pokemonTable.defenseIv == 10
    speedReq = pokemonTable.speedIv == 10
    specialReq = pokemonTable.specialIv == 10

    Log:debug("Shiny Attack:  " .. tostring(attackReq))
    Log:debug("Shiny Defense: " .. tostring(defenseReq))
    Log:debug("Shiny Speed:   " .. tostring(speedReq))
    Log:debug("Shiny Special: " .. tostring(specialReq))

    return speedReq and attackReq and defenseReq and specialReq
end

function getPokemonValue(startingAddress, key) 
    -- pass
    print("nothing")
end


