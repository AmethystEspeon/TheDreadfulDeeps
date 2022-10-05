local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");

local FeralLunge = {};

function FeralLunge:init()
    self.image = ImageList.FeralLunge;
    self.maxCooldown = 30;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.damage = 100;
    self.lostHealthMultiplier = 0.3;
end

function FeralLunge:cast(target)
    assert(target)
    assert(self.castingUnit);
    if self.castingUnit:isSameTeam(target) then
        print("Error: Feral Lunge can only be cast on enemies.")
        return
    end
    if self.castingUnit.isHealer and self.castingUnit:getMana() < self.manaCost then
        print("Error: Not enough mana to cast Feral Lunge.")
        return
    end
    local additionalDamage = (target:getMaxHealth() - target:getHealth())*self.lostHealthMultiplier;
    target:minusHealth(self.damage + additionalDamage);
    print("Feral Lunge dealt "..self.damage + additionalDamage);
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