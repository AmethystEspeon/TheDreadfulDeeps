local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));
local _, Debuff = unpack(require("Auras.Debuff"));
local ImageList = require("Images.ImageList");

local ScatterDisease = {};

function ScatterDisease:init()
    self.image = ImageList.ScatterDisease;
    self.timeSinceLastTick = 0;
    self.tickInterval = 1;
    self.startingDuration = 10;
    self.currentDuration = 10;
    self.damagePerTick = 25;
end

function CreateScatterDisease(target)
    assert(target);
    local scatterDiseaseDebuff = Create(Aura, Debuff, ScatterDisease);
    scatterDiseaseDebuff.target = target;
    return scatterDiseaseDebuff;
end

function ScatterDisease:tick(dt)
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

return {CreateScatterDisease, ScatterDisease};