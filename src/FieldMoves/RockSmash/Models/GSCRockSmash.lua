-- Works slightly differently than headbutt
-- The value of the RockSmash changes to the pokemon ID
-- when an encounter is started rather than a static 1
local Model = {
    addr = 0xC2DD,
    size = 1,
    NO_ENCOUNTER = 0,
    PENDING = 1,
}

return Model