local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");

local Heal = {};

function Heal:init()
    self.image = ImageList.Heal;
    self.maxCooldown = 3;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.heal = 30;
end

function Heal:cast(target)
    assert(target)
    assert(self.castingUnit)
    if not self.castingUnit:isSameTeam(target) then
        print("Error: Heal can only be cast on allies.")
        return
    end
    if target:getHealth() == target:getMaxHealth() then
        print("Error: Target is already at max health.")
        return
    end
    target:addHealth(self.heal)
    self.castingUnit:minusMana(self.manaCost)
    self.currentCooldown = self.maxCooldown;
end

function CreateHeal(caster)
    assert(caster);
    local healSpell = Create(Spell,Heal);
    healSpell.castingUnit = caster;
    return healSpell;
end

return {CreateHeal, Heal};