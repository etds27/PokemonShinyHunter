import file_manager
import logging
from pokemon import Pokemon
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

    def get_collection_payload(self):
        require_dict = {
            species: {
                "id": Pokemon.get_pokemon(Pokemon.pokemon_data[species]["id"]),
                "number_caught": 0,
                "number_required": Pokemon.get_pokemon(Pokemon.pokemon_data[species]["required"])
            }
            for species in Pokemon.pokemon_data.keys()
        }

        for pokemon in self.collection:
            if pokemon["species"] in require_dict:
                require_dict["number_caught"] += 1
        
        return [require_dict[species] for species in sorted(require_dict.keys())]
        

