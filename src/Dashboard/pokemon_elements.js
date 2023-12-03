const shinyTableHeaders = ["Time", "", "Phase", "Species", "Total"]
const encounterTableHeaders = ["ID", "", "Lvl", "HP", "Atk", "Def", "SPE", "SP", "Sum"]



/**
 * Creates the area that will house the shiuny and encounter tables
 * @param {string} botID 
 * @returns {HTMLDivElement}
 */
function createPokemonBotArea(botID) {
    const fragment = document.createDocumentFragment()
    fragment.class = "pokemon-bot-area"

    const botAreaElement = document.createElement("div")
    botAreaElement.className = "pokemon-bot-area"
    botAreaElement.id = `bot-area-${botID}`

    const streamViewPort = document.createElement("div")
    streamViewPort.className = "stream-view-port"

    const pokemonTableElement = document.createElement("div")
    pokemonTableElement.classList = "pokemon-table-area"
    
    const shinyTable = createShinyTable(botID)
    const encounterTable = createEncounterTable(botID)

    const scollingTicker = document.createElement("div")
    scollingTicker.innerText = "SCROLLING BANNER"
    scollingTicker.class = "scrolling-ticker"

    pokemonTableElement.appendChild(shinyTable)
    pokemonTableElement.appendChild(encounterTable)

    botAreaElement.appendChild(streamViewPort)
    botAreaElement.appendChild(pokemonTableElement)
    botAreaElement.appendChild(scollingTicker)



    fragment.appendChild(botAreaElement)
    return fragment
}

/**
 * Creates the shiny table element for the bot ID
 * @param {string} botID 
 * @returns {HTMLTableElement}
 */
function createShinyTable(botID) {
    const fragment = document.createDocumentFragment()

    const pokemonTable = document.createElement("table")
    pokemonTable.className = "shiny-table"
    pokemonTable.id = `shiny-table-${botID}`
    const header = document.createElement("thead")
    header.className = "shiny-table-header"
    header.id = `shiny-table-header-${botID}`
    const headerTr = document.createElement("tr")

    headerTr.colSpan = 5
    headerTr.innerText = "SHINY " + botID

    header.appendChild(headerTr)

    const footer = document.createElement("tfoot")
    footer.className = "shiny-table-footer"
    footer.id = `shiny-table-footer-${botID}`

    const body = document.createElement("tbody")
    body.className = "shiny-table-body"
    body.id = `shiny-table-body-${botID}`

    
    const columnHeaderRow = document.createElement("tr")
    columnHeaderRow.className = "shiny-table-column-header-row"
    columnHeaderRow.id = `shiny-table-column-header-row-${botID}`

    for (let columnHeaderText of shinyTableHeaders) {
        const columnHeader = document.createElement("th")
        columnHeader.className = "shiny-table-column-header"
        columnHeader.innerText = columnHeaderText
        columnHeaderRow.appendChild(columnHeader)
    }

    body.appendChild(columnHeaderRow)

    pokemonTable.appendChild(header)
    pokemonTable.appendChild(body)
    pokemonTable.appendChild(footer)
    fragment.appendChild(pokemonTable)
    return fragment
}

/**
 * Creates the pokemon table element for the bot ID
 * @param {string} botID 
 * @returns {HTMLTableElement}
 */
function createEncounterTable(botID) {
    const fragment = document.createDocumentFragment()
    fragment.class = "encounter-table"

    const pokemonTable = document.createElement("table")
    pokemonTable.className = "encounter-table"
    pokemonTable.id = `encounter-table-${botID}`
    const header = document.createElement("thead")
    header.className = "encounter-table-header"
    header.id = `encounter-table-header-${botID}`

    header.innerText = "ENCOUNTER " + botID

    const footer = document.createElement("tfoot")
    footer.className = "encounter-table-footer"
    footer.id = `encounter-table-footer-${botID}`

    const body = document.createElement("tbody")
    body.className = "encounter-table-body"
    body.id = `encounter-table-body-${botID}`

    const columnHeaderRow = document.createElement("tr")
    columnHeaderRow.className = "encounter-table-column-header-row"
    columnHeaderRow.id = `encounter-table-column-header-row-${botID}`

    for (let columnHeaderText of encounterTableHeaders) {
        const columnHeader = document.createElement("th")
        columnHeader.className = "encounter-table-column-header"
        columnHeader.innerText = columnHeaderText
        columnHeaderRow.appendChild(columnHeader)
    }

    body.appendChild(columnHeaderRow)

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
function createEncounterRow(encounterObject) {
    const encounterId = encounterObject["encounter_id"]
    const botId = encounterObject["bot_id"]
    const pokemonObject = encounterObject["pokemon_data"]

    // Check if the element already exists, i.e if the encounter is already being displayed
    const encounterElementId = `encounter-id-${encounterId}-${botId}`
    if (document.getElementById(encounterElementId)) {
        console.log("Encounter already displayed: " + encounterElementId)
        return false
    }

    const fragment = document.createDocumentFragment()
    fragment.class = "encounter-row"

    const pokemonRow = document.createElement("tr")
    pokemonRow.id = `encounter-row-${encounterId}-${botId}`
    pokemonRow.className = "encounter-row"

    const encounterIdElement = document.createElement("td")
    encounterIdElement.id = encounterElementId
    encounterIdElement.className = "encounter-id"
    encounterIdElement.innerText = encounterId

    const pokemonSpecies = document.createElement("td")
    pokemonSpecies.id = `encounter-species-${encounterId}-${botId}`
    pokemonSpecies.className = "encounter-species"
    pokemonSpecies.innerText = pokemonObject["species"]

    const pokemonId = document.createElement("td")
    pokemonId.id = `encounter-level-${encounterId}-${botId}`
    pokemonId.className = "encounter-level"
    pokemonId.innerText = pokemonObject["level"]

    const pokemonHealthIv = document.createElement("td")
    pokemonHealthIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonHealthIv.className = "encounter-health-iv"
    pokemonHealthIv.innerText = pokemonObject["healthIv"]

    const pokemonAttackIv = document.createElement("td")
    pokemonAttackIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonAttackIv.className = "encounter-health-iv"
    pokemonAttackIv.innerText = pokemonObject["attackIv"]

    const pokemonDefenseIv = document.createElement("td")
    pokemonDefenseIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonDefenseIv.className = "encounter-health-iv"
    pokemonDefenseIv.innerText = pokemonObject["defenseIv"]

    const pokemonSpeedIv = document.createElement("td")
    pokemonSpeedIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonSpeedIv.className = "encounter-health-iv"
    pokemonSpeedIv.innerText = pokemonObject["speedIv"]

    const pokemonSpecialIv = document.createElement("td")
    pokemonSpecialIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonSpecialIv.className = "encounter-health-iv"
    pokemonSpecialIv.innerText = pokemonObject["specialIv"]

    const pokemonSumIv = document.createElement("td")
    pokemonSumIv.id = `encounter-sum-iv-${encounterId}-${botId}`
    pokemonSumIv.className = "encounter-sum-iv"
    pokemonSumIv.innerText = pokemonObject["totalIv"]

    pokemonRow.appendChild(encounterIdElement)
    pokemonRow.appendChild(pokemonSpecies)
    pokemonRow.appendChild(pokemonId)
    pokemonRow.appendChild(pokemonHealthIv)
    pokemonRow.appendChild(pokemonAttackIv)
    pokemonRow.appendChild(pokemonDefenseIv)
    pokemonRow.appendChild(pokemonSpeedIv)
    pokemonRow.appendChild(pokemonSpecialIv)
    pokemonRow.appendChild(pokemonSumIv)
        
    fragment.appendChild(pokemonRow)
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
function createShinyRow(shinyObject) {
    const shinyId = shinyObject["encounter_data"]["encounter_id"]
    const botId = shinyObject["bot_id"]
    const encounterObject = shinyObject["encounter_data"]
    const pokemonObject = shinyObject["pokemon_data"]
    const timestamp = shinyObject["timestamp"]

    // Check if the element already exists, i.e if the shiny is already being displayed
    const shinyElementId = `shiny-row-${shinyId}-${botId}`
    if (document.getElementById(shinyElementId)) {
        console.log("Encounter already displayed: " + shinyElementId)
        updateShinyRowTime(shinyElementId, timestamp)
        return false
    }

    const fragment = document.createDocumentFragment()
    fragment.class = "shiny-row"

    const pokemonRow = document.createElement("tr")
    pokemonRow.id = `shiny-row-${shinyId}-${botId}`
    pokemonRow.className = "shiny-row"

    const shinyTime = document.createElement("td")
    shinyTime.id = `shiny-time-${shinyId}-${botId}`
    shinyTime.className = "shiny-time"
    shinyTime.innerText = getElapsedTimeAsString(timestamp)
    // Store the timestamp to be retrieved later to update
    $(shinyTime).data("timestamp", timestamp)


    const pokemonSpecies = document.createElement("td")
    pokemonSpecies.id = `shiny-species-${shinyId}-${botId}`
    pokemonSpecies.className = "shiny-species"
    pokemonSpecies.innerText = pokemonObject["species"]

    const phaseEncounters = document.createElement("td")
    phaseEncounters.id = `shiny-phase-encounters-${shinyId}-${botId}`
    phaseEncounters.className = "shiny-phase-encounters"
    phaseEncounters.innerText = encounterObject["phase_encounters"].toLocaleString()

    const speciesPhaseEncounters = document.createElement("td")
    speciesPhaseEncounters.id = `shiny-species-phase-encounters-${shinyId}-${botId}`
    speciesPhaseEncounters.className = "shiny-species-phase-encounters"
    speciesPhaseEncounters.innerText = encounterObject["phase_species_encounters"].toLocaleString()

    const speciesTotalEncounters = document.createElement("td")
    speciesTotalEncounters.id = `shiny-species-total-encounters-${shinyId}-${botId}`
    speciesTotalEncounters.className = "shiny-species-total-encounters"
    speciesTotalEncounters.innerText = encounterObject["total_species_encounters"].toLocaleString()

    pokemonRow.appendChild(shinyTime)
    pokemonRow.appendChild(pokemonSpecies)
    pokemonRow.appendChild(phaseEncounters)
    pokemonRow.appendChild(speciesPhaseEncounters)
    pokemonRow.appendChild(speciesTotalEncounters)
        
    fragment.appendChild(pokemonRow)
    return fragment
}

function updateShinyRowTime(id, timestamp) {
    const row = document.getElementById(id)
    const timeElement = row.getElementsByClassName("shiny-time")[0]
    timeElement.innerHTML = getElapsedTimeAsString(timestamp)
}


function getElapsedTimeAsString(timestamp) {
    const now = new Date().getTime() / 1000
    const elapsedTime = now - timestamp
    console.log(now, timestamp, elapsedTime)
    if (elapsedTime > 24 * 60 * 60) {
        return `${Math.floor(elapsedTime / (24 * 60 * 60))}D`
    } else if (elapsedTime > 60 * 60) {
        return `${Math.floor(elapsedTime / (60 * 60))}H`
    } else if (elapsedTime > 60) {
        return `${Math.floor(elapsedTime / 60)}M`
    } else {
        return `${Math.floor(elapsedTime)}S`
    }
}