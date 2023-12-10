"use strict";

const maximumBotsAllowed = 3
const pokemonTableLength = 5

const host = "http://127.0.0.1:8000"

const DEFAULT_BATTLE_ICONS = ""
const DEFAULT_PARTY_ICONS = ""

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
    console.log(`Creating bot area for: ${botID}`)
    const table = createPokemonBotArea(botID)
    const pokemonTableContainer = document.getElementById("pokemon-table-container")
    pokemonTableContainer.appendChild(table)
    console.debug(table)
    activePokemonBots[botID] = {
        battleIconType: options["battle-icon"] || DEFAULT_BATTLE_ICONS,
        partyIconType: options["party-icon"] || DEFAULT_PARTY_ICONS,
    }
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
    for (let element of document.getElementsByClassName("shiny-time")) {
        const timestamp = $(element).data("timestamp")
        element.innerHTML = getElapsedTimeAsString(timestamp)
    }
}

function updateCurrentPhaseInfo(phaseData) {
    let botID = phaseData["bot_id"]
    let element = document.getElementById(`current-phase-time-${botID}`)
    element.innerText = getFullElapsedTimeAsString(phaseData["start_timestamp"])

    element = document.getElementById(`current-phase-encounters-${botID}`)
    element.innerText = phaseData["total_encounters"].toLocaleString()

    element = document.getElementById(`weak-pokemon-species-${botID}`)
    element.innerText = phaseData["weakest_pokemon"]["species"]

    element = document.getElementById(`weak-pokemon-value-${botID}`)
    element.innerText = phaseData["weakest_pokemon"]["iv"]

    element = document.getElementById(`strong-pokemon-species-${botID}`)
    element.innerText = phaseData["strongest_pokemon"]["species"]

    element = document.getElementById(`strong-pokemon-value-${botID}`)
    element.innerText = phaseData["strongest_pokemon"]["iv"]

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
        $(pokemonElement).data("speciesId", pokemonId)
        element.appendChild(pokemonElement)
    }
}

function updatePokemonScrollingTicker(collectionData) {
    let botID = phaseData["bot_id"]
    // Remove the existing sprites if they shouldn't be displayed
    let existingElements = document.getElementsByClassName(`pokemon-ticker-sprite-${botID}`)

    // Display the sprites of the pokemon_seen
    for (var i = 0; i < phaseData["pokemon_seen"].length; i++) {
        const pokemonInfo = phaseData["pokemon_seen"][i]
        const pokemonId = getPokemonId(pokemonInfo)
        let pokemonElement = document.getElementById(`pokemon-ticker-sprite-${botID}-${pokemonId}`)
        if (pokemonElement) {
            continue
        }
        pokemonElement = createPokemonSprite(pokemonInfo, activePokemonBots[botID]["battleIconType"], 48)
        pokemonElement.id = `current-phase-pokemon-${botID}-${pokemonId}`
        $(pokemonElement).data("speciesId", pokemonId)
        element.appendChild(pokemonElement)
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
}, 1000)