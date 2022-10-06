local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local Miracle = {};

function Miracle:init()
    self.image = ImageList.Miracle;
    self.startingDuration = 5;
    self.currentDuration = 5;
end

function CreateMiracle(target)
    assert(target);
    local miracleBuff = Create(Aura,Buff,Miracle);
    miracleBuff.target = target;
    return miracleBuff;
end

function Miracle:onApply()
    self.target.isDamageImmune = true;
end

function Miracle:onExpire()
    self.target.isDamageImmune = false;
end

function Miracle:tick(dt)
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateMiracle, Miracle};