from event_handler import EventHandler, Event
import json
import logging
import os
import time

bot_server_data = {}
with open(os.path.join(os.environ["PSH_ROOT"], "BotConfigs", "bot_server_configs.json"), "r") as f:
    bot_server_data = json.load(f)



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
        print(payload)
        return payload

    def get_bot_payload(self):
        payload =  {
            "bots": {
                bot_id: bot_server_data.get(bot_id, {})
                for bot_id in self.event_handler.bot_agents.keys()
            },
            "timestamp": time.time()
        }
        return payload
    
    def get_shiny_payload(self):
        return [
            {
                "bot_id": bot_id, 
                "encounters": bot_agent[Event.ENCOUNTER.value].get_shiny_payload() 
            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
    
    def get_phase_payload(self):
        payload = [
            {
                "bot_id": bot_id, 
                **bot_agent[Event.ENCOUNTER.value].get_phase_payload(),

            }
            for bot_id, bot_agent in self.event_handler.bot_agents.items()
        ]
        return payload
