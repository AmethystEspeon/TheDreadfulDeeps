local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateMiracleBuff = unpack(require("Auras.Miracle"));
local ImageList = require("Images.ImageList");

local Miracle = {};
------------
--ANALYSIS--
------------
--This spell is a legendary class spell. **Extremely** long cooldown.
--Revives an ally, makes them damage immune, and heals them to full health.
--Only should be usable late-midgame onwards due to manacost.
--Possibly should lower caster mana regen rate significantly for a period
--of time after casting.
------------
function Miracle:init()
    self.image = ImageList.Miracle;
    self.maxCooldown = 300;
    self.currentCooldown = 0;
    self.manaCost = 600;

    self.castableOnSame = true;
    self.castableOnDead = true;
    self.castableOnMaxHealth = true;
end

function Miracle:cast(target)
    if not target then
        print("No target selected");
        return
    end
    assert(self.castingUnit)
    if not self:isCastable(target) then
        return
    end
    target:addHealth(target:getMaxHealth());
    target:addBuff(CreateMiracleBuff(target));
    self.castingUnit.minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateMiracle(caster)
    assert(caster);
    local newMiracle = Create(Spell,Miracle);
    newMiracle.castingUnit = caster;
    return newMiracle;
end

return {CreateMiracle, Miracle};