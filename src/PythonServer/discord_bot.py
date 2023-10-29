import discord
import os
from dotenv import load_dotenv, find_dotenv
from discord import Intents

intents = Intents.all()
load_dotenv(find_dotenv())

client = discord.Client(intents=intents)


TOKEN = os.environ["DISCORD_TOKEN"]

async def send_shiny_pokemon_encounter(pokemon_message):
    pass

client.start(TOKEN, reconnect=True)

print(client)
print(dir(client))
print(client.guilds)

guild: discord.Guild = client.get_guild(554477064758231041)
print(guild.text_channels)