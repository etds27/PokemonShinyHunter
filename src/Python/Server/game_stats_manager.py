import file_manager
import logging

class GameStatsManager:
    def __init__(self, bot_id) -> None:
        self.bot_id = str(bot_id)
        self.filename = f"shb_{self.bot_id}_encounter_tables.json"
        self.game_stats = {
            "name": 0,
            "id": 0,
            "money": 0,
            "x": 0,
            "y": 0,
            "map": 0,
            "play_time": 0,
            "game_time": 0,
        }
        self.initialize_game_stats()

    def initialize_game_stats(self):
        self.encounters = self.game_stats | file_manager.load_file(self.bot_id, self.filename)

    def save_game_stats(self):
        file_manager.save_file(self.bot_id, filename=self.filename, data=self.game_stats)

    def update(self, payload):
        content = payload["content"]
        logging.info(str(content))
        self.game_stats["play_time"] = content["playTime"]["hour"] * 3600 + content["playTime"]["minute"] * 60 + content["playTime"]["second"]
        self.game_stats["money"] = content["money"]
        self.game_stats["id"] = content["id"]
        self.game_stats["name"] = content["name"]
        self.game_stats["map"] = content["map"]
        self.game_stats["x"] = content["position"]["x"]
        self.game_stats["y"] = content["position"]["y"]
        self.game_stats["game_time"] = content["gameTime"]

        self.save_game_stats()

    def get_game_stats_payload(self):
        return self.game_stats

    