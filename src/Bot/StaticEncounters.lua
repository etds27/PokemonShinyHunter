
require "Common"
require "StaticEncountersFactory"



StaticEncounters = {}

-- Abstract tables
local Model = StaticEncountersFactory:loadModel()

StaticEncounters = Common:tableMerge(StaticEncounters, Model)

