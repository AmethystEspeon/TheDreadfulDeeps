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
    love.graphics.push();
    love.graphics.scale(self.scale);

    local percent = self.spell.currentCooldown / self.spell.maxCooldown;
    if percent > 1 then
        percent = 1;
    end

    love.graphics.setColor(1,1,1,1);
    self:drawTexture();
    if self.spell.timeSincePressed < 0.15 then
        local function pressedStencil()
            love.graphics.rectangle("fill",self.x+self.texture:getWidth()*0.075,self.y+self.texture:getHeight()*0.075,self.texture:getWidth()*0.85,self.texture:getHeight()*0.85);
        end
        love.graphics.stencil(pressedStencil, "replace", 1);
        love.graphics.setStencilTest("equal", 0);
        if not self.spell.currentCooldown or self.spell.currentCooldown >= self.spell.maxCooldown - 0.15 then
            love.graphics.setColor(0.1,1,0.1,0.8);
        else
            love.graphics.setColor(1,0.1,0.1,0.8);
        end
        love.graphics.rectangle("fill",self.x,self.y,self.texture:getWidth(),self.texture:getHeight());
        love.graphics.setStencilTest();
    end
    local function stencilFunction()
        love.graphics.rectangle("fill",self.x,self.y,self.texture:getWidth(),self.texture:getHeight());
    end
    love.graphics.stencil(stencilFunction, "replace", 1);
    love.graphics.setStencilTest("greater", 0);
    love.graphics.setColor(0.2,0.2,0.2,.7);
    love.graphics.arc("fill", self.x+1/2*self.texture:getWidth(), self.y+1/2*self.texture:getHeight(), self.texture:getWidth()*1.5, -math.pi*2*percent-1/2*math.pi,-1/2*math.pi);
    if self.spell.caster.mana < self.spell.manaCost then
        love.graphics.setColor(1,0.1,0.1,0.2);
        love.graphics.rectangle("fill",self.x,self.y,self.texture:getWidth(),self.texture:getHeight());
    end
    love.graphics.setStencilTest();
    

    love.graphics.pop();
end

function SpellFrame:setSpell(spell)
    self.spell = spell;
    self.texture = spell.image;
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