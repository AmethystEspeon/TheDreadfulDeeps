local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));

local BackgroundFrame = {};

function BackgroundFrame:init()
    self.name = "BackgroundFrame";
end

function BackgroundFrame:applyBackgroundSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.backgroundColor = settings.backgroundColor or {1,1,1,1};
end

function BackgroundFrame:draw()
    love.graphics.push();
    love.graphics.setColor(unpack(self.backgroundColor));
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h);
    love.graphics.pop();
end

function BackgroundFrame:setColor(newColor)
    self.backgroundColor = newColor;
end

function CreateBackgroundFrame(settings)
    local newFrame = Create(Frame, BackgroundFrame);
    newFrame:applyBackgroundSettings(settings);
    return newFrame;
end

return {CreateBackgroundFrame, BackgroundFrame};