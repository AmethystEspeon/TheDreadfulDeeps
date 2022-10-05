local Create = require("Core.Create");

local Unit = {};

function Unit:init()
    self.dead = false;
    self.spells = {};
    self.buffs = {};
    self.debuffs = {};
end

--------------
----HEALTH----
--------------
function Unit:getHealth()
    assert(self.health);
    return self.health;
end

function Unit:getMaxHealth()
    assert(self.maxHealth);
    return self.maxHealth;
end

function Unit:setMaxHealth(newMaxHealth)
    assert(self.getMaxHealth);
    self.maxHealth = newMaxHealth
end

function Unit:addHealth(amount)
    assert(self.health);
    assert(self.maxHealth);
    if self.dead then
        print("Cannot heal a dead unit from function Unit:addHealth");
        return
    end
    self.health = self.health + amount;
    if self.health > self.maxHealth then
        self.health = self.maxHealth;
    end
end

function Unit:minusHealth(amount)
    assert(self.health);
    self.health = self.health - amount;
    if self.health <= 0 then
        self.health = 0;
        self:die();
    end
end

------------
----MANA----
------------
function Unit:addMana(amount)
    if not self.mana or not self.maxMana then
        return;
    end
    self.mana = self.mana + amount;
    if self.mana > self.maxMana then
        self.mana = self.maxMana;
    end
end

function Unit:minusMana(amount)
    if not self.mana or not self.maxMana then
        return;
    end
    self.mana = self.mana - amount;
    if self.mana < 0 then
        self.mana = 0;
    end
end

function Unit:gainManaPerSecond(dt)
    if not self.mana or not self.maxMana or not self.manaPerSecond then
        return;
    end
    if not self.timeSinceLastMana or not self.manaTickRate then
        return
    end
    self.timeSinceLastMana = self.timeSinceLastMana + dt;
    if self.timeSinceLastMana >= self.manaTickRate then
        --self.manaTickRate is how long between ticks. So to get how many ticks per second it's 1/self.manaTickRate
        self:addMana(self.manaPerSecond*self.manaTickRate);
        self.timeSinceLastMana = 0;
    end
end

function Unit:getMaxMana()
    if not self.mana or not self.maxMana then
        return;
    end
    return self.maxMana;
end

function Unit:setMaxMana(newMaxMana)
    if not self.mana or not self.maxMana then
        return;
    end
    self.maxMana = newMaxMana;
end

---------------
----GENERAL----
---------------
function Unit:die()
    self.dead = true;
end

function Unit:isDead()
    if self.dead then
        return true;
    end
    return false;
end

function Unit:isSameTeam(otherUnit)
    assert(self.isAlly or self.isEnemy)
    assert(otherUnit.isAlly or otherUnit.isEnemy)
    if self.isAlly and self.isAlly == otherUnit.isAlly then
        return true;
    end
    if self.isEnemy and self.isEnemy == otherUnit.isEnemy then
        return true;
    end
    return false;
end

function Unit:addBuff(buff)
    table.insert(self.buffs, buff);
end

function CreateUnit()
    return Create(Unit);
end

return {CreateUnit, Unit};