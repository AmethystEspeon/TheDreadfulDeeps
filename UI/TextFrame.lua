local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));

local TextFrame = {}

function TextFrame:init()
    self.name = "TextFrame";
end

function TextFrame:applyTextSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.text = settings.text
    self.font = settings.font or love.graphics.getFont();
    self.color = settings.color or {0,0,0,1};
    self.align = settings.align or "left";
    self.scale = settings.scale or 1;

    if not self.w or self.w == 0 then
        self.w = self.font:getWidth(self.text);
        if self.align == "right" then
            if not self.parent then
                self.x = self.x - self.w;
            else
                self.offsetX = self.offsetX - self.w;
                self:updatePosition();
            end
        end
    end
end

function TextFrame:setText(text)
    self.text = text
end

function TextFrame:draw()
    assert(self.text, self.name .. " TextFrame: No text to draw");
    love.graphics.push();
    love.graphics.scale(self.scale);
    if self.color then
        love.graphics.setColor(unpack(self.color));
    end
    love.graphics.setFont(self.font);
    love.graphics.printf(self.text, self.x/self.scale, self.y/self.scale, self.w/self.scale, self.align);
    love.graphics.pop();
end

function CreateTextFrame(settings)
    local newFrame = Create(Frame, TextFrame);
    newFrame:applyTextSettings(settings);
    return newFrame;
end

return {CreateTextFrame, TextFrame};