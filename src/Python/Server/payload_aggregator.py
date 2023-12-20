from event_handler import EventHandler, Event
import json
import logging
import os
import time

bot_server_data = {}
BOT_CONFIG_PATH = os.path.join(os.environ["PSH_ROOT"], "BotConfigs")
for config_file in os.listdir(BOT_CONFIG_PATH):
    if not config_file.endswith(".json"):
        continue

    with open(os.path.join(BOT_CONFIG_PATH, config_file), "r") as f:
        data = json.load(f)
    
    bot_server_data[config_file.replace(".json", "").upper()] = data.get("Dashboard", {})

bot_server_data["DEFAULT"] = {
        "battle-icon": "spr_emerald",
        "party-icon": "party"
} | bot_server_data["DEFAULT"]

print(bot_server_data)


class PayloadAggregator:
    def __init__(self, event_handler: EventHandler):
        self.event_handler = event_handler

    def get_encounter_payload(self):
        payload = [
            {
                "bot_id": bot_id, 
                "encounters": bot_agent[Event.ENCOUNTER.value].get_encounter_payload()
            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        return payload

    def get_bot_payload(self):
        payload =  {
            "bots": {
                bot_id: bot_server_data["DEFAULT"] | bot_server_data.get(bot_id.upper(), {})
                for bot_id in self.event_handler.bot_agents.keys()

            },
            "timestamp": time.time()
        }
        return payload
    
    def get_shiny_payload(self):
        payload =   [
            {
                "bot_id": bot_id, 
                "encounters": bot_agent[Event.ENCOUNTER.value].get_shiny_payload() 
            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        return payload
    
    def get_phase_payload(self):
        payload = [
            {
                "bot_id": bot_id, 
                **bot_agent[Event.ENCOUNTER.value].get_phase_payload(),

            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        return payload
    
    def get_game_stats_payload(self):
        payload = [
            {
                "bot_id": bot_id,
                **bot_agent[Event.GAME.value].get_game_stats_payload(),
                **bot_agent[Event.ENCOUNTER.value].get_game_encounter_payload(),
            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        # logging.info(payload)
        return payload
    
    def get_collection_payload(self):
        payload = [
            {
                "bot_id": bot_id,
                "collection": bot_agent[Event.COLLECTION.value].get_collection_payload(),
            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        return payload
