"use strict";

const maximumBotsAllowed = 3
const pokemonTableLength = 5

// mapping of Bot ID to pokemon table
let activePokemonBots = new Set([])

function testFunction() {
    let element = document.getElementById("butt")
    element.innerText = "NEW"
    console.log(element)
}

/**
 * Creates the pokemon table element for the bot ID
 * @param {string} botId 
 * @returns {HTMLTableElement}
 */
function createPokemonTable(botId) {
    const fragment = document.createDocumentFragment()
    fragment.class = "pokemon-row"

    const pokemonTable = document.createElement("table")
    pokemonTable.className = "pokemon-table"
    pokemonTable.id = `pokemon-table-${botId}`
    const header = document.createElement("thead")
    header.className = "pokemon-table-header"
    header.id = `pokemon-table-header-${botId}`

    header.innerText = botId

    const footer = document.createElement("tfoot")
    footer.className = "pokemon-table-footer"
    footer.id = `pokemon-table-footer-${botId}`

    const body = document.createElement("tbody")
    body.className = "pokemon-table-body"
    body.id = `pokemon-table-body-${botId}`


    pokemonTable.appendChild(header)
    pokemonTable.appendChild(body)
    pokemonTable.appendChild(footer)
    fragment.appendChild(pokemonTable)
    return fragment
}

/**
 * Creates the pokemon row element
 * @param {string} name 
 * @param {string} id 
 * @param {*} health 
 * @param {*} power 
 * @returns {HTMLTableRowElement} Pokemon data as a row
 */
function createPokemonRow(name, id, health, power) {
    const fragment = document.createDocumentFragment()
    fragment.class = "pokemon-row"
    const pokemonRow = document.createElement("tr")
    pokemonRow.id = "pokemon-row"
    pokemonRow.className = "pokemon-row"

    const pokemonName = document.createElement("td")
    pokemonName.id = "pokemon-name"
    pokemonName.className = "pokemon-name"
    pokemonName.innerText = name

    const pokemonId = document.createElement("td")
    pokemonId.id = "pokemon-id"
    pokemonId.className = "pokemon-id"
    pokemonId.innerText = id

    const pokemonHealth = document.createElement("td")
    pokemonHealth.id = "pokemon-health"
    pokemonHealth.className = "pokemon-health"
    pokemonHealth.innerText = health

    const pokemonPower = document.createElement("td")
    pokemonPower.id = "pokemon-power"
    pokemonPower.className = "pokemon-power"
    pokemonPower.innerText = power

    pokemonRow.appendChild(pokemonName)
    pokemonRow.appendChild(pokemonId)
    pokemonRow.appendChild(pokemonHealth)
    pokemonRow.appendChild(pokemonPower)

    fragment.appendChild(pokemonRow)
    return fragment
}

/**
 * Create and add a new pokemon bot table to the pokemon table container
 */
function addPokemonTable() {
    let botId = document.getElementById("bot-id-entry").value
    botId = botId.trim().toLowerCase()
    if (!botId.length) {
        console.log("No bot ID specified")
        return false
    }
    if (activePokemonBots.has(botId)) {
        console.log("Table already exists")
        return
    }

    if(activePokemonBots.size == maximumBotsAllowed) {
        console.log("Bot limit aleady reached")
        return
    }

    const table = createPokemonTable(botId)
    const pokemonTableContainer = document.getElementById("pokemon-table-container")
    pokemonTableContainer.appendChild(table)

    activePokemonBots.add(botId)
}

/**
 * Creates and adds a pokemon row to the appropriate pokemon bot dashboard
 */
function addPokemonRowToTable() {
    let botId = document.getElementById("bot-id-entry").value
    botId = botId.trim().toLowerCase()
    if (!botId.length) {
        console.log("No bot ID specified")
        return false
    }
    if (!(activePokemonBots.has(botId))) {
        console.log("Table doesnt exists")
        return
    }
    let tableID = `pokemon-table-${botId}`
    console.log(tableID)
    let tableContainer = document.getElementById("pokemon-table-container")
    let table = tableContainer.querySelector(`#${tableID}`)
    let tbody = table.getElementsByTagName('tbody')[0];
    let row = createPokemonRow("Pikachu", 25, 50, 20)
    tbody.prepend(row)
    
    while (tbody.rows.length > pokemonTableLength) {
        tbody.deleteRow(pokemonTableLength)
    }
}

/**
 * Remove the table from the DOM
 * @returns 
 */
function removePokemonTable() {
    let botId = document.getElementById("bot-id-entry").value
    botId = botId.trim().toLowerCase()
    if (!botId.length) {
        console.log("No bot ID specified")
        return false
    }
    console.log(activePokemonBots)
    if (!(activePokemonBots.has(botId))) {
        console.log("Table doesnt exists")
        return
    }

    let tableID = `pokemon-table-${botId}`
    let table = document.getElementById(tableID)
    table.remove()
    activePokemonBots.delete(botId)
}

function addElement() {
    var  container = document.getElementById("tableID")
    container = container.getElementById("mainBody")
    var row = container.insertRow();
    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);

    cell1.innerText = "1"
    cell2.innerText = "2"
    cell3.innerText = "3"
}