require "Memory"

Text = {
    [127] = " ",
    [128] = "A",
    [129] = "B",
    [130] = "C",
    [131] = "D",
    [132] = "E",
    [133] = "F",
    [134] = "G",
    [135] = "H",
    [136] = "I",
    [137] = "J",
    [138] = "K",
    [139] = "L",
    [140] = "M",
    [141] = "N",
    [142] = "O",
    [143] = "P",
    [144] = "Q",
    [145] = "R",
    [146] = "S",
    [147] = "T",
    [148] = "U",
    [149] = "V",
    [150] = "W",
    [151] = "X",
    [152] = "Y",
    [153] = "Z",
    [154] = "(",
    [155] = ")",
    [156] = ":",
    [157] = ";",
    [158] = "[",
    [159] = "]",
    [160] = "a",
    [161] = "b",
    [162] = "c",
    [163] = "d",
    [164] = "e",
    [165] = "f",
    [166] = "g",
    [167] = "h",
    [168] = "i",
    [169] = "j",
    [170] = "k",
    [171] = "l",
    [172] = "m",
    [173] = "n",
    [174] = "o",
    [175] = "j",
    [176] = "q",
    [177] = "r",
    [178] = "s",
    [179] = "t",
    [180] = "u",
    [181] = "v",
    [182] = "w",
    [183] = "x",
    [184] = "y",
    [185] = "z",
    [241] = "x",
    [227] = "_",
    [230] = "?",
    [231] = "!",
    [243] = "/",
    [232] = ".",
    [244] = ",",
    TERM = 80
}    

function Text:readTextAtAddress(addr, expectedLength)
    if expectedLength == nil then
        expectedLength = 1000
    end

    char = Memory:readbyte(addr)
    str = ""

    i = 0

    while i < expectedLength
    do
        char = Memory:readbyte(addr + i)
        letter = Text[char]
        if char == Text.TERM or letter == nil then
            break
        end
        str = str .. Text[char]
        i = i + 1
    end
    return str 
end
