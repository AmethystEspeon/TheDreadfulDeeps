local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateScatterDiseaseDebuff = unpack(require("Auras.ScatterDisease"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local ScatterDisease = {};
------------
--ANALYSIS--
------------
--An enemy spell that gives a small damage over time debuff to all player-allied
--units.
------------

local descBuff = CreateScatterDiseaseDebuff("dummy");
function ScatterDisease:init()
    self.image = ImageList.ScatterDisease;
    self.maxCooldown = 18;
    self.currentCooldown = 0;
    self.manaCost = 18;

    self.name = SpellIdentifierList.ScatterDisease;
    --self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;

    self.description = "Gives a small damage over time debuff to an opposing target." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDuration: " .. tostring(descBuff.startingDuration) .. "s" ..
        "\nDamage: " .. tostring(descBuff.damagePerTick/descBuff.tickInterval);
end

function ScatterDisease:cast(target)
    if not target then
        
        return
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return
    end
    target:addDebuff(CreateScatterDiseaseDebuff(target, self.castingUnit));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateScatterDisease(caster)
    assert(caster);
    local scatterDiseaseSpell = Create(Spell,ScatterDisease);
    scatterDiseaseSpell.castingUnit = caster;
    return scatterDiseaseSpell;
end

return {CreateScatterDisease, ScatterDisease};