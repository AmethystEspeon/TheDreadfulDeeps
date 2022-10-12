local Create = require("Core.Create");
local _,Spell = unpack(require("Spells.Spell"));
local CreateRegenerationBuff = unpack(require("Auras.Regeneration"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Regeneration = {};
------------
--ANALYSIS--
------------
--Regeneration is a player spell. It is a small heal over time with a very short
--cooldown. However, the spell stacks so you can get a serious amount of healing
--by spamming it on a character. Will synergize with some heal over time buffs.
------------
function Regeneration:init()
    self.image = ImageList.Regeneration;
    self.maxCooldown = .50;
    self.currentCooldown = 0;
    self.manaCost = 20;

    self.name = SpellIdentifierList.Regeneration;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;
end

function Regeneration:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.Cauterize) then
        cards = cards+1;
    end

    return cards;
end

function Regeneration:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addBuff(CreateRegenerationBuff(target));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateRegeneration(caster)
    assert(caster);
    local regenerationSpell = Create(Spell,Regeneration);
    regenerationSpell.castingUnit = caster;
    return regenerationSpell;
end

return {CreateRegeneration, Regeneration};