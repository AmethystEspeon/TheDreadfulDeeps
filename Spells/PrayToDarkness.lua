local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreatePrayToDarknessDebuff = unpack(require("Auras.PrayToDarkness"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local PrayToDarkness = {};
------------
--ANALYSIS--
------------
--The opposite spell of Cauterize. This spell will do an immediate medium heal
--but then applies a Damage over Time that undoes a large amount of the healing done.
--The DoT is stackable. Meant to be used with the debuff package
--(ie: Auras\ArcaneConversion.lua).
------------
function PrayToDarkness:init()
    self.image = ImageList.PrayToDarkness;
    self.maxCooldown = 8;
    self.currentCooldown = 0;
    self.manaCost = 10;
    self.heal = 500;

    self.name = SpellIdentifierList.PrayToDarkness;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnSame = true;
end

function PrayToDarkness:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.ArcaneConversion) then
        cards = cards+1;
    end

    return cards
end

function PrayToDarkness:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addHealth(self.heal);
    target:addDebuff(CreatePrayToDarknessDebuff(target));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreatePrayToDarknessDebuff(caster)
    assert(caster);
    local prayToDarknessSpell = Create(Spell,PrayToDarkness);
    prayToDarknessSpell.castingUnit = caster;
    return prayToDarknessSpell;
end

return {CreatePrayToDarknessDebuff, PrayToDarkness};