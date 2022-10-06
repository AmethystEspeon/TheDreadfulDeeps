local Create = require("Core.Create");
local _,Spell = unpack(require("Spells.Spell"));
local CreateRegenerationBuff = unpack(require("Auras.Regeneration"));
local ImageList = require("Images.ImageList");

local Regeneration = {};

function Regeneration:init()
    self.image = ImageList.Regeneration;
    self.maxCooldown = .75;
    self.currentCooldown = 0;
    self.manaCost = 20;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;
end

function Regeneration:cast(target)
    if not target then
        print("No target selected");
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addBuff(CreateRegenerationBuff(target));
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateRegeneration(caster)
    assert(caster);
    local regenerationSpell = Create(Spell,Regeneration);
    regenerationSpell.castingUnit = caster;
    return regenerationSpell;
end

return {CreateRegeneration, Regeneration};