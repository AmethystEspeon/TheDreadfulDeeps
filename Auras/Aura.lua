local Create = require("Core.Create");

local Aura = {};

function Aura:init()
    self.expired = false;
    self.isDispellable = true;
end

function Aura:dispel(caster)
    self.expired = true;
end

function Aura:drawDuration(x, y, scale)
    assert(self.image)
    if not self.currentDuration or not self.startingDuration then
        self.currentDuration = 1;
        self.startingDuration = 1;
    end
    love.graphics.push()
    love.graphics.scale(scale)
    x = x/scale
    y = y/scale
    local percent = self.currentDuration / self.startingDuration
    if percent > 1 then
        percent = 1
    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image,x,y)
    local function stencilFunction()
        love.graphics.rectangle("fill",x,y,self.image:getWidth(),self.image:getHeight())
    end
    love.graphics.stencil(stencilFunction, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.setColor(0.2,0.2,0.2,.7)
    love.graphics.arc("fill", x+1/2*self.image:getWidth(), y+1/2*self.image:getHeight(), self.image:getWidth()*1.5, -1/2*math.pi,math.pi*2*percent-1/2*math.pi)
    love.graphics.setStencilTest()
    love.graphics.pop()
end

function CreateAura()
    return Create(Aura);
end

return {CreateAura, Aura};