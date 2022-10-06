local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateCauterizeBuff = unpack(require("Auras.Cauterize"));
local ImageList = require("Images.ImageList");

local Cauterize = {};

function Cauterize:init()
    self.image = ImageList.Cauterize;
    self.maxCooldown = 5;
    self.currentCooldown = 0;
    self.manaCost = 10;
    self.healthCost = 250;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;
end

function Cauterize:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
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