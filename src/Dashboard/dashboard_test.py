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

_bot_ids = ["ETHAN12345", "HALEY12345", "MAX54321"]

@app.route("/active_bots")
def provideBotIds() -> dict:
    if random.randint(0, 2) == 1:
        # print("Removing bot")
        # _bot_ids.pop()
        pass
    sys.stdout.write(str(_bot_ids) + "\n")
    sys.stdout.flush()
    return {
        "bot_ids": _bot_ids,
        "timestamp": time.time(),
    }

@app.route("/encounters")
def provideEncounters() -> dict:
    hp, atk, defense, spd, spe = (random.randint(0, 16)  for _ in range(5))
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
    return {}

@app.route("/collection_info")
def provideCollectionInfo() -> dict:
    return {}

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
                        "species": 155,
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
                        "species": 155,
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
                        "species": 155,
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
                        "species": 155,
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
                            "species": random.randint(1, 250)
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
                            "species": random.randint(1, 250)
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
                            "species": random.randint(1, 250)
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
                            "species": random.randint(1, 250)
                        }
                    }     
                ]
            },
        ]

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000)