local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateRewindFateBuff = unpack(require("Auras.RewindFate"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local RewindFate = {};
------------
--ANALYSIS--
------------
--This spell takes an image of the target's current health and mana, and then
--rewinds them to that state when the buff expires. Decently long cooldown, high
--mana cost. Saves from death.
--
--If you use it on yourself, it costs all of your mana.
------------
local descBuff = CreateRewindFateBuff("dummy");
function RewindFate:init()
    self.image = ImageList.RewindFate;
    self.maxCooldown = 120;
    self.currentCooldown = 0;
    self.manaCost = 200;

    self.name = SpellIdentifierList.RewindFate;
    self.rarity = SpellIdentifierList.Rarity.Epic;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;

    self.description = "Rewinds the fate of a target ally, saving their current state in time. After a short delay, the target will be restored to their previous state, even through " ..
        "death. It exhausts all mana after use when targeted on yourself." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nRewind Duration: " .. tostring(descBuff.startingDuration) .. "s";
end

function RewindFate:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    return cards;
end

function RewindFate:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addBuff(CreateRewindFateBuff(target));
    if self.castingUnit == target then
        self.castingUnit:minusMana(self.castingUnit:getMaxMana());
    else
        self.castingUnit:minusMana(self.manaCost);
    end
    self.currentCooldown = self.maxCooldown;
end

function CreateRewindFate(caster)
    assert(caster);
    local rewindFateSpell = Create(Spell,RewindFate);
    rewindFateSpell.castingUnit = caster;
    return rewindFateSpell;
end

return {CreateRewindFate, RewindFate};