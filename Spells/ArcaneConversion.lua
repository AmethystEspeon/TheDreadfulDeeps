local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateArcaneConversionBuff = unpack(require("Auras.ArcaneConversion"));
local ImageList = require("Images.ImageList");

local ArcaneConversion = {};

function ArcaneConversion:init()
    self.image = ImageList.ArcaneConversion;
    self.maxCooldown = 20;
    self.currentCooldown = 0;
    self.manaCost = 30;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;
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
            v:dispell(self.castingUnit);
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