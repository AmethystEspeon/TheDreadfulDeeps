local Create = require("Core.Create");
local _, Item = unpack(require("Items.Item"));
local ItemIdentifierList = require("Items.ItemIdentifierList");
local Board = require("Core.Board");
local ImageList = require("Images.ImageList"); 
local OverloadBracelet = {};

function OverloadBracelet:init()
    self.image = ImageList.OverloadBracelet;
    self.name = ItemIdentifierList.OverloadBracelet;
    self.rarity = ItemIdentifierList.Rarity.Legendary;

    self.maxStacks = 1;

    self.description = "Reduces your maximum mana by 90%, but increases your spell's cooldown rate by 2x";
end

function OverloadBracelet:resetEffect(unit, table)
    unit.maxMana = unit.maxMana * 10;
    for i, spell in ipairs(unit.spells) do
        spell.cooldownMultiplier = spell.cooldownMultiplier / 2;
    end
end

function OverloadBracelet:applyEffect(unit, table)
    unit.maxMana = unit.maxMana / 10;
    for i, spell in ipairs(unit.spells) do
        spell.cooldownMultiplier = spell.cooldownMultiplier * 2;
    end
end

function OverloadBracelet:use()
    local player = Board:getPlayer();
    local applied = self:checkIfApplied(player);
    if not applied then
        local itemEffect = self:createItemEffectTable();
        table.insert(player.itemEffects, itemEffect);
    end
    player:makeItemEffectsActive();
end

function CreateOverloadBracelet()
    local newOverloadBracelet = Create(Item, OverloadBracelet);
    return newOverloadBracelet;
end

return {CreateOverloadBracelet, OverloadBracelet};