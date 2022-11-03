local Create = require("Core.Create");

Spell = {};

function Spell:init()
    self.description = "test"
    self.spell = true;
    self.timeSincePressed = 0.25;
end

function Spell:drawCooldown(x, y, scale)
    assert(self.image);
    if not self.currentCooldown or not self.maxCooldown then
        self.currentCooldown = 0;
        self.maxCooldown = 1;
    end
    love.graphics.push();
    love.graphics.scale(scale);
    x = x/scale;
    y = y/scale;
    local percent = self.currentCooldown / self.maxCooldown;
    if percent > 1 then
        percent = 1;
    end

    love.graphics.setColor(1,1,1,1);
    love.graphics.draw(self.image,x,y);
    if self.timeSincePressed < 0.15 then
        local function pressedStencil()
            love.graphics.rectangle("fill",x+self.image:getWidth()*0.075,y+self.image:getHeight()*0.075,self.image:getWidth()*0.85,self.image:getHeight()*0.85);
        end
        love.graphics.stencil(pressedStencil, "replace", 1);
        love.graphics.setStencilTest("equal", 0);
        if not self.currentCooldown or self.currentCooldown >= self.maxCooldown - 0.15 then
            love.graphics.setColor(0.1,1,0.1,0.8);
        else
            love.graphics.setColor(1,0.1,0.1,0.8);
        end
        love.graphics.rectangle("fill",x,y,self.image:getWidth(),self.image:getHeight());
        love.graphics.setStencilTest();
    end
    local function stencilFunction()
        love.graphics.rectangle("fill",x,y,self.image:getWidth(),self.image:getHeight());
    end
    love.graphics.stencil(stencilFunction, "replace", 1);
    love.graphics.setStencilTest("greater", 0);
    love.graphics.setColor(0.2,0.2,0.2,.7);
    love.graphics.arc("fill", x+1/2*self.image:getWidth(), y+1/2*self.image:getHeight(), self.image:getWidth()*1.5, -math.pi*2*percent-1/2*math.pi,-1/2*math.pi);
    love.graphics.setStencilTest(); 

    love.graphics.pop();
end

function Spell:tickCooldown(dt)
    if self.currentCooldown and self.currentCooldown > 0 then
        self.currentCooldown = self.currentCooldown - dt;
    end
    if self.currentCooldown < 0 then
        self.currentCooldown = 0;
    end
end

function Spell:tickPressed(dt)
    if self.timeSincePressed < 0.25 then
        self.timeSincePressed = self.timeSincePressed + dt;
    end
end

function Spell:isCastable(target)
    if self.castingUnit.isHealer then
        if self.castingUnit.mana < self.manaCost then
            print("Cannot cast without enough Mana")
            return false;
        end
    end
    if self.castingUnit:isDead() and not self.castableWhileDead then
        print("Cannot cast while dead");
        return false;
    end
    if self.castingUnit:isSameTeam(target) and not self.castableOnSame then
        print("Cannot cast on same team");
        return false;
    end
    if not self.castingUnit:isSameTeam(target) and not self.castableOnOpposing then
        print("Cannot cast on opposing team");
        return false;
    end
    if target:isDead() and not self.castableOnDead then
        print("Cannot cast on dead");
        return false;
    end
    if target:getHealth() == target:getMaxHealth() and not self.castableOnMaxHealth then
        print("Cannot cast on max health");
        return false;
    end
    return true;
end

function CreateSpell()
    return Create(Spell);
end

return {CreateSpell, Spell};