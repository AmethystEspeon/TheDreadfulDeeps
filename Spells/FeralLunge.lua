local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local FeralLunge = {};

function FeralLunge:init()
    self.image = ImageList.FeralLunge;
    self.maxCooldown = 30;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.damage = 100;
    self.lostHealthMultiplier = 0.3;

    self.name = SpellIdentifierList.FeralLunge;
    --self.rarity = SpellIdentifierList.Rarity.Epic;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;
end

function FeralLunge:cast(target)
    if not target then
        print("No target selected");
        return
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return
    end
    local additionalDamage = (target:getMaxHealth() - target:getHealth())*self.lostHealthMultiplier;
    target:minusHealth(self.damage + additionalDamage);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateFeralLunge(caster)
    assert(caster);
    local feralLungeSpell = Create(Spell,FeralLunge);
    feralLungeSpell.castingUnit = caster;
    return feralLungeSpell;
end

return {CreateFeralLunge, FeralLunge};