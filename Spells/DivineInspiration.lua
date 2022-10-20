local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateDivineInspirationBuff = unpack(require("Auras.DivineInspiration"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local DivineInspiration = {};
------------
--ANALYSIS--
------------
-- A spell that gives a buff to an ally that gives them a shield equal to 50% of
-- the health they gain (heal or some other way) for 15 seconds.
------------
local descBuff = CreateDivineInspirationBuff("dummy");
function DivineInspiration:init()
    self.image = ImageList.DivineInspiration;
    self.maxCooldown = 45;
    self.currentCooldown = 0;
    self.manaCost = 50;

    self.name = SpellIdentifierList.DivineInspiration;
    self.rarity = SpellIdentifierList.Rarity.Epic;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;

    self.description = "A spell that gives a buff to an ally that gives them a shield equal to 50% " ..
        "of the health they gain (heal or some other way) for 15 seconds." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDuration: " .. tostring(descBuff.startingDuration) .. "s";
end

function DivineInspiration:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.Atonement) then
        cards = cards+1;
    end

    return cards;
end

function DivineInspiration:cast(target)
    if not target then
        --
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    local divineInspirationBuff = CreateDivineInspirationBuff(target);
    target:addBuff(divineInspirationBuff);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateDivineInspiration(caster)
    local divineInspiration = Create(Spell);
    divineInspiration:init();
    divineInspiration.castingUnit = caster;
    return divineInspiration;
end

return {CreateDivineInspiration, DivineInspiration};