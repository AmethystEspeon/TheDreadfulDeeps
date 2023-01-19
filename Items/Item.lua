local Create = require("Core.Create")
local Board = require("Core.Board")

Item = {};

function Item:init()
    self.name = "test"
    self.description = "test"
    self.item = true;
    self.stacks = 1;
end

function Item:addStack()
    self.stacks = self.stacks + 1;
end

function Item:checkCanAdd()
    if self.stacks < self.maxStacks then
        return true;
    else
        return false;
    end
end

function Item:checkIfHad()
    local player = Board:getPlayer();
    assert(self.name, "Item has no name!");
    for i, item in ipairs(player.items) do
        if item.name == self.name then
            return true;
        end
    end
    return false;
end

function Item:checkIfApplied(unit)
    for k, itemEffect in pairs(unit.itemEffects) do
        if itemEffect.name == self.name then
            return true;
        end
    end

    return false;
end

function Item:createInitialEffectTable()
    local effectTable = {
        name = self.name;
        stacks = 0;
        active = false;
    }
    effectTable.effect = function(unit)
        if self.preEffect then
            self:preEffect(unit, effectTable);
        end
        if effectTable.stacks == self.stacks then
            return;
        end
        if (effectTable.makeInactive or effectTable.stacks ~= self.stacks) and effectTable.stacks ~= 0 then --Reset the effect
            self:resetEffect(unit, effectTable);
            effectTable.stacks = 0;
        end
        if effectTable.makeInactive then
            effectTable.active = false;
            return;
        end
        self:applyEffect(unit, effectTable);
        effectTable.stacks = self.stacks;
        effectTable.active = true;
    end
    return effectTable;
end

function Item:createItemEffectTable()
    local itemEffectTable = self:createInitialEffectTable();
    return itemEffectTable;
end

function CreateItem()
    return Create(Item);
end

return {CreateItem, Item};