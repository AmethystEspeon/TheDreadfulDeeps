local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateCauterizeBuff = unpack(require("Auras.Cauterize"));
local ImageList = require("Images.ImageList");

local Cauterize = {};

function Cauterize:init()
    self.image = ImageList.Cauterize;
    self.maxCooldown = 10;
    self.currentCooldown = 0;
    self.manaCost = 20;
    self.healthCost = 20;
end

function Cauterize:cast(target)
    assert(target);
    assert(self.castingUnit);
    if not self.castingUnit:isSameTeam(target) then
        print("Error: Cauterize can only be cast on allies.");
        return;
    end
    target:minusHealth(self.healthCost);
    target:addBuff(CreateCauterizeBuff(target));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateCauterize(caster)
    assert(caster);
    local cauterizeSpell = Create(Spell,Cauterize);
    cauterizeSpell.castingUnit = caster;
    return cauterizeSpell;
end

return {CreateCauterize, Cauterize};