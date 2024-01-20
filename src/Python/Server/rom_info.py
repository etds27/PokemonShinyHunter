import re

DEFAULT_ROM = {
    "rom_name": "Unknown ROM",
    "rom_display_name:": "Unknown ROM"
}

KNOWN_ROM_MAP = {
    "F2F52230B536214EF7C9924F483392993E226CFB": {
        "rom_name": "Pokemon - Crystal Version (USA, Europe) (Rev A)",
        "rom_display_name": "Pokemon Crystal"
    },
    "D8B8A3600A465308C9953DFA04F0081C05BDCB94": {
        "rom_name": "Pokemon - Gold Version (USA, Europe)",
        "rom_display_name": "Pokemon Gold"        
    },
    "49B163F7E57702BC939D642A18F591DE55D92DAE": {
        "rom_name": "Pokemon - Silver Version (USA, Europe)",
        "rom_display_name": "Pokemon Silver"
    }
}

def get_rom_data(rom_hash: str):
    return KNOWN_ROM_MAP.get(rom_hash, DEFAULT_ROM)