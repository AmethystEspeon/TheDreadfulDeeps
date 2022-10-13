local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateCauterizeBuff = unpack(require("Auras.Cauterize"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Cauterize = {};

local descBuff = CreateCauterizeBuff("dummy");
function Cauterize:init()
    self.image = ImageList.Cauterize;
    self.maxCooldown = 5;
    self.currentCooldown = 0;
    self.manaCost = 10;
    self.healthCost = 250;

    self.name = SpellIdentifierList.Cauterize;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;

    self.description = "Deals damage to an ally and applies a strong heal over time." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDuration: " .. tostring(descBuff.startingDuration) .. "s" ..
        "\nDamage: " ..tostring(self.healthCost) ..
        "\nHeal = " .. tostring(descBuff.healPerTick/descBuff.tickInterval) .. "/s";
end

function Cauterize:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.Regeneration) then
        cards = cards+1;
    end

    return cards;
end

function Cauterize:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:minusHealth(self.healthCost);
    target:addBuff(CreateCauterizeBuff(target));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateCauterize(caster)
    assert(caster);
    local cauterizeSpell = Create(Spell,Cauterize);
    cauterizeSpell.castingUnit = caster;
    return cauterizeSpell;
end

return {CreateCauterize, Cauterize};