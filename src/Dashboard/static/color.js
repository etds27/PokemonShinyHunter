
/**
 * Get the color within the gradient defined by the percent of the color and the colors definied in the gradient
 * @param {Number} percentage value between 0 and 1
 * @param {Array} colors List of RGB colors that define the gradient
 * @returns 
 */
function getColorFromGradient(percentage, colors) {
    percentage = Math.min(Math.max(percentage, 0), 1)
    if (percentage == 0) {return colors[0]}
    if (percentage == 1) {return colors[colors.length - 1]}

    const startingIndex = Math.floor(percentage * (colors.length - 1))
    const adjustedPercenage = percentage * (colors.length - 1) - startingIndex
    const color1 = colors[startingIndex]
    const color2 = colors[startingIndex + 1]

    return interpColors(adjustedPercenage, color1, color2)
}

/**
 * Calculate the color by interpolating between color1 and color2 using percentage
 * @param {Number} percentage value between 0 and 1
 * @param {*} color1 RGB starting color
 * @param {*} color2 RGB ending color
 * @returns 
 */
function interpColors(percentage, color1, color2) {
    let ret = rgbStringToChannels(color1)
    const r1 = ret.r
    const g1 = ret.g
    const b1 = ret.b

    ret = rgbStringToChannels(color2)
    const r2 = ret.r
    const g2 = ret.g
    const b2 = ret.b

    const newR = Math.floor(r1 + (r2 - r1) * percentage).toString(16).padStart(2, "0")
    const newG = Math.floor(g1 + (g2 - g1) * percentage).toString(16).padStart(2, "0")
    const newB = Math.floor(b1 + (b2 - b1) * percentage).toString(16).padStart(2, "0")
    const newColor = `#${newR}${newG}${newB}`
    return newColor
}

/**
 * Darken the color by subtracting an offset from each rgb channel
 * @param {String} color RGB Hex string color
 * @param {*} offset Value to subtract from each rgb channel
 * @returns 
 */
function darkenColor(color, offset) {
    const ret = rgbStringToChannels(color)
    const r = ret.r
    const g = ret.g
    const b = ret.b
    
    const newR = Math.max(0, r - offset).toString(16).padStart(2, "0")
    const newG = Math.max(0, g - offset).toString(16).padStart(2, "0")
    const newB = Math.max(0, b - offset).toString(16).padStart(2, "0")
    const newColor = `#${newR}${newG}${newB}`
    return newColor
}

/**
 * Brighten the color by addding an offset to each rgb channel
 * @param {String} color RGB Hex string color
 * @param {*} offset Value to add to each rgb channel
 * @returns 
 */
function brightenColor(color, offset) {
    const ret = rgbStringToChannels(color)
    const r = ret.r
    const g = ret.g
    const b = ret.b
    
    const newR = Math.min(255, r + offset).toString(16).padStart(2, "0")
    const newG = Math.min(255, g + offset).toString(16).padStart(2, "0")
    const newB = Math.min(255, b + offset).toString(16).padStart(2, "0")
    const newColor = `#${newR}${newG}${newB}`
    return newColor
}

/**
 * Convert the RGB Hex string into individual RGB channels
 * @param {String} color RGB Hex string color
 * @returns 
 */
function rgbStringToChannels(color) {
    color = color.replace("#", "")
    const r = parseInt(color.substr(0, 2) , 16)
    const g = parseInt(color.substr(2, 2) , 16)
    const b = parseInt(color.substr(4, 2) , 16)
    return {r: r, g: g, b: b}
}
  