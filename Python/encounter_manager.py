import enum
import logging
import file_manager
import pokemon

logging.basicConfig(level=logging.INFO)
class IV(enum.Enum):
    HP = "hpIv"
    ATK = "attackIv"
    DEF = "defenseIv"
    SPD = "speedIv"
    SPC = "specialIv"

class EncounterManager:
    encounter_keys = [
        "species",
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
            "last_shiny_encounter": 0, # Encounter number for the last time any shiny pokemon was seen
            "last_shiny_timestamp": 0,
            "strongest_pokemon": {},
            "weakest_pokemon": {},
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
        new_encounter_dict["strength"] = self.calculate_encounter_strength(new_encounter_dict)
        new_encounter_dict["shiny_proximity"] = self.calculate_shinines_proximity(new_encounter_dict)

        logging.info(self.encounter_string(species, new_encounter_dict))

        if species not in self.encounters["species"]:
            self.create_new_encounter_species(species=species)


        species_dict = self.encounters["species"][species]
        species_dict["total_encounters"] += 1
        self.encounters["total_encounters"] += 1


        if content_json["isShiny"]:
            species_dict["total_shinies_found"] += 1
            self.encounters["total_shinies_found"] += 1
            species_dict["shiny_encounters"].append(new_encounter_dict)

            if "caught" in content_json and content_json["caught"]:
                species_dict["total_shinies_caught"] += 1
                self.encounters["total_shinies_caught"] += 1

                # Update the unique shiny encouter list
                if species not in self.encounters["unique_shinies_caught"]:
                    self.encounters["unique_shinies_caught"].append(species)

            # Update the last time we found a shiny to this encounter
            self.encounters["last_shiny_encounter"] = self.encounters["total_encounters"]
            self.encounters["last_shiny_timestamp"] = encounter_json["timestamp"]
            species_dict["last_shiny_encounter"] = species_dict["total_encounters"]


        # Log pokerus
        if "pokerus" in content_json and content_json["pokerus"]:
            species_dict["total_pokerus"] += 1
            self.encounters["total_pokerus"] += 1
            species_dict["pokerus_encounters"].append(new_encounter_dict)

        # Update the strongest pokemon
        if not species_dict["strongest_pokemon"] or new_encounter_dict["strength"] > species_dict["strongest_pokemon"]["strength"]:
            logging.info(f"Found the strongest {pokemon.pokemon_names[str(species)]}: {new_encounter_dict['strength']}")
            species_dict["strongest_pokemon"] = new_encounter_dict
        if not self.encounters["strongest_pokemon"] or new_encounter_dict["strength"] > self.encounters["strongest_pokemon"]["strength"]:
            logging.info(f"Found the strongest overall pokemon: {new_encounter_dict['strength']}")
            self.encounters["strongest_pokemon"] = new_encounter_dict

        # Update the weakest pokemon
        if not species_dict["weakest_pokemon"] or new_encounter_dict["strength"] < species_dict["weakest_pokemon"]["strength"]:
            logging.info(f"Found the weakest {pokemon.pokemon_names[str(species)]}: {new_encounter_dict['strength']}")
            species_dict["weakest_pokemon"] = new_encounter_dict
        if not self.encounters["weakest_pokemon"] or new_encounter_dict["strength"] < self.encounters["weakest_pokemon"]["strength"]:
            logging.info(f"Found the weakest overall pokemon: {new_encounter_dict['strength']}")
            self.encounters["weakest_pokemon"] = new_encounter_dict

        self.save_encounter_table()


    def create_new_encounter_species(self, species):
        self.encounters["species"][species] = {
            "total_encounters": 0,
            "total_shinies_found": 0,
            "total_shinies_caught": 0,
            "total_pokerus": 0,
            "shiny_encounters": [],
            "pokerus_encounters": [],
            "last_shiny_encounter": 0,  
            "strongest_pokemon": {},
            "weakest_pokemon": {}
        }

    def encounter_string(self, species, encounter_json):
        string = f"BOT#{self.bot_id}: "
        string += f"{pokemon.pokemon_names[str(species)]:<10} "
        string += f"POW: {encounter_json['strength']:02d}, "
        string += f"PROX: {encounter_json['shiny_proximity']:02d}, "
        string += f"SHINY: {encounter_json['isShiny']}, "
        string += f"ATK: {encounter_json[IV.ATK.value]:02d}, "
        string += f"DEF: {encounter_json[IV.DEF.value]:02d}, "
        string += f"SPD: {encounter_json[IV.SPD.value]:02d}, "
        string += f"SPC: {encounter_json[IV.SPC.value]:02d}, "
        string += f"HP:  {encounter_json[IV.HP.value]:02d}"
        return string
    

    def calculate_shinines_proximity(self, encounter_json):
        # Calculate the distances between def, spd, spe and the number 10
        distances = [abs(encounter_json[val] - 10) for val in [IV.DEF.value,
                                                               IV.SPD.value,
                                                               IV.SPC.value]]
        # Get the minimum distance between the attackIv and one of the shiny values
        distances.append(min([abs(encounter_json[IV.ATK.value] - val) for val in [2, 3, 6, 7, 10, 11, 14, 15]]))
        return sum(distances)
    
    def calculate_encounter_strength(self, encounter_json):
        return sum([encounter_json[key.value] for key in IV])

        

