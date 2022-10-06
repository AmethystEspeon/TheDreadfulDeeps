local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local Regeneration = {};

function Regeneration:init()
    self.image = ImageList.Regeneration;
    self.timeSinceLastTick = 0;
    self.tickInterval = 0.25;
    self.startingDuration = 10;
    self.currentDuration = 10;
    self.healPerTick = 10;
    --Total Healing: (1/0.5)*5*10 = 100
end

function CreateRegeneration(target)
    assert(target);
    local regenerationBuff = Create(Aura,Buff,Regeneration);
    regenerationBuff.target = target;
    return regenerationBuff;
end

function Regeneration:tick(dt)
    self.timeSinceLastTick = self.timeSinceLastTick + dt;
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:addHealth(self.healPerTick);
        self.timeSinceLastTick = 0;
    end
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateRegeneration, Regeneration};