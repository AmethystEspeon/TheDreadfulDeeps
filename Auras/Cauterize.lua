local Create = require("Core.Create");
local _,Buff = unpack(require("Auras.Buff"));
local _,Aura = unpack(require("Auras.Aura"));
local ImageList = require("Images.ImageList");

local Cauterize = {};

function Cauterize:init()
    self.image = ImageList.Cauterize;
    self.timeSinceLastTick = 0;
    self.tickInterval = 0.1;
    self.startingDuration = 5;
    self.currentDuration = 5;
    self.healPerTick = 1;
end

function CreateCauterize(target)
    assert(target);
    local cauterizeBuff = Create(Aura,Buff,Cauterize);
    cauterizeBuff.target = target;
    return cauterizeBuff;
end

function Cauterize:tick(dt)
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

return {CreateCauterize, Cauterize};