local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local ArcaneConversion = {};

function ArcaneConversion:init()
    self.image = ImageList.ArcaneConversion;
    self.startingDuration = 10;
    self.currentDuration = 10;
    self.tickInterval = 0.1;
    self.timeSinceLastTick = 0;
    self.healPerTick = 5;
end

function CreateArcaneConversion(target, numDebuffRemoved)
    assert(target);
    local arcaneConversionBuff = Create(Aura,Buff,ArcaneConversion);
    arcaneConversionBuff.numDebuffRemoved = numDebuffRemoved;
    arcaneConversionBuff.target = target;
    return arcaneConversionBuff;
end

function ArcaneConversion:tick(dt)
    self.timeSinceLastTick = self.timeSinceLastTick + dt
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:addHealth(self.healPerTick+self.healPerTick*self.numDebuffRemoved);
        self.timeSinceLastTick = 0;
    end
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateArcaneConversion, ArcaneConversion};