local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));
local _, TextureFrame = unpack(require("UI.TextureFrame"));

local SpellFrame = {};

function SpellFrame:init()
    self.name = "SpellFrame";
end

function SpellFrame:drawCooldown()
    assert(self.spell, "SpellFrame: " .. self.name .. " has no spell");
    assert(self.spell.image, "SpellFrame: " .. "Spell " .. self.spell.name .. " in SpellFrame: " .. self.name .. " has no image");
    assert(self.texture, "SpellFrame: " .. self.name .. " has no texture");
    self:drawTexture();
    love.graphics.push();
    love.graphics.scale(self.scale);

    local percent = self.spell.currentCooldown / self.spell.maxCooldown;
    if percent > 1 then
        percent = 1;
    end

    
    local scaledX = self.x / self.scale;
    local scaledY = self.y / self.scale;

    ------------------------
    --PRESSED NOTIFICATION--
    ------------------------
    local scaledPressedX = self.x / self.scale + self.texture:getWidth()*0.075;
    local scaledPressedY = self.y / self.scale + self.texture:getHeight()*0.075;
    local pressedW = self.w * 0.85;
    local pressedH = self.h * 0.85;
    love.graphics.setColor(1,1,1,1);
    if self.spell.timeSincePressed < 0.15 then
        local function pressedStencil()
            love.graphics.rectangle("fill", scaledPressedX, scaledPressedY, pressedW, pressedH);
        end
        love.graphics.stencil(pressedStencil, "replace", 1);
        love.graphics.setStencilTest("equal", 0);
        if not self.spell.currentCooldown or self.spell.currentCooldown >= self.spell.maxCooldown - 0.15 then
            love.graphics.setColor(0.1,1,0.1,0.8);
        else
            love.graphics.setColor(1,0.1,0.1,0.8);
        end
        love.graphics.rectangle("fill", scaledX, scaledY, self.w, self.h);
        love.graphics.setStencilTest();
    end

    ------------
    --COOLDOWN--
    ------------
    local function fullStencil()
        love.graphics.rectangle("fill",scaledX, scaledY, self.texture:getWidth(), self.texture:getHeight());
    end
    love.graphics.stencil(fullStencil, "replace", 1);
    love.graphics.setStencilTest("greater", 0);
    love.graphics.setColor(0.2,0.2,0.2,0.7);
    love.graphics.arc("fill", scaledX+1/2*self.texture:getWidth(), scaledY+1/2*self.texture:getHeight(), 500*1.5, -math.pi*2*percent-1/2*math.pi, -1/2*math.pi);
    love.graphics.setStencilTest();

    love.graphics.pop();
end

function SpellFrame:drawAllCooldowns()
    if self.spell then
        self:drawCooldown();
    end
    for _, child in pairs(self.children) do
        if child.drawAllCooldowns then
            child:drawAllCooldowns();
        end
    end
end

function SpellFrame:setSpell(spell)
    if spell == nil then
        self.spell = nil;
        self.texture = nil;
        return;
    end
    self.spell = spell;
    self.texture = spell.image;
    self.w = self.texture:getWidth() * self.scale;
    self.h = self.texture:getHeight() * self.scale;
end

function SpellFrame:applySpellSettings(settings)
    self:applyTextureSettings(settings);
    self.spell = settings.spell;
    self.name = settings.name or self.name;
end

function CreateSpellFrame(settings)
    local newFrame = Create(Frame, TextureFrame, SpellFrame);
    newFrame:applySpellSettings(settings);
    return newFrame;
end

return {CreateSpellFrame, SpellFrame};