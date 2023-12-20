local Model = {}

---Overriding GSC isEgg
---
---The logic for GS is a little flawed for GS. 
---Eggs will always have HP of 0 and friendship less than 20
---An unhappy fainted pokemon will also report as an Egg
---@param update boolean Bool to determine if pokemon data is updated 
---@return boolean true if pokemon is an Egg
function Model:isEgg(update)
    if update then
        self:update()
    end
    return self.currentHp == 0 and self.friendship < 20
end
return Model