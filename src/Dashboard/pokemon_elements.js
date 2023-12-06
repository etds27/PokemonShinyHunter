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
    
    const currentPhaseArea = createCurrentPhaseArea(botID)
    const shinyTable = createShinyTable(botID)
    const encounterTable = createEncounterTable(botID)

    const scollingTicker = document.createElement("div")
    scollingTicker.innerText = "SCROLLING BANNER"
    scollingTicker.class = "scrolling-ticker"

    pokemonTableElement.appendChild(shinyTable)
    pokemonTableElement.appendChild(encounterTable)

    botAreaElement.appendChild(streamViewPort)
    botAreaElement.appendChild(currentPhaseArea)
    botAreaElement.appendChild(pokemonTableElement)
    botAreaElement.appendChild(scollingTicker)

    fragment.appendChild(botAreaElement)
    return fragment
}

/**
 * Presents the following information
 * Phase Time Duration
 * Phase Encounter Total
 * Current Bot Mode
 * Phase IV Extremes
 * Pokemon Seen In Phase
 * 
 * @param {string} botID 
 * @returns 
 */
function createCurrentPhaseArea(botID) {
    const fragment = document.createDocumentFragment()

    const pokemonTable = document.createElement("table")
    pokemonTable.className = "current-phase-table"
    pokemonTable.id = `current-phase-table-${botID}`
    const header = document.createElement("thead")
    header.className = "current-phase-table-header"
    header.id = `current-phase-table-header-${botID}`
    const headerTr = document.createElement("tr")
    const headerTd = document.createElement("td")

    headerTd.innerText = "Current Phase " + botID
    headerTd.colSpan = 2
    headerTr.appendChild(headerTd)

    header.appendChild(headerTr)

    const footer = document.createElement("tfoot")
    footer.className = "current-phase-table-footer"
    footer.id = `current-phase-table-footer-${botID}`

    const body = document.createElement("tbody")
    body.className = "current-phase-table-body"
    body.id = `current-phase-table-body-${botID}`

    // Elapsed Phase Time
    let row = body.insertRow()
    let col = document.createElement("td")
    col.className = "current-phase-header"
    col.id = `current-phase-header-time-${botID}`
    col.innerText = "Elapsed Phase Time:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-time-${botID}`
    col.innerText = "0s"
    row.appendChild(col)

    // Total Phase Encounters
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "current-phase-header"
    col.id = `current-phase-header-encounters-${botID}`
    col.innerText = "Total Phase Encounters:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-encounters-${botID}`
    col.innerText = "0"
    row.appendChild(col)

    // Current Bot Mode
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "current-phase-header"
    col.id = `current-phase-header-mode-${botID}`
    col.innerText = "Current Bot Mode:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-mode-${botID}`
    col.innerText = "Walking"
    row.appendChild(col)

    // IV Extremes
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-container-weak-${botID}`
    let div = document.createElement("div")
    div.className = "horizontal-phase-box"

    const weakSpecies = document.createElement("div")
    weakSpecies.className = "weak-pokemon-species"
    weakSpecies.id = `weak-pokemon-species-${botID}`
    const weakValue = document.createElement("div")
    weakValue.classList = "weak-pokemon-value"
    weakValue.id = `weak-pokemon-value-${botID}`
    div.appendChild(weakSpecies)
    div.appendChild(weakValue)
    col.appendChild(div)
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-container-strong-${botID}`
    div = document.createElement("div")
    div.className = "horizontal-phase-box"
    const strongSpecies = document.createElement("div")
    strongSpecies.className = "strong-pokemon-species"
    strongSpecies.id = `strong-pokemon-species-${botID}`
    const strongValue = document.createElement("div")
    strongValue.classList = "strong-pokemon-value"
    strongValue.id = `strong-pokemon-value-${botID}`
    div.appendChild(strongSpecies)
    div.appendChild(strongValue)
    col.appendChild(div)
    row.appendChild(col)

    // Phase Pokemon Seen
    row = body.insertRow()
    col = document.createElement("td")
    col.colSpan = 2
    div = document.createElement("div")
    div.id = `current-phase-container-pokemon-${botID}`
    div.className = "horizontal-phase-box"
    col.appendChild(div)
    row.appendChild(col)

    pokemonTable.appendChild(header)
    pokemonTable.appendChild(body)
    pokemonTable.appendChild(footer)
    fragment.appendChild(pokemonTable)
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

function createPokemonSprite(species, spriteType = DEFAULT_BATTLE_ICONS, size = 16, shiny = false) {
    const image = document.createElement("img")
    let filename = ""
    if (shiny) {
        filename = `${spriteType}_shiny.png`
    } else {
        filename = `${spriteType}.png`
    }
    image.src = `/resources/sprites/${species}/${filename}`
    image.className = `pokemon-sprite-${size}`
    image.alt = species
    return image
}


function getElapsedTimeAsString(timestamp) {
    const now = new Date().getTime() / 1000
    const elapsedTime = now - timestamp
    console.log(now, timestamp, elapsedTime)
    if (elapsedTime > 24 * 60 * 60) {
        return `${Math.floor(elapsedTime / (24 * 60 * 60))}D`
    } else if (elapsedTime > 60 * 60) {
        return `${Math.floor(elapsedTime / (60 * 60))}h`
    } else if (elapsedTime > 60) {
        return `${Math.floor(elapsedTime / 60)}m`
    } else {
        return `${Math.floor(elapsedTime)}s`
    }
}

function getFullElapsedTimeAsString(timestamp) {
    const now = new Date().getTime() / 1000
    let elapsedTime = now - timestamp
    console.log(now, timestamp, elapsedTime)
    const years = Math.floor(elapsedTime / (365 * 24 * 60 * 60))
    elapsedTime = elapsedTime % (365 * 24 * 60 * 60)
    const days = Math.floor(elapsedTime / (24 * 60 * 60))
    elapsedTime = elapsedTime % (24 * 60 * 60)
    const hours = Math.floor(elapsedTime / (60 * 60))
    elapsedTime = elapsedTime % (60 * 60)
    const minutes = Math.floor(elapsedTime / 60)
    elapsedTime =  elapsedTime % (60)
    const seconds = Math.floor(elapsedTime)

    let string = ""

    if (years > 0) {
        string += `${years}Y `
    }
    if (string || days > 0) {
        string += `${days}D `
    }
    
    if (string || hours > 0) {
        string += `${hours}h `
    }

    if (string || minutes > 0) {
        string += `${minutes}m `
    }

    if (string || seconds >0 ) {
        string += `${seconds}s `
    }

    return string
}