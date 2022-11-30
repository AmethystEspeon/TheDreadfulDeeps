local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));

local TextureFrame = {};

function TextureFrame:init()
    self.name = "TextureFrame";
end

function TextureFrame:draw()
    assert(self.texture, "TextureFrame: " .. self.name .. " has no texture");
    love.graphics.push();
    love.graphics.setColor(1,1,1,1);
    love.graphics.scale(self.scale);
    --Get Scale
    local scaledX = self.x / self.scale;
    local scaledY = self.y / self.scale;
    love.graphics.draw(self.texture, scaledX, scaledY);
    love.graphics.pop();
end

function TextureFrame:drawTexture()
    assert(self.texture, "TextureFrame: " .. self.name .. " has no texture");
    love.graphics.push();
    love.graphics.setColor(1,1,1,1);
    love.graphics.scale(self.scale);
    --Get Scale
    local scaledX = self.x / self.scale;
    local scaledY = self.y / self.scale;
    love.graphics.draw(self.texture, scaledX, scaledY);
    love.graphics.pop();
end

function TextureFrame:applyTextureSettings(settings)
    self:applyFrameSettings(settings);
    self.scale = settings.scale;
    self.texture = settings.texture;
    self.name = settings.name or self.name;
    if not self.scale then
        if self.w then
            local imageW = self.texture:getWidth();
            self.scale = self.w / imageW;
        elseif self.h then
            local imageH = self.texture:getHeight();
            self.scale = self.h / imageH;
        else
            self.scale = 1;
        end
    end
    if self.texture then
        if not self.w or self.w == 0 then
            self.w = self.texture:getWidth() * self.scale;
        end
        if not self.h or self.h == 0 then
            self.h = self.texture:getHeight() * self.scale;
        end
    end
end

function CreateTextureFrame(settings)
    local newFrame = Create(Frame, TextureFrame);
    newFrame:applyTextureSettings(settings);
    return newFrame;
end

return {CreateTextureFrame, TextureFrame};