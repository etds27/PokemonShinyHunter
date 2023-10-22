-- The purpose of this object is to provide functinoality for getting
-- all pokemon obtained so far and comparing to the requirements
Collection = {}

function Collection:getAllShinyPokemon()
    --[[
        Get all of the shiny pokemon owned by the player

        Return: A table of shiny pokemon
            - {<species>: <num_caught>}
    ]]
    boxPokemon = Box:getAllPokemonInPC()
    partyPokemon = Party:getAllPokemonInParty()
    speciesTable = {}
end