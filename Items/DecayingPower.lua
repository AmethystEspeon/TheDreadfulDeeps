local Create = require("Core.Create");
local _, Item = unpack(require("Items.Item"));
local ItemIdentifierList = require("Items.ItemIdentifierList");
local Board = require("Core.Board");
local ImageList = require("Images.ImageList");
local CreateDecayDebuff = unpack(require("Auras.Decay"));
local DecayingPower = {};

function DecayingPower:init()
    self.image = ImageList.DecayingPower;
    self.name = ItemIdentifierList.DecayingPower;
    self.rarity = ItemIdentifierList.Rarity.Epic;

    self.maxStacks = 4;

    self.description = "Increases damage taken by enemies by 50% for each stack, but applies a permanent damage over time " ..
        "to all allies per stack. Stacks up to 4 times.";
end

function DecayingPower:resetEffect(unit, table)
    for _, debuff in ipairs(unit.debuffs) do
        if debuff.name == self.name then
            debuff:removeAura();
        end
    end
end

function DecayingPower:applyEffect(unit, effectTable)
    local debuff = CreateDecayDebuff(unit);
    table.insert(unit.debuffs, debuff);
end

function DecayingPower:preEffect(unit, table)
    if self.enemyApplied then
        return;
    end
    for _, enemy in ipairs(Board.enemies) do
        enemy.incomingDamageMultiplier = enemy.incomingDamageMultiplier + (0.5*table.stacks);
    end
    self.enemyApplied = true;
end

function DecayingPower:use()
    for i, unit in ipairs(Board.allies) do
        local applied = self:checkIfApplied(unit);
        if not applied then
            local itemEffect = self:createItemEffectTable();
            table.insert(unit.itemEffects, itemEffect);
        end
        unit:makeItemEffectsActive();
    end
    self.enemyApplied = false;
end

function CreateDecayingPower()
    local newDecayingPower = Create(Item, DecayingPower);
    return newDecayingPower;
end

return {CreateDecayingPower, DecayingPower}