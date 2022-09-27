local function debugPrint(...)
    print(...)
end

local unit = {
    maxHealth = 100,
    health = 100,
    maxMana = 0,
    mana = 0,
    baseAttack = 10,
    attack = 10,
    attackInterval = 1,
    timeSinceLastAttack = 0,
    team = "enemy",
    dead = false,
};

function unit:setMaxHealth(newMaxHealth)
    self.maxHealth = newMaxHealth
end

function unit:addHealth(amount)
    self.health = self.health + amount
    if self.health > self.maxHealth then
        self.health = self.maxHealth
    end
end

function unit:minusHealth(amount)
    self.health = self.health - amount
    if self.health < 0 then
        self.health = 0
        self:die()
    end
end

function unit:getHealth()
    return self.health or nil
end

function unit:setAttack(newAttack)
    self.attack = newAttack
end

function unit:getAttack()
    return self.attack
end

function unit:makeAttack(target)
    if love.timer.getTime() - self.timeSinceLastAttack >= self.attackInterval then
        target:minusHealth(self.attack)
        self.timeSinceLastAttack = love.timer.getTime()
    end
end

function unit:addMana(amount)
    if self.mana == nil then
        return
    end
    self.mana = self.mana + amount
    if self.mana > self.maxMana then
        self.mana = self.maxMana
    end
end

function unit:minusMana(amount)
    if self.mana == nil then
        return
    end
    self.mana = self.mana - amount
    if self.mana < 0 then
        self.mana = 0
    end
end

function unit:getMana()
    return self.mana or nil
end

function unit:hasMana()
    if self.maxMana == nil or self.maxMana == 0 then
        return false
    else
        return true
    end
end

function unit:getTeam()
    return self.team
end

function unit:setAttackInterval(newAttackInterval)
    self.attackInterval = newAttackInterval
end

function unit:getAttackInterval()
    return self.attackInterval or nil
end

function unit:useAbility()
end

function unit:die()
    self.dead = true
end

local function NewClass()
    return setmetatable({}, {__index = unit})
end

function unit:newUnit(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.parent = self
    return o
end    

return NewClass()