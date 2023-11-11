import logging
import file_manager

class CollectionManager:
    def __init__(self, bot_id) -> None:
            self.bot_id = str(bot_id)
            self.filename = f"shb_{self.bot_id}_collection_table.json"
            self.collection = []
            self.initialize_collection_table()

    def initialize_collection_table(self):
        self.collection = file_manager.load_file(self.bot_id, self.filename)

    def save_collection_table(self):
        file_manager.save_file(self.bot_id, filename=self.filename, data=self.collection)

    def update_collection(self, event_json):
        logging.info(f"Updating collection with {len(event_json['content'])} pokemon")
        self.collection = event_json["content"]

        self.save_collection_table()
