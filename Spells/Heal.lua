local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Heal = {};

function Heal:init()
    self.image = ImageList.Heal;
    self.maxCooldown = 3;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.heal = 300;

    self.name = SpellIdentifierList.Heal;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnSame = true

    self.description = "A small instant heal on a low cooldown." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nHeal: " ..tostring(self.heal);
end

function Heal:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    return cards;
end

function Heal:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addHealth(self.heal);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateHeal(caster)
    assert(caster);
    local newHeal = Create(Spell,Heal);
    newHeal.castingUnit = caster;
    return newHeal;
end

return {CreateHeal, Heal};