import enum
import logging
import time

from collection_manager import CollectionManager
from encounter_manager import EncounterManager
from game_stats_manager import GameStatsManager

class Event(enum.Enum):
    ENCOUNTER = "encounter"
    COLLECTION = "collection"
    GAME = "game"

class EventHandler:
    def __init__(self) -> None:
        self.bot_agents = {}
        
    def handle_event(self, event_json: dict):
        bot_id = event_json["botId"]
        if bot_id not in self.bot_agents:
            self.create_new_bot_agent(bot_id)

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

