const shinyTableHeaders = ["Time", "", "Phase", "Species", "Total"]
const encounterTableHeaders = ["", "Lvl", "HP", "Atk", "Def", "SPE", "SP", "Sum"]

const dayColors = ['#00202e', '#003f5c', '#2c4875', '#8a508f', '#bc5090', '#ff6361', '#ff8531', '#ffa600', '#ffd380', '#ffe9c0', '#ffd380', '#ebde80', '#d6e980', '#b6e0a0', '#96d6c0', '#8bc1e0', '#86b7f0', '#80acff', '#a0c1ff', '#c0d6ff', '#c0d6ff', '#a0c1ff', '#80acff', '#86b7f0', '#8bc1e0', '#96d6c0', '#b6e0a0', '#d6e980', '#ebde80', '#ffd380', '#ffe9c0', '#ffd380', '#ffa600', '#ff8531', '#ff6361', '#bc5090', '#8a508f', '#2c4875', '#003f5c', '#00202e']
const stoplightColors = ['#FF5C5C', '#FFFF5C', '#5CFF5C']


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

    const botHeader = document.createElement("div")
    botHeader.id = `bot-header-${botID}`
    botHeader.className = "bot-header"
    botHeader.innerText = `Pokemon ${activePokemonBots[botID]["gameName"]} ${botID}`

    const botDataArea = document.createElement("div")
    botDataArea.className = "pokemon-table-area"

    const pokemonTableElement = document.createElement("div")
    pokemonTableElement.className = "pokemon-table-area"
    
    const totalGameArea = createGameStatsArea(botID)
    const currentPhaseArea = createCurrentPhaseArea(botID)
    const shinyTable = createShinyTable(botID)
    const encounterTable = createEncounterTable(botID)

    const scollingTicker = createPokemonTicker(botID)

    botDataArea.appendChild(totalGameArea)
    botDataArea.appendChild(currentPhaseArea)

    pokemonTableElement.appendChild(shinyTable)
    pokemonTableElement.appendChild(encounterTable)

    botAreaElement.appendChild(streamViewPort)
    botAreaElement.appendChild(botHeader)
    botAreaElement.appendChild(botDataArea)
    botAreaElement.appendChild(pokemonTableElement)
    botAreaElement.appendChild(scollingTicker)

    fragment.appendChild(botAreaElement)
    return fragment
}

function createPokemonTicker(botID) {
    const fragment = document.createDocumentFragment()

    const tickerWrap = document.createElement("div")
    tickerWrap.classList.add("ticker-wrap")
    tickerWrap.classList.add("pokemon-ticker-wrap")
    tickerWrap.id = `ticker-wrap-${botID}`

    const ticker = document.createElement("div")
    ticker.classList.add("ticker")
    ticker.classList.add("pokemon-ticker")
    ticker.id = `ticker-${botID}`

    tickerWrap.appendChild(ticker)
    fragment.appendChild(tickerWrap)

    return fragment
}

/**
 * Presents the following information
 * Total Playing Time
 * Total Encounters
 * Total Shinies
 * Shiny Rate
 * Longest/Shortest Phase
 * Strongest Weakest
 * 
 * @param {*} botID 
 * @returns 
 */
function createGameStatsArea(botID) {
    const fragment = document.createDocumentFragment()

    const pokemonTable = document.createElement("table")
    pokemonTable.className = "game-stats-table"
    pokemonTable.id = `game-stats-table-${botID}`
    const header = document.createElement("thead")
    header.className = "game-stats-table-header"
    header.id = `game-stats-table-header-${botID}`
    const headerTr = document.createElement("tr")
    const headerTd = document.createElement("td")

    headerTd.innerText = `Total Game Stats`
    headerTd.colSpan = 2
    headerTr.appendChild(headerTd)

    header.appendChild(headerTr)

    const footer = document.createElement("tfoot")
    footer.className = "game-stats-table-footer"
    footer.id = `game-stats-table-footer-${botID}`

    const body = document.createElement("tbody")
    body.className = "game-stats-table-body"
    body.id = `game-stats-table-body-${botID}`

    // Total Playing Time
    let row = body.insertRow()
    let col = document.createElement("td")
    col.className = "game-stats-header"
    col.id = `game-stats-header-time-${botID}`
    col.innerText = "Total Time:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-time-${botID}`
    col.classList.add("time-element")
    col.classList.add("elapsed-full-time-element")

    $(col).data("formatOptions", ["Y", "D", "H", "M"])
    col.innerText = "0s"
    row.appendChild(col)

    // Total Encounters
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "game-stats-header"
    col.id = `game-stats-header-encounters-${botID}`
    col.innerText = "Encounters:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-encounters-${botID}`
    col.innerText = "0"
    row.appendChild(col)

    // Total Shinies
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-header-shinies-${botID}`
    col.innerText = "Shinies:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-shinies-${botID}`
    col.innerText = "0"
    row.appendChild(col)

    // Shiny Rate
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-header-shiny-rate-${botID}`
    col.innerText = "Shiny Rate:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "game-stats-data"
    col.id = `game-stats-shiny-rate-${botID}`
    col.innerText = "0%"
    row.appendChild(col)

    // IV Extremes
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "game-stats-data"
    col.innerText = "IV:"
    row.appendChild(col)

    col = document.createElement("td")
    let ivRecordBox = document.createElement("div")
    ivRecordBox.className = "horizontal-phase-box"

    let div = document.createElement("div")
    div.className = "horizontal-phase-box"
    const weakSpecies = document.createElement("img")
    weakSpecies.className = "pokemon-sprite-32" 
    weakSpecies.id = `game-stats-weak-pokemon-species-${botID}`
    const weakValue = document.createElement("div")
    weakValue.classList = "weak-pokemon-value"
    weakValue.id = `game-stats-weak-pokemon-value-${botID}`
    weakValue.style.color = "red"
    div.appendChild(weakSpecies)
    div.appendChild(weakValue)
    ivRecordBox.append(div)

    div = document.createElement("div")
    div.className = "horizontal-phase-box"
    const strongSpecies = document.createElement("img")
    strongSpecies.className = "pokemon-sprite-32" 
    strongSpecies.id = `game-stats-strong-pokemon-species-${botID}`
    const strongValue = document.createElement("div")
    strongValue.classList = "strong-pokemon-value"
    strongValue.id = `game-stats-strong-pokemon-value-${botID}`
    strongValue.style.color = "green"
    div.appendChild(strongSpecies)
    div.appendChild(strongValue)
    ivRecordBox.appendChild(div)
    row.appendChild(ivRecordBox)

    // Phase Extremes
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "game-stats-data"
    col.innerText = "Phase Length:"
    row.appendChild(col)


    col = document.createElement("td")
    let phaseRecordBox = document.createElement("div")
    phaseRecordBox.className = "horizontal-phase-box"

    const longestPhase = document.createElement("div")
    longestPhase.id = `game-stats-longest-phase-${botID}`
    longestPhase.style.color = "red"
    longestPhase.style.alignSelf = "bottom"
    const shortestPhase = document.createElement("div")
    shortestPhase.id = `game-stats-shortest-phase-${botID}`
    shortestPhase.style.color = "green"
    phaseRecordBox.appendChild(longestPhase)
    phaseRecordBox.appendChild(shortestPhase)
    col.appendChild(phaseRecordBox)
    row.appendChild(col)

    pokemonTable.appendChild(header)
    pokemonTable.appendChild(body)
    pokemonTable.appendChild(footer)
    fragment.appendChild(pokemonTable)
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

    headerTd.innerText = "Current Phase Data"
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
    col.innerText = "Elapsed Time:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.classList.add("time-element")
    col.classList.add("epoch-full-time-element")
    $(col).data("timestampType", "FULL")
    $(col).data("isEpochTime", true)
    col.id = `current-phase-time-${botID}`
    col.innerText = "0s"
    row.appendChild(col)

    // Total Phase Encounters
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "current-phase-header"
    col.id = `current-phase-header-encounters-${botID}`
    col.innerText = "Encounters:"
    row.appendChild(col)

    col = document.createElement("td")
    col.className = "current-phase-data"
    col.id = `current-phase-encounters-${botID}`
    col.innerText = "0"
    row.appendChild(col)

    // IV Extremes
    row = body.insertRow()
    col = document.createElement("td")
    col.className = "current-phase-data"
    col.innerText = "IV:"
    row.appendChild(col)

    col = document.createElement("td")
    let ivRecordBox = document.createElement("div")
    ivRecordBox.className = "horizontal-phase-box"

    let div = document.createElement("div")
    div.className = "horizontal-phase-box"
    const weakSpecies = document.createElement("img")
    weakSpecies.className = "pokemon-sprite-32" 
    weakSpecies.id = `weak-pokemon-species-${botID}`
    const weakValue = document.createElement("div")
    weakValue.classList = "weak-pokemon-value"
    weakValue.id = `weak-pokemon-value-${botID}`
    weakValue.style.color = "red"
    div.appendChild(weakSpecies)
    div.appendChild(weakValue)
    ivRecordBox.append(div)

    div = document.createElement("div")
    div.className = "horizontal-phase-box"
    const strongSpecies = document.createElement("img")
    strongSpecies.className = "pokemon-sprite-32" 
    strongSpecies.id = `strong-pokemon-species-${botID}`
    const strongValue = document.createElement("div")
    strongValue.classList = "strong-pokemon-value"
    strongValue.id = `strong-pokemon-value-${botID}`
    strongValue.style.color = "green"
    div.appendChild(strongSpecies)
    div.appendChild(strongValue)
    ivRecordBox.appendChild(div)
    row.appendChild(ivRecordBox)

    // Phase Pokemon Seen
    row = body.insertRow()
    col = document.createElement("td")
    col.colSpan = 2
    col.innerText = "Pokemon Seen"
    col.style.textAlign = "center"
    row.appendChild(col)
    row = body.insertRow()
    col = document.createElement("td")
    col.colSpan = 2
    div = document.createElement("div")
    div.id = `current-phase-container-pokemon-${botID}`
    div.className = "horizontal-phase-box sprite-container"
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
    const headerTd = document.createElement("td")

    headerTd.colSpan = shinyTableHeaders.length
    headerTd.innerText = "RECENT SHINIES CAUGHT"

    headerTr.appendChild(headerTd)
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
    const headerTr = document.createElement("tr")
    const headerTd = document.createElement("td")

    headerTd.colSpan = encounterTableHeaders.length
    headerTd.innerText = "RECENT ENCOUNTERS"

    headerTr.appendChild(headerTd)
    header.appendChild(headerTr)

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
        return false
    }

    const fragment = document.createDocumentFragment()
    fragment.class = "encounter-row"

    const pokemonRow = document.createElement("tr")
    pokemonRow.id = `encounter-row-${encounterId}-${botId}`
    pokemonRow.className = "encounter-row"

    /*
    const encounterIdElement = document.createElement("td")
    encounterIdElement.id = encounterElementId
    encounterIdElement.className = "encounter-id"
    encounterIdElement.innerText = encounterId
    */

    const pokemonSpecies = document.createElement("td")
    pokemonSpecies.id = `encounter-species-${encounterId}-${botId}`
    pokemonSpecies.className = "encounter-species"
    pokemonSpecies.alt = getPokemonId(pokemonObject["id"])
    const pokemonSprite = createPokemonSprite(pokemonObject["id"], activePokemonBots[botId]["battleIconType"], 32, pokemonObject["isShiny"])
    pokemonSpecies.appendChild(pokemonSprite)

    const pokemonId = document.createElement("td")
    pokemonId.id = `encounter-level-${encounterId}-${botId}`
    pokemonId.className = "encounter-level"
    pokemonId.innerText = pokemonObject["level"]

    const pokemonHealthIv = document.createElement("td")
    pokemonHealthIv.id = `encounter-hp-iv-${encounterId}-${botId}`
    pokemonHealthIv.className = "encounter-hp-iv"
    pokemonHealthIv.innerText = pokemonObject["hpIv"]
    pokemonHealthIv.style.color = getPokemonStatColor(pokemonObject["hpIv"])

    const pokemonAttackIv = document.createElement("td")
    pokemonAttackIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonAttackIv.className = "encounter-health-iv"
    pokemonAttackIv.innerText = pokemonObject["attackIv"]
    pokemonAttackIv.style.color = getPokemonStatColor(pokemonObject["attackIv"])

    const pokemonDefenseIv = document.createElement("td")
    pokemonDefenseIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonDefenseIv.className = "encounter-health-iv"
    pokemonDefenseIv.innerText = pokemonObject["defenseIv"]
    pokemonDefenseIv.style.color = getPokemonStatColor(pokemonObject["defenseIv"])

    const pokemonSpeedIv = document.createElement("td")
    pokemonSpeedIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonSpeedIv.className = "encounter-health-iv"
    pokemonSpeedIv.innerText = pokemonObject["speedIv"]
    pokemonSpeedIv.style.color = getPokemonStatColor(pokemonObject["speedIv"])

    const pokemonSpecialIv = document.createElement("td")
    pokemonSpecialIv.id = `encounter-health-iv-${encounterId}-${botId}`
    pokemonSpecialIv.className = "encounter-health-iv"
    pokemonSpecialIv.innerText = pokemonObject["specialIv"]
    pokemonSpecialIv.style.color = getPokemonStatColor(pokemonObject["specialIv"])

    const pokemonSumIv = document.createElement("td")
    pokemonSumIv.id = `encounter-sum-iv-${encounterId}-${botId}`
    pokemonSumIv.className = "encounter-sum-iv"
    pokemonSumIv.innerText = pokemonObject["totalIv"]
    pokemonSumIv.style.color = getPokemonStatColor(pokemonObject["totalIv"], 80)
    // pokemonRow.appendChild(encounterIdElement)
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
    shinyTime.classList.add("time-element")
    shinyTime.classList.add("epoch-min-time-element")
    shinyTime.innerText = getElapsedDateAsString(timestamp)
    // Store the timestamp to be retrieved later to update
    $(shinyTime).data("timestamp", timestamp)

    const pokemonSpecies = document.createElement("td")
    pokemonSpecies.id = `shiny-species-${shinyId}-${botId}`
    pokemonSpecies.className = "shiny-species"
    pokemonSpecies.alt = pokemonObject["species"]
    const pokemonSprite = createPokemonSprite(pokemonObject["id"], activePokemonBots[botId]["battleIconType"], 32, true)
    pokemonSpecies.appendChild(pokemonSprite)

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

/**
 * Create the pokemon ticker element that will slide along the bottom of the bot area
 * 
 * pokemonData requires the following fields:
 *      id: {}
 *      number_caught: <int>
 *      number_required: <int>
 * @param {HTMLDivElement} pokemonData
 */
function createPokemonTickerElement(botId, pokemonData) {
    const fragment = document.createDocumentFragment()

    const pokemonId = getPokemonId(pokemonData["id"])

    const tickerItem = document.createElement("div")
    tickerItem.classList.add("ticker__item")

    const div = document.createElement("div")
    div.classList.add("pokemon-ticker-element")
    div.id = `pokemon-ticker-element-${pokemonId}-${botId}`

    const sprite = createPokemonSprite(pokemonData["id"], activePokemonBots[botId]["battleIconType"], 64, true)
    sprite.classList.add("pokemon-ticker-sprite")
    sprite.classList.add("gray-image")
    sprite.id = `pokemon-ticker-sprite-${pokemonId}-${botId}`

    const numberCaught = document.createElement("div")
    numberCaught.id = `pokemon-ticker-caught-${pokemonId}-${botId}`
    numberCaught.innerText = pokemonData["number_caught"]
    numberCaught.className = "pokemon-ticker-element-left-number"

    const slash = document.createElement("div")
    slash.innerText = "/"

    const numberRequired = document.createElement("div")
    numberRequired.id = `pokemon-ticker-required-${pokemonId}-${botId}`
    numberRequired.innerText = pokemonData["number_required"]
    numberRequired.className = "pokemon-ticker-element-right-number"

    div.appendChild(sprite)
    div.appendChild(numberCaught)
    div.appendChild(slash)
    div.appendChild(numberRequired)

    tickerItem.appendChild(div)

    fragment.appendChild(tickerItem)
    return fragment
}

function createPokemonSprite(pokemonData, spriteType = DEFAULT_BATTLE_ICONS, size = 16, shiny = false) {
    const image = document.createElement("img")

    image.src = getPokemonSpritePath(pokemonData, spriteType, shiny)
    image.className = `pokemon-sprite-${size}`
    image.alt = getPokemonId(pokemonData)
    return image
}

function getPokemonSpritePath(pokemonIdData, spriteType = DEFAULT_BATTLE_ICONS, shiny = false) {
    let speciesDir = getPokemonId(pokemonIdData)
    let filename = ""
    if (shiny) {
        filename = `${spriteType}_shiny.png`
    } else {
        filename = `${spriteType}.png`
    }
    return `resources/sprites/${speciesDir}/battle/${filename}`

}

/**
 * Take the pokemon identifying info from the payload and create a unique ID string
 * This ID string also matches the directory of the pokemon sprites
 * @param {Object} pokemonData 
 * @returns 
 */
function getPokemonId(pokemonData) {
    let pokemonId = ""
    pokemonId += String(pokemonData["species"]).padStart(3, '0')
    pokemonId += "_"
    pokemonId += pokemonData["name"].toLowerCase()
    if (pokemonData["variant"]) {
        pokemonId += `_${pokemonData["variant"]}`
    }
    return pokemonId
}

function getElapsedDateAsString(timestamp) {
    const now = new Date().getTime() / 1000
    return getElapsedTimeAsString(now - timestamp)
}

function getElapsedTimeAsString(elapsedTime) {
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

function getFullElapsedDateAsString(timestamp, options = ["Y", "D", "H", "M", "S"]) {
    const now = new Date().getTime() / 1000
    return getFullElapsedTimeAsString(now - timestamp, options)
}

function getFullElapsedTimeAsString(elapsedTime, options = ["Y", "D", "H", "M", "S"]) {
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

    if (years > 0 && options.includes("Y")) {
        string += `${years}Y `
    }
    if ((string || days > 0) && options.includes("D")) {
        string += `${days}D `
    }
    if ((string || hours > 0) && options.includes("H")) {
        string += `${hours}h `
    }
    if ((string || minutes > 0) && options.includes("M")) {
        string += `${minutes}m `
    }
    if ((string || seconds >0) && options.includes("S")) {
        string += `${seconds}s`
    }

    return string
}

function getCurrentTimeColors() {
    const date = new Date()
    const time = date.getHours() * 3600 + date.getMinutes() * 60 + date.getSeconds()
    const normalizedTime = time / (24 * 60 * 60)
    const baseColor = getColorFromGradient(normalizedTime, dayColors)
    const darkColor = darkenColor(baseColor, 20)
    const lightColor = brightenColor(baseColor, 20)
    const veryDarkColor = darkenColor(baseColor, 40)
    const veryLightColor = brightenColor(baseColor, 40)
    return {
        base: baseColor,
        dark: darkColor,
        light: lightColor,
        veryDark: veryDarkColor,
        veryLight: veryLightColor
    }
}

function getPokemonStatColor(stat, limit = 16) {
    return getColorFromGradient(stat / limit, stoplightColors)
}