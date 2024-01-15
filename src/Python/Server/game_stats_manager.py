import file_manager
import logging
import time

class GameStatsManager:
    def __init__(self, bot_id) -> None:
        self.bot_id = str(bot_id)
        self.filename = f"shb_{self.bot_id}_game_data_table.json"
        self.previous_time = time.time()
        self.game_stats = {
            "name": 0,
            "id": 0,
            "money": 0,
            "x": 0,
            "y": 0,
            "map": 0,
            "play_time": 0,  # Time played as reported by the game
            "game_time": 0,  # Current time of the game
            "current_elapsed_time": 0,  # Total time that the bot has been running on this game
            "total_elapsed_time": 0,
        }
        self.initialize_game_stats()

    def initialize_game_stats(self):
        self.game_stats = self.game_stats | file_manager.load_file(self.bot_id, self.filename)

    def save_game_stats(self):
        file_manager.save_file(self.bot_id, filename=self.filename, data=self.game_stats)

    def update_bot_time(self, payload_timestamp):
        """
        Updates the current total_elapsed_time and sets the last timestamp recieved to the payloads timestamp
        """
        logging.info(f"{payload_timestamp} {self.game_stats['total_elapsed_time']}")
        self.game_stats["total_elapsed_time"] += payload_timestamp - self.previous_time
        self.previous_time = payload_timestamp
        self.save_game_stats()

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

    