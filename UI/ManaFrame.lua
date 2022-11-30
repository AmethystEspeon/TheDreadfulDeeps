local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));

local ManaFrame = {};

local AliveBackgroundColor = {1,1,1}
local DeadBackgroundColor = {0.6,0.6,0.6}

function ManaFrame:init()
    self.name = "ManaFrame";
end

function ManaFrame:applyManaSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.unit = settings.unit;
end

function ManaFrame:setUnit(unit)
    self.unit = unit;
end

function ManaFrame:draw()
    assert(self.unit, "ManaFrame: " .. self.name .. " has no unit");
    if not self.unit.maxMana or self.unit.maxMana == 0 then
        return;
    end
    love.graphics.push();
    if self.unit:isDead() then
        love.graphics.setColor(unpack(DeadBackgroundColor));
    else
        love.graphics.setColor(unpack(AliveBackgroundColor));
    end
    --Background
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
    --Mana
    if self.unit.mana then
        love.graphics.setColor(0,0,1);
        love.graphics.rectangle("fill", self.x+1, self.y+1, (self.w-2) * (self.unit.mana/self.unit.maxMana), self.h-2);
    end
    love.graphics.pop();
end

function CreateManaFrame(settings)
    local newFrame = Create(Frame, ManaFrame);
    newFrame:applyManaSettings(settings);
    return newFrame;
end

return {CreateManaFrame, ManaFrame};