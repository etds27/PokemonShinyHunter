import os
import pprint
import requests
from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())

WEBHOOK_URL = os.environ.get("DISCORD_WEBHOOK_URL", "")

def create_shiny_message(bot_id, shiny_payload):
    s = ""
    s += f"# {bot_id} just caught a shiny {shiny_payload['pokemon']['name']}\n\n"
    s += "```"
    for key, value in [(f"Time", shiny_payload["timestamp"]),
                       (f"Name", shiny_payload["pokemon"]["name"]),
                       (f"Phase Length", shiny_payload["phase_length"]),
                       (f"Total Pokemon Seen", shiny_payload["total_encounters"]),
                       (f"Total Shinies Seen", shiny_payload["total_shinies_found"]),
                       (f"{shiny_payload['pokemon']['name']} Seen", shiny_payload["total_species_seen"]),
                       (f"Shiny {shiny_payload['pokemon']['name']} Seen", shiny_payload["total_shiny_species_seen"]),
                       (f"{shiny_payload['pokemon']['name']} Needed", shiny_payload["shinies_needed"]),
                       ]:
        pass
        s += f"{key + ':':<23}{value}\n"
    s += "```"
    
    return s

def send_discord_message(message: str):
    if not WEBHOOK_URL:
        return
    payload = {"content": message} 
    print(requests.post(WEBHOOK_URL, json=payload))

if __name__ == "__main__":
    bot_id = "ETHAN12345"
    shiny_payload = {
        "timestamp": 1000,
        "pokemon": {
            "species": "TEST",
            "name": "Victreebel",
            "variant": "TEST"
        },
        "phase_length": 20034,
        "total_encounters": 1000000,
        "total_species_seen": 40000,

        "total_shinies_found": 942,
        "total_shiny_species_seen": 40,
        "shinies_needed": 3        
    }
    message = create_shiny_message(bot_id, shiny_payload)
    send_discord_message(message=message)