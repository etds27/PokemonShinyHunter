import ../discord_client
import enum
import rom_info

from collection_manager import CollectionManager
from encounter_manager import EncounterManager
from game_stats_manager import GameStatsManager

class Event(enum.Enum):
    ENCOUNTER = "encounter"
    COLLECTION = "collection"
    GAME = "game"

class EventHandler:
    """
    Class to handle the events recieved from the emulator and provide the content to the appropriate event manager
    """
    def __init__(self) -> None:
        self.bot_agents = {}
        
    def handle_event(self, event_json: dict):
        bot_id = event_json["botId"]
        if bot_id not in self.bot_agents:
            self.create_new_bot_agent(bot_id)
            self.bot_agents[bot_id]["rom_data"] = rom_info.get_rom_data(event_json["romHash"])

        # Update the total elapsed time for each payload
        self.bot_agents[bot_id][Event.GAME.value].update_bot_time(event_json["timestamp"])
        if event_json["eventType"] == Event.ENCOUNTER.value:
            self.bot_agents[bot_id][Event.ENCOUNTER.value].manage_new_encounter(event_json)
        if event_json["eventType"] == Event.COLLECTION.value:
            self.bot_agents[bot_id][Event.COLLECTION.value].update_collection(event_json)
        if event_json["eventType"] == Event.GAME.value:
            self.bot_agents[bot_id][Event.GAME.value].update(event_json)
        pass

    def create_new_bot_agent(self, bot_id):
        self.bot_agents[bot_id] = {
            Event.ENCOUNTER.value: EncounterManager(bot_id=bot_id),
            Event.COLLECTION.value: CollectionManager(bot_id=bot_id),
            Event.GAME.value: GameStatsManager(bot_id=bot_id)
        }

# Callbacks for specific event managers to make when an event happens
def on_new_shiny(bot_id, shiny_payload):
    """
    Global actions to take when there is a new shiny found

    shiny_payload:
    {
        "timestamp": int,
        "pokemon": {
            "species": str,
            "name": str,
            "variant": str
        },
        "phase_length": int,
        "total_encounters": int,
        "total_species_seen": int,

        "total_shinies_found": int,
        "total_shiny_species_seen": int,
        "shinies_needed": int
    }
    """
    message = discord_client.create_shiny_message(bot_id=bot_id, shiny_payload=shiny_payload)
    discord_client.send_discord_message(bot_id, message=message)

if __name__ == "__main__":
    bot_id = "ETHAN12345"
    shiny_payload = {
        "timestamp": 1000,
        "pokemon": {
            "species": "TEST",
            "name": "Victrebel",
            "variant": "TEST"
        },
        "phase_length": 20034,
        "total_encounters": 1000000,
        "total_species_seen": 40000,

        "total_shinies_found": 942,
        "total_shiny_species_seen": 40,
        "shinies_needed": 3        
    }
    on_new_shiny(bot_id, shiny_payload)

