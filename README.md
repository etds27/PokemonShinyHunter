# PokemonShinyHunter
## Overview
Hello! Welcome to the world of Pokemon shiny hunting. 
The purpose of this project is to create an agent that can perform all of the tedious tasks of shiny hunting. 
From wild encounters, to starter resetting, to breeding, the bot aims to be able to automatically handle the
logic and inputs necessary to perform these actions continuously until a shiny pokemon is obtained.

### What is the end goal of this bot?
Idk honestly. I like the idea of abstracting out the specific/precise actions to accomplish some of the shiny hunting tasks
and providing the ability to hunt for shinies across generations with the same code base. As of right now though, I'm just
trying to get Pokemon Crystal to work. But at the end, I would want to see the same bots playing games across multiple generations
all while feeding data back to the server and display.

In terms of what do I want this project to do outside of performing these tasks? I would like to be able to extract various datapoints from shiny
hunting out from the encounter data and provide a stream of information to the viewer of the game actively hunting shiny
while being shown statistics and live data updates from the current games that are being played.

### Disclaimer
This is my first time working in game modding/botting and also my first time working in Lua

## Encounter Modes
### Grass Encounter
https://github.com/etds27/PokemonShinyHunter/assets/44955732/80a7a742-9a70-423f-9631-3443f1fbfc9c

### Starter Resetting
https://github.com/etds27/PokemonShinyHunter/assets/44955732/1797620e-9588-44ee-9612-5e2abb6fbcc8

### Fishing
https://github.com/etds27/PokemonShinyHunter/assets/44955732/a099d50e-2536-44e9-bc02-44c348a1fd98

## FAQ
### How do you handle randomness for static encounter?
- I ran into this issue early and my approach is to load a save state prior to starting the static encounter. Then
I will wait 1 frame and overwrite that save state that was just loaded. Then when the shiny wasn't found, I load this new
save state and repeat the process. This guarantees that each reset will have a new random seed from the previous



