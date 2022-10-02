local Spells = require("Spells")

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
    spells = {},
    buffs = {},
    debuffs = {},
};

function unit:setMaxHealth(newMaxHealth)
    self.maxHealth = newMaxHealth
end

function unit:addHealth(amount)
    if self.dead then
        debugPrint("Cannot heal a dead unit from function unit:addHealth")
        return
    end
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

function unit:getMaxHealth()
    return self.maxHealth or nil
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

function unit:getSpell(spellName)
    for i, spell in ipairs(self.spells) do
        if spell.name == spellName then
            return spell
        end
    end
    return nil
end

function unit:setAttackInterval(newAttackInterval)
    self.attackInterval = newAttackInterval
end

function unit:getAttackInterval()
    return self.attackInterval or nil
end

function unit:useAbility()
end

function unit:isDead()
    return self.dead
end

function unit:die()
    self.dead = true
end

function unit:addDebuff(debuffName, debuffDuration, tickTime, instantTick)
    local debuff = {};
    if instantTick then
        debuff = {name = debuffName, currentDuration = debuffDuration, maxDuration = debuffDuration, tickInterval = tickTime, timeSinceLastTick = tickTime}
    else
        debuff = {name = debuffName, currentDuration = debuffDuration, maxDuration = debuffDuration, tickInterval = tickTime, timeSinceLastTick = 0}
    end
    table.insert(self.debuffs, debuff)
end

function unit:addBuff(buffName, buffDuration, tickTime, instantTick)
    local buff = {};
    if instantTick then
        buff = {name = buffName, currentDuration = buffDuration, maxDuration = buffDuration, tickInterval = tickTime, timeSinceLastTick = tickTime};
    else
        buff = {name = buffName, currentDuration = buffDuration, maxDuration = buffDuration, tickInterval = tickTime, timeSinceLastTick = 0};
    end
    table.insert(self.buffs, buff);
end

function unit:removeDebuff(debuffName)
    for i, debuff in ipairs(self.debuffs) do
        if debuff.name == debuffName then
            table.remove(self.debuffs, i)
        end
    end
end

function unit:removeBuff(buffName)
    debugPrint("Attempting to remove")
    for i, buff in ipairs(self.buffs) do
        if buff.name == buffName then
            table.remove(self.buffs, i)
        end
    end
end

function unit:progressBuffs(dt)
    for i=1, #self.buffs do
        if not self.buffs[i].name then
            table.remove(self.buffs, i)
            debugPrint("Removed buff with no name")
        end
        if love.timer.getTime() - self.buffs[i].timeSinceLastTick >= self.buffs[i].tickInterval then
            self.buffs[i].timeSinceLastTick = love.timer.getTime()
            Spells:tick(self.buffs[i].name, self)
        end
        if self.buffs[i].currentDuration > 0 then
            self.buffs[i].currentDuration = self.buffs[i].currentDuration - dt
            
        else
            self.buffs[i].duration = 0
            table.remove(self.buffs, i)
        end

    end
end

function unit:progressDebuffs(dt)
    for i=1, #self.debuffs do
        if not self.debuff[i].name then
            table.remove(self.debuffs, i)
            debugPrint("Removed debuff with no name")
        end
        if self.debuffs[i].currentDuration > 0 then
            self.debuffs[i].currentDuration = self.debuffs[i].currentDuration - dt
        else
            self.debuffs[i].duration = 0
            table.remove(self.debuffs, i)
        end
        if love.timer.getTime() - self.debuffs[i].timeSinceLastTick >= self.debuffs[i].tickInterval then
            self.debuffs[i].timeSinceLastTick = love.timer.getTime()
            Spells:tick(self.debuffs[i].name, self)
        end
    end
end

---------------------------------------------
-------------Creating Classes----------------
---------------------------------------------
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