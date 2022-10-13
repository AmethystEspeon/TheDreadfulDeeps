local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateMiracleBuff = unpack(require("Auras.Miracle"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Miracle = {};
------------
--ANALYSIS--
------------
--This spell is a legendary class spell. **Extremely** long cooldown.
--Revives an ally, makes them damage immune, and heals them to full health.
--Only should be usable late-midgame onwards due to manacost.
--Possibly should lower caster mana regen rate significantly for a period
--of time after casting.
------------
local descBuff = CreateMiracleBuff("dummy");
function Miracle:init()
    self.image = ImageList.Miracle;
    self.maxCooldown = 300;
    self.currentCooldown = 0;
    self.manaCost = 600;

    self.name = SpellIdentifierList.Miracle;
    self.rarity = SpellIdentifierList.Rarity.Legendary;

    self.castableOnSame = true;
    self.castableOnDead = true;
    self.castableOnMaxHealth = true;

    self.description = "A legendary spell that brings an ally back from the dead, fully heals them, and prevents any damage dealth from any source for a short period of time." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nInvincibility Duration: " .. tostring(descBuff.startingDuration) .. "s";
end

function Miracle:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    return cards;
end

function Miracle:cast(target)
    if not target then
        print("No target selected");
        return
    end
    assert(self.castingUnit)
    if not self:isCastable(target) then
        return
    end
    target:addHealth(target:getMaxHealth());
    target:addBuff(CreateMiracleBuff(target));
    self.castingUnit.minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateMiracle(caster)
    assert(caster);
    local newMiracle = Create(Spell,Miracle);
    newMiracle.castingUnit = caster;
    return newMiracle;
end

return {CreateMiracle, Miracle};