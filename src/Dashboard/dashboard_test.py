import flask
from flask_cors import CORS
import json
import logging
import os
import random
import requests
import re
import sys
import time

logging.basicConfig(level=logging.INFO)
DASHBOARD_DIR = os.environ.get("PSH_DASHBOARD_DIR", os.path.join("..", "..", "Dashboard"))

app = flask.Flask(__name__, template_folder='templates', static_folder='static')
CORS(app)

"""
Pokemon Structure:
 {
 "species": int,
 "name": str,
 "variant": str
 }
"""

current_song = {}

def get_random_pokemon():
    return get_pokemon(str(random.randint(1, 251)))

def get_pokemon(species):
    return {
        "species": str(species),
        "name": pokemon_data[str(species)]["name"].lower(),
        "variant": ""
    }

@app.route("/")
def render_template() -> str:
    return flask.render_template(os.path.join("dashboard.html")) 

@app.route("/active_bots")
def provideBotIds() -> dict:
    if random.randint(0, 2) == 1:
        # print("Removing bot")
        # _bot_ids.pop()
        pass
    sys.stdout.write(str(_bot_ids) + "\n")
    sys.stdout.flush()
    icons = ["spr_ruby-sapphire", "spr_emerald", "spr_platinum", "spr_diamond-pearl", "spr_hgss"]
    games = ["Emerald", "Silver", "Gold", "Crystal", "Ruby", "Sapphire"]
    return {
        "bots": {
            bot_id: {
                "battle-icon": random.choice(icons),
                "party-icon": "party",
                "game_name": random.choice(games)
            }
            for bot_id in _bot_ids
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

@app.route("/collection")
def provideCollectionInfo() -> dict:
    return collection_payload

@app.route("/game_stats")
def provide_game_stats_info() -> dict:
    return randomGameStats()

@app.route("/get_current_song", methods=["GET"])
def update_current_song():
    return current_song


@app.route("/current_song", methods=["POST"])
def receive_current_song():
        global current_song
        current_song = flask.request.json
        if current_song: 
            current_song["album_cover_path"] = re.sub(re.escape(DASHBOARD_DIR), "", current_song["album_cover_path"])

        logging.info(current_song)
        return flask.Response("SUCCESS", status=200)

def randomGameStats():
    return [
        {
            "bot_id": bot_id,
            "total_time": random.randint(1, 15000000),
            "total_encounters": random.randint(1, 5000000),
            "total_shinies": random.randint(1, 5000),
            "shiny_rate": f'1 / {random.randint(1, 5000)}',
            "longest_phase": random.randint(1, 50000),
            "shortest_phase": random.randint(1, 50000),
            "strongest_pokemon": {
                "id": get_random_pokemon(),
                "strength": random.randint(1, 64)
            },
            "weakest_pokemon": {
                "id": get_random_pokemon(),
                "strength": random.randint(1, 64)
            }
        }
        for bot_id in _bot_ids
    ]

def randomPhasePayload():
    return [
        {
            "bot_id": bot_id,
            "timestamp": time.time(),
            "start_timestamp": time.time() - random.randint(0, 7200),
            "total_encounters": random.randint(0, 8192),
            "pokemon_seen": _seen_pokemon,
            "strongest_pokemon": {
                    "id": get_random_pokemon(),
                    "strength": random.randint(0, 64)
                },
            "weakest_pokemon": {
                    "id": get_random_pokemon(), 
                    "strength": random.randint(0, 64)
                }
        }
        for bot_id in _bot_ids
    ]

def randomEncounterPayload(bots = 1, n = 1):
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
                        "hpIv": hp,
                        "attackIv": atk,
                        "defenseIv": defense,
                        "speedIv": spd,
                        "specialIv": spe,
                        "totalIv": sum([hp, atk, defense, spd, spe]),
                        "isShiny": random.random() > 0.9,
                    }
                }
                for _ in range(n)
            ]
        }
        for _ in range(bots)
    ]

def randomShinyPayload(bots = 1, n = 1):
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
                    }
                    for _ in range(n)
                ]
            }
            for _ in range(bots)
        ]

pokemon_data = {}
with open("..\\..\\GameData\\Pokemon\\pokemon_gen2.json", "r") as f:
    pokemon_data = json.load(f)

_bot_ids = ["ETHAN12345", "HALEY12345" , "MAX54321"]
_seen_pokemon = [get_random_pokemon() for _ in range(6)]
_seen_pokemon = [get_pokemon("29"), get_pokemon("32"), get_pokemon("250"), get_pokemon("122")]
collection_payload = [
    {
        "bot_id": bot_id,
        "collection": [
            {
                "id": get_pokemon(num),
                "number_caught": random.randint(1, 3),
                "number_required": random.randint(2, 4)
            }
            for num in sorted(list(set([random.randint(1,250) for i in range(20)])))
        ]
    }
    for bot_id in _bot_ids
]


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000)