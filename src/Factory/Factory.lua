require "Common"

Factory = {}

---@class FactoryMap
---@field [string] table

---Load the correct game model from the provided factory map
---@param factoryMap FactoryMap Mapping of library name to compatible games
---@return table model Desired loaded model
function Factory:loadModel(factoryMap)
    for library, compatibleGames in pairs(factoryMap)
    do
        Common:resetRequires({library})
        if Common:contains(compatibleGames, GameSettings.game) then
            local model, _ = table.unpack(require(library))
            return model
        end
    end
    return {}
end