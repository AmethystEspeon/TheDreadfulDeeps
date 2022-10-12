local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Debuff = unpack(require("Auras.Debuff"));
local ImageList = require("Images.ImageList");

local PrayToDarkness = {};

function PrayToDarkness:init()
    self.image = ImageList.PrayToDarkness;
    self.timeSinceLastTick = 0;
    self.tickInterval = 1;
    self.startingDuration = 15;
    self.currentDuration = 15;
    self.damagePerTick = 20;
end

function CreatePrayToDarkness(target)
    assert(target);
    local prayToDarknessDebuff = Create(Aura,Debuff,PrayToDarkness);
    prayToDarknessDebuff.target = target;
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