local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Debuff = unpack(require("Auras.Debuff"));
local ImageList = require("Images.ImageList");

local PrayToDarkness = {};

function PrayToDarkness:init()
    self.castSpellName = SpellIdentifierList.PrayToDarkness;
    self.image = ImageList.PrayToDarkness;
    self.timeSinceLastTick = 0;
    self.tickInterval = 1;

    local castSpell = self:getCastSpell() or {durationMultiplier = 1};
    self.startingDuration = 15*castSpell.durationMultiplier;
    self.currentDuration = 15*castSpell.durationMultiplier;
    self.damagePerTick = 20/castSpell.durationMultiplier; --Same damage over time, longer duration.
end

function CreatePrayToDarkness(target, caster)
    assert(target);
    local prayToDarknessDebuff = Create(Aura,Debuff,PrayToDarkness);
    prayToDarknessDebuff.target = target;
    prayToDarknessDebuff.caster = caster;
    return prayToDarknessDebuff;
end

function PrayToDarkness:tick(dt)
    self.timeSinceLastTick = self.timeSinceLastTick + dt;
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:minusHealth(self.damagePerTick);
        self.timeSinceLastTick = 0;
    end
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreatePrayToDarkness, PrayToDarkness};