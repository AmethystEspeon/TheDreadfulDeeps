local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local HeavyAttack = {};
------------
--ANALYSIS--
------------
--The basic spell of any basic ally. Does a small amount of damage.
------------
function HeavyAttack:init()
    self.image = ImageList.HeavyAttack;
    self.maxCooldown = 10;
    self.currentCooldown = 0;
    self.manaCost = 10;
    self.damage = 100;

    self.name = SpellIdentifierList.HeavyAttack;
    --self.rarity = SpellIdentifierList.Rarity.Rare;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;

    self.description = "A basic attack that does a small amount of damage." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDamage: " ..tostring(self.damage);
end

function HeavyAttack:cast(target)
    if not target then
        
        return
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return
    end
    target:minusHealth(self.damage);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateHeavyAttack(caster)
    assert(caster);
    local heavyAttackSpell = Create(Spell,HeavyAttack);
    heavyAttackSpell.castingUnit = caster;
    if heavyAttackSpell.castingUnit.isTank then
        heavyAttackSpell.damage = 50;
    end
    return heavyAttackSpell;
end

return {CreateHeavyAttack, HeavyAttack};