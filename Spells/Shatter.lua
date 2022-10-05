local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");

local Shatter = {};

function Shatter:init()
    self.image = ImageList.Shatter;
    self.maxCooldown = 20;
    self.currentCooldown = 0;
    self.manaCost = 20;
    self.damage = 800;
end

function Shatter:cast(target)
    assert(target);
    assert(self.castingUnit);
    if self.castingUnit:isSameTeam(target) then
        print("Error: Shatter can only be cast on enemies.");
        return;
    end
    if self.castingUnit.isHealer and self.castingUnit:getMana() < self.manaCost then
        print("Error: Not enough mana to cast Shatter.");
        return;
    end
    target:minusHealth(self.damage);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateShatter(caster)
    assert(caster);
    local shatterSpell = Create(Spell,Shatter);
    shatterSpell.castingUnit = caster;
    return shatterSpell;
end

return {CreateShatter, Shatter};