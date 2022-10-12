local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateArcaneConversionBuff = unpack(require("Auras.ArcaneConversion"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local ArcaneConversion = {};

function ArcaneConversion:init()
    self.image = ImageList.ArcaneConversion;
    self.maxCooldown = 20;
    self.currentCooldown = 0;
    self.manaCost = 30;

    self.name = SpellIdentifierList.ArcaneConversion;
    self.rarity = SpellIdentifierList.Rarity.Rare;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;
end

function ArcaneConversion:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.PrayToDarkness) then
        cards = cards+1;
    end

    return cards;
end

function ArcaneConversion:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    local numDebuffRemoved = 0;
    for i, v in ipairs(target.debuffs) do
        if not v.expired then
            v:dispel(self.castingUnit);
            numDebuffRemoved = numDebuffRemoved + 1;
        end
    end
    target:addBuff(CreateArcaneConversionBuff(target, numDebuffRemoved));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateArcaneConversion(caster)
    assert(caster);
    local arcaneConversionSpell = Create(Spell,ArcaneConversion);
    arcaneConversionSpell.castingUnit = caster;
    return arcaneConversionSpell;
end

return {CreateArcaneConversion, ArcaneConversion};