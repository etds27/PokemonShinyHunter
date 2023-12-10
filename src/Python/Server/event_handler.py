import enum
import logging
import time

from collection_manager import CollectionManager
from encounter_manager import EncounterManager

class Event(enum.Enum):
    ENCOUNTER = "encounter"
    COLLECTION = "collection"
    pass

class EventHandler:
    def __init__(self) -> None:
        self.bot_agents = {}
        
    def handle_event(self, event_json: dict):
        bot_id = event_json["botId"]
        if bot_id not in self.bot_agents:
            self.create_new_bot_agent(bot_id)

        if event_json["eventType"] == Event.ENCOUNTER.value:
            self.bot_agents[bot_id][Event.ENCOUNTER.value].manage_new_encounter(event_json)
        if event_json["eventType"] == Event.COLLECTION.value:
            self.bot_agents[bot_id][Event.COLLECTION.value].update_collection(event_json)
        pass

    def create_new_bot_agent(self, bot_id):
        self.bot_agents[bot_id] = {
            Event.ENCOUNTER.value: EncounterManager(bot_id=bot_id),
            Event.COLLECTION.value: CollectionManager(bot_id=bot_id)
        }

    def get_current_bot_payload(self):
        return {
            "bots": {

            },
            "timestamp": time.time()
        }

