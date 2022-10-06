local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");

local Heal = {};

function Heal:init()
    self.image = ImageList.Heal;
    self.maxCooldown = 3;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.heal = 300;

    self.castableOnSame = true
end

function Heal:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addHealth(self.heal);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateHeal(caster)
    assert(caster);
    local newHeal = Create(Spell,Heal);
    newHeal.castingUnit = caster;
    return newHeal;
end

return {CreateHeal, Heal};