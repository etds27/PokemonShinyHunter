import logging
import file_manager

logging.basicConfig(level=logging.INFO)

class EncounterManager:
    encounter_keys = [
        "pokerus",
        "level",
        "attackIv",
        "defenseIv",
        "speedIv",
        "specialIv",
        "hpIv",
        "caughtData",
        "isShiny",
    ]

    def __init__(self, bot_id) -> None:
        self.bot_id = str(bot_id)
        self.filename = f"shb_{self.bot_id}_encounter_tables.json"
        self.encounters = {
            "total_encounters": 0,
            "total_shinies_found": 0,
            "total_shinies_caught": 0,
            "unique_shinies_caught": [],
            "total_pokerus": 0,
            "species": {}
        }
        self.initialize_encounter_table

    def initialize_encounter_table(self):
        self.encounters = file_manager.load_file(self.bot_id, self.filename)

    def save_encounter_table(self):
        file_manager.save_file(self.bot_id, filename=self.filename, data=self.encounters)


    def manage_new_encounter(self, encounter_json):
        """
        Extract the important data from the pokemon table
        """
        logging.debug(f"{self.bot_id}: received encounter event")

        content_json = encounter_json["content"]
        species = content_json["species"]
        new_encounter_dict = {k: content_json[k] for k in self.encounter_keys if k in content_json}
        new_encounter_dict["time"] = encounter_json["playTime"]

        logging.info(self.encounter_string(species, new_encounter_dict))

        if species not in self.encounters["species"]:
            self.create_new_encounter_species(species=species)


        species_dict = self.encounters["species"][species]
        species_dict["total_encounters"] += 1
        self.encounters["total_encounters"] += 1


        if content_json["isShiny"]:
            species_dict["total_shinies_found"] += 1
            self.encounters["total_shinies_found"] += 1

            if "caught" in content_json and content_json["caught"]:
                species_dict["total_shinies_caught"] += 1
                self.encounters["total_shinies_caught"] += 1

                if species not in self.encounters["unique_shinies_caught"]:
                    self.encounters["unique_shinies_caught"].append(species)

        if "pokerus" in content_json and content_json["pokerus"]:
            species_dict["total_pokerus"] += 1
            self.encounters["total_pokerus"] += 1

        species_dict["encounters"].append(new_encounter_dict)

        self.save_encounter_table()


    def create_new_encounter_species(self, species):
        self.encounters["species"][species] = {
            "total_encounters": 0,
            "total_shinies_found": 0,
            "total_shinies_caught": 0,
            "total_pokerus": 0,
            "encounters": []
        }

    def encounter_string(self, species, encounter_json):
        string = f"BOT#{self.bot_id}: encounter #{species:03d}: "
        string += f"SHINY: {encounter_json['isShiny']}, "
        string += f"ATK: {encounter_json['attackIv']:02d}, "
        string += f"DEF: {encounter_json['defenseIv']:02d}, "
        string += f"SPD: {encounter_json['speedIv']:02d}, "
        string += f"SPC: {encounter_json['specialIv']:02d}, "
        string += f"HP:  {encounter_json['hpIv']:02d}"
        return string

