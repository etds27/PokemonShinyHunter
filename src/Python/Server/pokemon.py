import json
import os

class Pokemon:
	@classmethod
	def get_pokemon(cls, species, variant = ""):
		species = str(species)
		return {
			"species": species,
			"name": cls.pokemon_data[species]["name"].lower(),
			"variant": variant
		}
	
	@classmethod
	def get_pokemon_name(cls, species):
		return cls.get_pokemon(species=species)["name"]

Pokemon.pokemon_data = {}
with open(os.path.join(os.environ["PSH_GAME_DATA_ROOT"], "Pokemon", "pokemon_gen2.json"), "r") as f:
	Pokemon.pokemon_data = json.load(f)