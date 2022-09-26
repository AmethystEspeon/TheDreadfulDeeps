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
    team = "enemy"
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
    end
end

function unit:setAttack(newAttack)
    self.attack = newAttack
end

function unit:addMana(amount)
    self.mana = self.mana + amount
    if self.mana > self.maxMana then
        self.mana = self.maxMana
    end
end

function unit:minusMana(amount)
    self.mana = self.mana - amount
    if self.mana < 0 then
        self.mana = 0
    end
end

function unit:getMana()
    return self.mana
end

function unit:getTeam()
    return self.team
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