local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));

local HealthFrame = {};

local AliveBackgroundColor = {1,1,1}
local DeadBackgroundColor = {0.6,0.6,0.6}

function HealthFrame:init()
    self.name = "HealthFrame";
end

function HealthFrame:applyHealthSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.unit = settings.unit;
end

function HealthFrame:setUnit(unit)
    self.unit = unit;
end

function HealthFrame:drawHealth()
    assert(self.unit, "HealthFrame: " .. self.name .. " has no unit");
    love.graphics.push();
    if self.unit:isDead() then
        love.graphics.setColor(unpack(DeadBackgroundColor));
    else
        love.graphics.setColor(unpack(AliveBackgroundColor));
    end
    --Background
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
    --Health
    if self.unit.isAlly then
        local green = 1 * (self.unit:getHealth()/self.unit:getMaxHealth());
        local red = 1 - green;
        love.graphics.setColor(red, green, 0);
    else
        love.graphics.setColor(1,0,0);
    end
    love.graphics.rectangle("fill", self.x+1, self.y+1, (self.w-2) * (self.unit:getHealth()/self.unit:getMaxHealth()), self.h-2);

    love.graphics.pop();
end

function CreateHealthFrame(settings)
    local newFrame = Create(Frame, HealthFrame);
    newFrame:applyHealthSettings(settings);
    return newFrame;
end

return {CreateHealthFrame, HealthFrame};