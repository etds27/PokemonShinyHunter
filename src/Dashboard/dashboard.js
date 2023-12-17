"use strict";

const maximumBotsAllowed = 3
const pokemonTableLength = 5

const host = "http://127.0.0.1:8000"

const DEFAULT_BATTLE_ICONS = ""
const DEFAULT_PARTY_ICONS = ""
const DEFAULT_GAME_NAME = "POKEMON"
const TICKER_POKEMON_PER_SECOND = 5

// mapping of Bot ID to pokemon table
let activePokemonBots = {}

/**
 * Accepts new encounter data and populates the newest encounter row
 */
function encounter() {
    $.ajax({
        method: "GET",
        url: host + "/encounters",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(encounters) {
            for (let botPayload of encounters) {
                let botID = botPayload["bot_id"]
                let encounters = botPayload["encounters"]
                for (let i = encounters.length - 1; i >= 0; i--) {
                    let encounter = encounters[i]
                    if (!doesBotIDExist(botID)) {
                        return false
                    }
                    encounter["bot_id"] = botID
                    addEncounterRowToTable(encounter)
                }
            }
        }
    })
}

/**
 * Accepts new encounter data and populates the newest encounter row
 */
function shiny() {
    $.ajax({
        method: "GET",
        url: host + "/shiny_log",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(encounters) {
            for (let botPayload of encounters) {
                let botID = botPayload["bot_id"]
                let encounters = botPayload["encounters"]
                for (let i = encounters.length - 1; i >= 0; i--) {
                    let encounter = encounters[i]
                    if (!doesBotIDExist(botID)) {
                        return false
                    }
                    encounter["bot_id"] = botID
                    addShinyRowToTable(encounter)
                }
            }
        }   
    })
}

/**
 * Accepts new encounter data and populates the newest encounter row
 */
function phase() {
    $.ajax({
        method: "GET",
        url: host + "/phase_info",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(phases) {
            for (let botPayload of phases) {
                let botID = botPayload["bot_id"]
                if (!doesBotIDExist(botID)) {
                    return false
                }
                updateCurrentPhaseInfo(botPayload)
            }
        }   
    })
}

/**
 * Accepts new encounter data and populates the newest encounter row
 */
function gameStats() {
    $.ajax({
        method: "GET",
        url: host + "/game_stats",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(gameStats) {
            for (let botPayload of gameStats) {
                let botID = botPayload["bot_id"]
                if (!doesBotIDExist(botID)) {
                    return false
                }
                updateGameStatsInfo(botPayload)
            }
        }   
    })
}

/**
 * Accepts new request for pokemon table and creates html elements for it
 */
function updateActiveBots() {
    $.ajax({
        method: "GET",
        url: host + "/active_bots",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(initData) {
            const botData = initData["bots"]
            const updatedBotIds = new Set(Object.keys(botData))
            for (let botID in botData) {
                const botOptions = botData[botID]
                if (doesBotIDExist(botID)) {
                    continue
                }
                console.debug("updateActiveBots: Adding: " + botID)
                addPokemonTable(botID, botOptions)
            }
            for (let botID in activePokemonBots) {
                if (!updatedBotIds.has(botID)) {
                    if (!doesBotIDExist(botID)) {
                        continue
                    }
                    console.log("updateActiveBots: Removing: " + botID)

                    removePokemonTable(botID)
                }
            }
        }
    })
}

/**
 * Accepts new request for pokemon table and creates html elements for it
 */
function collection() {
    $.ajax({
        method: "GET",
        url: host + "/collection",
        crossDomain: true,
        dataType: "json",
        format: "json",
        timeout: 1000,
        success: function(collections) {
            for (let collection of collections) {
                let botID = collection["bot_id"]
                if (!doesBotIDExist(botID)) {
                    return false
                }
                updateCollection(collection)
            }
        }   
    })
}

/**
 * Determine if we already have a table for the specified bot
 * @param {string} botID ID of bot to verify
 * @returns {bool} If the bot ID already has a table
 */
function doesBotIDExist(botID) {
    if (!botID.length) {
        console.error("No bot ID specified")
        return false
    }
    if (!(botID in activePokemonBots)) {
        console.debug("Table doesnt exists")
        return false
    }
    return true
}

/**
 * Create and add a new pokemon bot table to the pokemon table container
 */
function addPokemonTable(botID, options) {
    botID = botID.trim()
    if (doesBotIDExist(botID)) {
        return false
    }

    if(activePokemonBots.size == maximumBotsAllowed) {
        console.log("Bot limit aleady reached")
        return
    }

    activePokemonBots[botID] = {
        battleIconType: options["battle-icon"] || DEFAULT_BATTLE_ICONS,
        partyIconType: options["party-icon"] || DEFAULT_PARTY_ICONS,
        gameName: options["game_name"] || DEFAULT_GAME_NAME
    }

    console.log(`Creating bot area for: ${botID}`)
    const table = createPokemonBotArea(botID)
    const pokemonTableContainer = document.getElementById("pokemon-table-container")
    pokemonTableContainer.appendChild(table)
    console.debug(table)
}

/**
 * Creates and adds a pokemon row to the appropriate pokemon bot dashboard
 */
function addEncounterRowToTable(encounterData) {
    let botID = encounterData["bot_id"]
    botID = botID.trim()
    if (!doesBotIDExist(botID)) {
        return false
    }
    let table = document.getElementById(`encounter-table-${botID}`)
    let tbody = table.getElementsByTagName('tbody')[0];
    let row = createEncounterRow(encounterData)
    if (!row) {
        return
    }

    const headerRow = document.getElementById(`encounter-table-column-header-row-${botID}`)
    tbody.insertBefore(row, headerRow.nextSibling)
    
    while (tbody.rows.length > pokemonTableLength + 1) {
        tbody.deleteRow(pokemonTableLength + 1)
    }
}

/**
 * Creates and adds a pokemon row to the appropriate pokemon bot dashboard
 */
function addShinyRowToTable(encounterData) {
    let botID = encounterData["bot_id"]
    botID = botID.trim()
    if (!doesBotIDExist(botID)) {
        return false
    }
    let table = document.getElementById(`shiny-table-${botID}`)
    let tbody = table.getElementsByTagName('tbody')[0];
    let row = createShinyRow(encounterData)
    if (!row) {
        return
    }

    const headerRow = document.getElementById(`shiny-table-column-header-row-${botID}`)
    tbody.insertBefore(row, headerRow.nextSibling)
    
    while (tbody.rows.length > pokemonTableLength + 1) {
        tbody.deleteRow(pokemonTableLength + 1)
    }
}

/**
 * Deletes the pokemon table when the bot terminates
 * @param {string} botID 
 * @returns 
 */
function removePokemonTable(botID) {
    botID = botID.trim()
    if (!doesBotIDExist(botID)) {
        return false
    }

    let tableID = `bot-area-${botID}`
    let table = document.getElementById(tableID)
    table.remove()
    activePokemonBots.delete(botID)
}

function updatePokemonTimestamps() {
    for (let element of document.getElementsByClassName("epoch-min-time-element")) {
        const timestamp = $(element).data("timestamp")
        const value = getElapsedDateAsString(timestamp)
        element.innerHTML = getElapsedDateAsString(timestamp)
    }

    for (let element of document.getElementsByClassName("epoch-full-time-element")) {
        const timestamp = $(element).data("timestamp")
        const formatOptions = $(element).data("formatOptions")
        element.innerHTML = getFullElapsedDateAsString(timestamp, formatOptions)
    }
    
    for (let element of document.getElementsByClassName("elapsed-min-time-element")) {
        const timestamp = $(element).data("timestamp")
        element.innerHTML = getElapsedTimeAsString(timestamp)
    }

    for (let element of document.getElementsByClassName("elapsed-full-time-element")) {
        const timestamp = $(element).data("timestamp")
        const formatOptions = $(element).data("formatOptions")
        element.innerHTML = getFullElapsedTimeAsString(timestamp, formatOptions)
    }
}


function updateCurrentPhaseInfo(phaseData) {
    let botID = phaseData["bot_id"]
    let element = document.getElementById(`current-phase-time-${botID}`)
    $(element).data("timestamp", phaseData["start_timestamp"])

    element = document.getElementById(`current-phase-encounters-${botID}`)
    element.innerText = phaseData["total_encounters"].toLocaleString()

    element = document.getElementById(`weak-pokemon-species-${botID}`)
    if ("id" in phaseData["weakest_pokemon"]) {
        element.style.visibility = "visible"  
        element.src = getPokemonSpritePath(phaseData["weakest_pokemon"]["id"], activePokemonBots[botID]["battleIconType"], false)
    } else {
        element.style.visibility = "hidden"
    }

    element = document.getElementById(`weak-pokemon-value-${botID}`)
    if ("strength" in phaseData["weakest_pokemon"]) {
        element.style.visibility = "visible"  
        element.innerText = phaseData["weakest_pokemon"]["strength"]
    } else {
        element.style.visibility = "hidden"
    }

    element = document.getElementById(`strong-pokemon-species-${botID}`)
    if ("id" in phaseData["strongest_pokemon"]) {
        element.style.visibility = "visible"  
        element.src = getPokemonSpritePath(phaseData["strongest_pokemon"]["id"], activePokemonBots[botID]["battleIconType"], false)
    } else {
        element.style.visibility = "hidden"
    }

    element = document.getElementById(`strong-pokemon-value-${botID}`)
    if ("strength" in phaseData["strongest_pokemon"]) {
        element.style.visibility = "visible"    
        element.innerText = phaseData["strongest_pokemon"]["strength"]
    } else {
        element.style.visibility = "hidden"
    }

    element = document.getElementById(`current-phase-container-pokemon-${botID}`)

    // Remove the existing sprites if they shouldn't be displayed
    let existingElements = document.getElementsByClassName(`current-phase-pokemon-${botID}`)
    for (var i = existingElements.length - 1; i >=0; i--) {
        let existingElement = existingElements[i]
        if (!(phaseData["pokemon_seen"].map(getPokemonId).includes($(existingElement).data("speciesId")))) {
            console.debug(`Removing Element ${existingElement.id}`)
            existingElement.remove()
        }
    }

    // Display the sprites of the pokemon_seen
    for (var i = 0; i < phaseData["pokemon_seen"].length; i++) {
        const pokemonInfo = phaseData["pokemon_seen"][i]
        const pokemonId = getPokemonId(pokemonInfo)
        let pokemonElement = document.getElementById(`current-phase-pokemon-${botID}-${pokemonId}`)
        if (pokemonElement) {
            continue
        }
        pokemonElement = createPokemonSprite(pokemonInfo, activePokemonBots[botID]["battleIconType"], 48)
        pokemonElement.id = `current-phase-pokemon-${botID}-${pokemonId}`
        pokemonElement.classList.add(`current-phase-pokemon-${botID}`)
        $(pokemonElement).data("speciesId", pokemonId)
        element.appendChild(pokemonElement)
    }
}

function updateGameStatsInfo(gameStats) {
    let botID = gameStats["bot_id"]
    let element = document.getElementById(`game-stats-time-${botID}`)
    
    // The calculated start time is the current time minues the number of seconds played
    const elapsedTime = new Date().getTime() / 1000 - gameStats["total_time"]
    $(element).data("timestamp", elapsedTime)

    element = document.getElementById(`game-stats-encounters-${botID}`)
    element.innerText = gameStats["total_encounters"].toLocaleString()

    element = document.getElementById(`game-stats-shinies-${botID}`)
    element.innerText = gameStats["total_shinies"].toLocaleString()

    element = document.getElementById(`game-stats-shiny-rate-${botID}`)
    element.innerText = gameStats["shiny_rate"].toLocaleString()

    element = document.getElementById(`game-stats-weak-pokemon-species-${botID}`)
    element.src = getPokemonSpritePath(gameStats["weakest_pokemon"]["id"], activePokemonBots[botID]["battleIconType"], false)

    element = document.getElementById(`game-stats-weak-pokemon-value-${botID}`)
    element.innerText = gameStats["weakest_pokemon"]["strength"]

    element = document.getElementById(`game-stats-strong-pokemon-species-${botID}`)
    element.src = getPokemonSpritePath(gameStats["strongest_pokemon"]["id"], activePokemonBots[botID]["battleIconType"], false)

    element = document.getElementById(`game-stats-strong-pokemon-value-${botID}`)
    element.innerText = gameStats["strongest_pokemon"]["strength"]

    element = document.getElementById(`game-stats-longest-phase-${botID}`)
    element.innerText = gameStats["longest_phase"].toLocaleString()

    element = document.getElementById(`game-stats-shortest-phase-${botID}`)
    element.innerText = gameStats["shortest_phase"].toLocaleString()
}

function updateCollection(collectionData) {
    const botId = collectionData["bot_id"]
    const botTicker = document.getElementById(`ticker-${botId}`)

    const tickerDuration = `${collectionData["collection"].length * TICKER_POKEMON_PER_SECOND}s`
    document.documentElement.style.setProperty("--ticker-duration", tickerDuration);

    for (let pokemonData of collectionData["collection"]) {
        const pokemonId = getPokemonId(pokemonData["id"])
        let element = document.getElementById(`pokemon-ticker-element-${pokemonId}-${botId}`)
        if (!(element)) {
            element = createPokemonTickerElement(botId, pokemonData)
            botTicker.appendChild(element)
            element = document.getElementById(`pokemon-ticker-element-${pokemonId}-${botId}`)
        }

        $(element).find(`.pokemon-ticker-element-left-number`).innerText = pokemonData["number_caught"]
        if (pokemonData["number_caught"] >= pokemonData["number_required"]) {
            const sprite = $(element).find(".pokemon-ticker-sprite")[0]
            sprite.classList.remove("gray-image")
        }
    }
}

setInterval(() => {
    // console.log(host + "/active_bots")
    updateActiveBots()
}, 2000);

setInterval(() => {
    // console.log(host + "/encounters")
    encounter()
}, 1000);

setInterval(() => {
    // console.log(host + "/shiny")
    shiny()
}, 1000);

setInterval(() => {
    updatePokemonTimestamps()
}, 1000)

setInterval(() => {
    phase()
}, 2000)

setInterval(() => {
    gameStats()
}, 2000)

setInterval(() => {
    collection()
}, 2000)