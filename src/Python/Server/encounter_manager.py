import enum
import event_handler
import logging
import file_manager
import time
from pokemon import Pokemon

logging.basicConfig(level=logging.INFO)
class IV(enum.Enum):
    HP = "hpIv"
    ATK = "attackIv"
    DEF = "defenseIv"
    SPD = "speedIv"
    SPC = "specialIv"

class EncounterManager:
    encounter_memory = 5

    csv_exclusion_keys = [
        "addr",
        "friendship",
        "movePp1",
        "movePp2",
        "movePp3",
        "movePp4",
        "memoryType"
    ]

    encounter_keys = [
        "species",
        "pokerus",
        "level",
        IV.ATK.value,
        IV.DEF.value,
        IV.SPD.value,
        IV.SPC.value,
        IV.HP.value,
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
            "species": {},
            "previous_n_encounters": [],
            "previous_n_shiny_encounters": [],
            "longest_phase_length": -1,
            "shortest_phase_length": -1,
            "current_phase": self.create_phase(time.time()),
        }
        self.initialize_encounter_table()

    def initialize_encounter_table(self):
        self.encounters = self.encounters | file_manager.load_file(self.bot_id, self.filename)

    def save_encounter_table(self):
        file_manager.save_file(self.bot_id, filename=self.filename, data=self.encounters)


    def manage_new_encounter(self, encounter_json):
        """
        Extract the important data from the pokemon table
        """
        logging.debug(f"{self.bot_id}: received encounter event")

        content_json = encounter_json["content"]
        species = str(content_json["species"])
        new_encounter_dict = {k: content_json[k] for k in self.encounter_keys if k in content_json}
        new_encounter_dict["time"] = encounter_json["playTime"]
        new_encounter_dict["timestamp"] = encounter_json["timestamp"]
        new_encounter_dict["strength"] = self.calculate_encounter_strength(new_encounter_dict)
        new_encounter_dict["shiny_proximity"] = self.calculate_shinines_proximity(new_encounter_dict)
        pokemon_id = Pokemon.get_pokemon(species=species)
        pokemon_id_string = Pokemon.get_pokemon_id_string(species=species)
        new_encounter_dict["id"] = pokemon_id

        logging.info(self.encounter_string(species, new_encounter_dict))
        
        for key in self.csv_exclusion_keys:
            if key in content_json:
                content_json.pop(key)
        if self.encounters["current_phase"]["total_encounters"] == 0:
            keys = sorted(filter(lambda x: x not in self.csv_exclusion_keys , content_json.keys()))
            file_manager.append_row_to_csv_filepath(filepath=self.encounters["current_phase"].get("phase_encounter_file", 
                                                                                              file_manager.get_phase_encounter_file(bot_id=self.bot_id,
                                                                                                                                    phase_number=1)), 
                                                    data=keys)
        file_manager.append_row_to_csv_filepath(filepath=self.encounters["current_phase"].get("phase_encounter_file", 
                                                                                              file_manager.get_phase_encounter_file(bot_id=self.bot_id,
                                                                                                                                    phase_number=1)), 
                                                data=self.encounter_list_for_csv(content_json))

        if species not in self.encounters["species"]:
            logging.info(f"Found new species: {pokemon_id['name']}")
            self.create_new_encounter_species(species=species)

        if pokemon_id_string not in self.encounters["current_phase"]["pokemon_seen"]:
                self.encounters["current_phase"]["pokemon_seen"].append(pokemon_id)

        species_dict = self.encounters["species"][species]
        self.update_encounter_dict(species_dict, new_encounter_dict)
        self.update_encounter_dict(self.encounters, new_encounter_dict)
        self.update_encounter_dict(self.encounters["current_phase"], new_encounter_dict)

        # Update the number of specific species found since last shiny of that species
        # Spans across phases
        species_dict.setdefault("species_phase_length", 0)
        species_dict["species_phase_length"] += 1

        # Update the number of specific species found within the current phase
        self.encounters["current_phase"]["species"].setdefault(species, 0)
        self.encounters["current_phase"]["species"][species] += 1

        if content_json["isShiny"]:
            species_dict["shiny_encounters"].append(new_encounter_dict)

            if "caught" in content_json and content_json["caught"]:
                # Update the unique shiny encouter list
                if species not in self.encounters["unique_shinies_caught"]:
                    self.encounters["unique_shinies_caught"].append(species)


            # Add the encounter to the top of the previous encounters list
            self.encounters["previous_n_shiny_encounters"].insert(0, self.create_shiny_encounter_for_payload(new_encounter_dict, self.encounters["current_phase"]))
            if len(self.encounters["previous_n_shiny_encounters"]) > self.encounter_memory:
                self.encounters["previous_n_shiny_encounters"].pop()

            longest_phase = self.encounters["longest_phase_length"]
            shortest_phase = self.encounters["shortest_phase_length"]
            current_phase = self.encounters["current_phase"]["total_encounters"]
            if current_phase > longest_phase:
                logging.info(f"New longest phase length: {current_phase} > {longest_phase}")
                self.encounters["longest_phase_length"] = current_phase
            if current_phase < shortest_phase or shortest_phase == -1:
                logging.info(f"New shortest phase length: {current_phase} > {shortest_phase}")
                self.encounters["shortest_phase_length"] = current_phase
            
            event_handler.on_new_shiny(self.bot_id, self.create_discord_shiny_encounter_payload(new_encounter_dict, self.encounters["current_phase"]))
            # Update the last time we found a shiny to this encounter
            self.encounters["current_phase"] = self.create_phase(encounter_json["timestamp"])

        # Log pokerus
        if "pokerus" in content_json and content_json["pokerus"]:
            species_dict["pokerus_encounters"].append(new_encounter_dict)

        # Add the encounter to the top of the previous encounters list
        self.encounters["previous_n_encounters"].insert(0, self.create_encounter_for_payload(new_encounter_dict))
        if len(self.encounters["previous_n_encounters"]) > self.encounter_memory:
            self.encounters["previous_n_encounters"].pop()

        self.save_encounter_table()

    def update_encounter_dict(self, dest, encounter_dict):
        species = encounter_dict['species']
        pokemon_id = Pokemon.get_pokemon(species=species)
        dest["total_encounters"] += 1

        if encounter_dict["isShiny"]:
            dest["total_shinies_found"] += 1
            dest["total_shinies_caught"] += 1
            if "caughtData" in encounter_dict and encounter_dict["caughtData"]:
                dest["total_shinies_caught"] += 1

        if "pokerus" in encounter_dict and encounter_dict["pokerus"]:
            dest["total_pokerus"] += 1

        # Update the strongest pokemon
        if not dest["strongest_pokemon"] or encounter_dict["strength"] > dest["strongest_pokemon"]["strength"]:
            logging.debug(str(encounter_dict))
            logging.info(f"Found the strongest {pokemon_id['name']}: {encounter_dict['strength']}")
            dest["strongest_pokemon"] = encounter_dict

        # Update the weakest pokemon
        if not dest["weakest_pokemon"] or encounter_dict["strength"] < dest["weakest_pokemon"]["strength"]:
            logging.debug(str(encounter_dict))
            logging.info(f"Found the weakest {pokemon_id['name']}: {encounter_dict['strength']}")
            dest["weakest_pokemon"] = encounter_dict

    def create_new_encounter_species(self, species):
        self.encounters["species"][species] = {
            "total_encounters": 0,
            "total_shinies_found": 0,
            "total_shinies_caught": 0,
            "total_pokerus": 0,
            "shiny_encounters": [],
            "pokerus_encounters": [],
            "last_shiny_encounter": 0,  
            "species_phase_length": 0, # Number of specific species encounters since last shiny
            "strongest_pokemon": {},
            "weakest_pokemon": {}
        }

    def encounter_list_for_csv(self, data):
        keys = sorted(data.keys())
        return [data[key] for key in keys]

    def encounter_string(self, species, encounter_json):
        string = f"BOT#{self.bot_id:<12}: "
        string += f"{Pokemon.get_pokemon_name(species):<10} "
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
    
    def create_phase(self, timestamp):
        return {
            "bot_id": self.bot_id,
            "pokemon_seen": [],
            "species": {},  # Track the encounters for each species in the phase
            "start_timestamp": timestamp,
            "strongest_pokemon": {},
            "total_encounters": 0,
            "total_pokerus": 0,
            "total_shinies_caught": 0,
            "total_shinies_found": 0,
            "weakest_pokemon": {},
            "phase_encounter_file": file_manager.get_phase_encounter_file(bot_id=self.bot_id,
                                                                          phase_number=self.encounters["total_shinies_found"] + 1 if hasattr(self, "encounters") else 1)
        }

    def create_encounter_for_payload(self, encounter_data):
        species = encounter_data["species"]
        return {
            "bot_id": self.bot_id,
            "timestamp": encounter_data["timestamp"],
            "encounter_id": f'{self.encounters["total_encounters"]}_{self.encounters["species"][species]["total_encounters"]}',
            "pokemon_data": encounter_data | {
                "id": Pokemon.get_pokemon(species=species),
                "totalIv": encounter_data["strength"],
            }
        }
    
    def create_shiny_encounter_for_payload(self, encounter_data, phase_data):
        species = encounter_data["species"]
        species_dict = self.encounters["species"][species]
        return {
            "bot_id": self.bot_id,
            "timestamp": encounter_data["timestamp"],
            "encounter_data": {
                "encounter_id": f'{self.encounters["total_encounters"]}_{self.encounters["species"][species]["total_encounters"]}',
                "phase_encounters": phase_data["total_encounters"],
                "phase_species_encounters": species_dict["species_phase_length"],
                "total_species_encounters": species_dict["total_encounters"]
            },
            "pokemon_data": {
                "id": Pokemon.get_pokemon(species=species)
            }
        }
    
    def create_discord_shiny_encounter_payload(self, encounter_data, phase_data):
        species = encounter_data["species"]
        species_dict = self.encounters["species"][species]
        shiny_payload = {
            # General Info
            "timestamp": encounter_data["timestamp"],
            "pokemon": Pokemon.get_pokemon(species=species),

            # Phase Info
            "phase_length": phase_data["total_encounters"],
            "species_phase_length": species_dict["species_phase_length"],

            # Global Info
            "total_encounters": self.encounters["total_encounters"],
            "total_species_seen": species_dict["total_encounters"],
            "total_shinies_found": self.encounters["total_shinies_found"],
            "total_shiny_species_seen": species_dict["total_shinies_found"],
            "shinies_needed": Pokemon.get_pokemon_data(species=species)["required"]
        }
        return shiny_payload
    

    def get_game_encounter_payload(self):
        return {
            "bot_id": self.bot_id,
            "total_encounters": self.encounters["total_encounters"],
            "total_shinies": self.encounters["total_shinies_caught"],
            "shiny_rate": f"1 / {int(self.encounters['total_encounters'] / self.encounters['total_shinies_caught'])}" if self.encounters['total_shinies_caught'] else "∞",
            "longest_phase": self.encounters["longest_phase_length"] if self.encounters["longest_phase_length"] > 0 else "∞",
            "shortest_phase": self.encounters["shortest_phase_length"] if self.encounters["shortest_phase_length"] > 0 else "∞",
            "strongest_pokemon": self.encounters["strongest_pokemon"],
            "weakest_pokemon": self.encounters["weakest_pokemon"],
        }

    def get_phase_payload(self):
        return self.encounters["current_phase"]

    def get_encounter_payload(self):
        return self.encounters["previous_n_encounters"]
    
    def get_shiny_payload(self):
        return self.encounters["previous_n_shiny_encounters"]