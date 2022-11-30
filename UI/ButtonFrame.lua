local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));
local BackgroundFrame = unpack(require("UI.BackgroundFrame"));
local TextFrame = unpack(require("UI.TextFrame"));

local ButtonFrame = {};

function ButtonFrame:init()
    self.name = "ButtonFrame";
    self.active = false;
end

function ButtonFrame:applyButtonSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.active = settings.active or self.active;
    local backgroundSettings = {
        name = self.name .. "Background",
        w = self.w,
        h = self.h,
        parent = self,
        backgroundColor = settings.backgroundColor,
    };
    self.backgroundFrame = BackgroundFrame(backgroundSettings);
    local textSettings = {
        name = self.name .. "Text",
        text = settings.text,
        parent = self.backgroundFrame,
        align = "center",
        w = self.w*0.8,
        offsetX = self.w*0.1,
        offsetY = self.h*0.4,
    };
    self.textFrame = TextFrame(textSettings);
end

function ButtonFrame:draw()
    self.backgroundFrame:draw();
    self.textFrame:draw();
end

function ButtonFrame:setOnPress(newFunction)
    self.onPress = newFunction;
end

function ButtonFrame:setOnRelease(newFunction)
    self.onRelease = newFunction;
end

function ButtonFrame:setOnHold(newFunction)
    self.onHold = newFunction;
end

function CreateButtonFrame(settings)
    local newFrame = Create(Frame, ButtonFrame);
    newFrame:applyButtonSettings(settings);
    return newFrame;
end

return {CreateButtonFrame, ButtonFrame};