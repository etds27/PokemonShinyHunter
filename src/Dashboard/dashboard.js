"use strict";

const maximumBotsAllowed = 3
const pokemonTableLength = 10

const host = "http://127.0.0.1:8000"

// mapping of Bot ID to pokemon table
let activePokemonBots = new Set([])

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
                for (let encounter of botPayload["encounters"]) {
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
                for (let encounter of botPayload["encounters"]) {
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
            const updatedBotIds = new Set(initData["bot_ids"])
            for (let botID of updatedBotIds) {
                if (doesBotIDExist(botID)) {
                    continue
                }
                console.debug("updateActiveBots: Adding: " + botID)
                addPokemonTable(botID)
            }
            console.log(activePokemonBots, updatedBotIds)
            for (let botID of activePokemonBots) {
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
    if (!(activePokemonBots.has(botID))) {
        console.debug("Table doesnt exists")
        return false
    }
    return true
}

/**
 * Create and add a new pokemon bot table to the pokemon table container
 */
function addPokemonTable(botID) {
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
    activePokemonBots.add(botID)
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
    
    while (tbody.rows.length > pokemonTableLength) {
        tbody.deleteRow(pokemonTableLength)
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
    
    while (tbody.rows.length > pokemonTableLength) {
        tbody.deleteRow(pokemonTableLength)
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