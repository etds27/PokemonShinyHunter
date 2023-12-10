import flask
from flask_cors import CORS
import json
import os
import random
import requests
import sys
import time

app = flask.Flask(__name__)
CORS(app)

"""
Pokemon Structure:
 {
 "species": int,
 "name": str,
 "variant": str
 }
"""

def get_random_pokemon():
    return get_pokemon(str(random.randint(1, 251)))

def get_pokemon(species):
    return {
        "species": species,
        "name": pokemon_data[species]["name"].lower(),
        "variant": ""
    }

@app.route("/active_bots")
def provideBotIds() -> dict:
    if random.randint(0, 2) == 1:
        # print("Removing bot")
        # _bot_ids.pop()
        pass
    sys.stdout.write(str(_bot_ids) + "\n")
    sys.stdout.flush()
    return {
        "bots": {
            "ETHAN12345": {
                "battle-icon": "spr_emerald",
                "party-icon": "party"
            },
            "HALEY12345": {
                "battle-icon": "spr_silver",
                "party-icon": "party"
            },
            "MAX54321": {
                "battle-icon": "spr_firered-leafgreen",
                "party-icon": "party"
            },
        },
        "timestamp": time.time(),
    }

@app.route("/encounters")
def provideEncounters() -> dict:
    return randomEncounterPayload()

@app.route("/shiny_log")
def provideShinyEncounters() -> list:
    """
    Provides the most recent N shiny encounters for each bot

    Structure:
    [
        {
            bot_id: 
            encounters: []
        },
        {
            bot_id: 
            encounters: []
        }
    ]

    Encounter structure:
    {
        timestamp:
        encounter_data:
        pokemon_data:
    }
    """
    return randomShinyPayload()

@app.route("/phase_info")
def providePhaseInfo() -> dict:
    return randomPhasePayload()

@app.route("/collection_info")
def provideCollectionInfo() -> dict:
    return {}

def randomPhasePayload():
    return [
        {
            "bot_id": _bot_ids[0],
            "timestamp": time.time(),
            "start_timestamp": time.time() - random.randint(0, 7200),
            "bot_mode": "WALKING",
            "total_encounters": random.randint(0, 8192),
            "pokemon_seen": _seen_pokemon,
            "strongest_pokemon": {
                    "id": get_random_pokemon(),
                    "iv": random.randint(0, 64)
                },
            "weakest_pokemon": {
                    "id": get_random_pokemon(), 
                    "iv": random.randint(0, 64)
                }
        },
        {
            "bot_id": _bot_ids[1],
            "start_timestamp": time.time() - random.randint(0, 7200),
            "timestamp": time.time(),
            "bot_mode": "WALKING",
            "total_encounters": random.randint(0, 8192),
            "pokemon_seen": _seen_pokemon,
            "strongest_pokemon": {
                    "id": get_random_pokemon(), 
                    "iv": random.randint(0, 64)
                },
            "weakest_pokemon": {
                    "id": get_random_pokemon(), 
                    "iv": random.randint(0, 64)
                }
        },
        {
            "bot_id": _bot_ids[2],
            "start_timestamp": time.time() - random.randint(0, 7200),
            "timestamp": time.time(),
            "bot_mode": "WALKING",
            "total_encounters": random.randint(0, 8192),
            "pokemon_seen": _seen_pokemon,
            "strongest_pokemon": {
                    "id": get_random_pokemon(),                
                    "iv": random.randint(0, 64)
                },
            "weakest_pokemon": {
                    "id": get_random_pokemon(),
                    "iv": random.randint(0, 64)
                }
        },
    ]

def randomEncounterPayload():
    hp, atk, defense, spd, spe = (random.randint(0, 16)  for _ in range(5))
    return [
        {
            "bot_id": random.choice(_bot_ids),
            "encounters": [
                {
                    "encounter_id": random.randint(0, 20),
                    "timestamp": time.time(),
                    "pokemon_data": {
                        "id": get_random_pokemon(),
                        "level": 40,
                        "healthIv": hp,
                        "attackIv": atk,
                        "defenseIv": defense,
                        "speedIv": spd,
                        "specialIv": spe,
                        "totalIv": sum([hp, atk, defense, spd, spe]),
                        "isShiny": random.random() > 0.9,
                    }
                },
                {
                    "encounter_id": random.randint(0, 20),
                    "timestamp": time.time(),
                    "pokemon_data": {
                        "id": get_random_pokemon(),  
                        "level": 40,
                        "healthIv": hp,
                        "attackIv": atk,
                        "defenseIv": defense,
                        "speedIv": spd,
                        "specialIv": spe,
                        "totalIv": sum([hp, atk, defense, spd, spe]),
                        "isShiny": False,
                    }
                }
            ]
        },
        {
            "bot_id": random.choice(_bot_ids),
            "encounters": [
                {
                    "encounter_id": random.randint(0, 20),
                    "timestamp": time.time(),
                    "pokemon_data": {
                        "id": get_random_pokemon(), 
                        "level": 40,
                        "healthIv": hp,
                        "attackIv": atk,
                        "defenseIv": defense,
                        "speedIv": spd,
                        "specialIv": spe,
                        "totalIv": sum([hp, atk, defense, spd, spe]),
                        "isShiny": False,
                    }
                },
                {
                    "encounter_id": random.randint(0, 20),
                    "timestamp": time.time(),
                    "pokemon_data": {
                        "id": get_random_pokemon(),
                        "level": 40,
                        "healthIv": hp,
                        "attackIv": atk,
                        "defenseIv": defense,
                        "speedIv": spd,
                        "specialIv": spe,
                        "totalIv": sum([hp, atk, defense, spd, spe]),
                        "isShiny": False,
                    }
                }
            ]
        }
    ]

def randomShinyPayload():
    return [
            {
                "bot_id": random.choice(_bot_ids),
                "encounters": [
                    {
                        "timestamp": time.time(),
                        "encounter_data": {
                            "encounter_id": random.randint(0, 20),
                            "phase_encounters": random.randint(0, 8192),
                            "phase_species_encounters": random.randint(0, 8192),
                            "total_species_encounters": random.randint(0, 10000),
                        },
                        "pokemon_data": {
                            "id": get_random_pokemon()
                        }
                    },
                    {
                        "timestamp": time.time(),
                        "encounter_data": {
                            "encounter_id": random.randint(0, 20),
                            "phase_encounters": random.randint(0, 8192),
                            "phase_species_encounters": random.randint(0, 8192),
                            "total_species_encounters": random.randint(0, 10000),
                        },
                        "pokemon_data": {
                            "id": get_random_pokemon()
                        }
                    }     
                ]
            },
            {
                "bot_id": random.choice(_bot_ids),
                "encounters": [
                    {
                        "timestamp": time.time(),
                        "encounter_data": {
                            "encounter_id": random.randint(0, 20),
                            "phase_encounters": random.randint(0, 8192),
                            "phase_species_encounters": random.randint(0, 8192),
                            "total_species_encounters": random.randint(0, 10000),
                        },
                        "pokemon_data": {
                            "id": get_random_pokemon()
                        }
                    },
                    {
                        "timestamp": 1701556788.137356,
                        "encounter_data": {
                            "encounter_id": random.randint(0, 20),
                            "phase_encounters": random.randint(0, 8192),
                            "phase_species_encounters": random.randint(0, 8192),
                            "total_species_encounters": random.randint(0, 10000),
                        },
                        "pokemon_data": {
                            "id": get_random_pokemon()
                        }
                    }     
                ]
            },
        ]

pokemon_data = {}
with open("..\\..\\GameData\\Pokemon\\pokemon_gen2.json", "r") as f:
    pokemon_data = json.load(f)

_bot_ids = ["ETHAN12345", "HALEY12345", "MAX54321"]
_seen_pokemon = [get_random_pokemon() for _ in range(6)]

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000)