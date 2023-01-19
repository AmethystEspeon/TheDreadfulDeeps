local Create = require("Core.Create");

local Unit = {};

function Unit:init()
    self.dead = false;
    self.spells = {};
    self.buffs = {};
    self.debuffs = {};
    self.itemEffects = {};

    self.healMultiplier = 1;
    self.damageMultiplier = 1;
    self.shieldMultiplier = 1;
    self.incomingDamageMultiplier = 1;
end
---------------
----SHIELDS----
---------------
function Unit:getShields()
    if not self.Shields then
        self.Shields = 0;
    end
    return self.Shields;
end

function Unit:addShields(amount)
    if not self.Shields then
        self.Shields = 0;
    end
    self.Shields = self.Shields + (amount*self.shieldMultiplier);
    return;
end

function Unit:minusShields(amount)
    if not self.Shields then
        self.Shields = 0;
    end
    self.Shields = self.Shields - (amount*self.incomingDamageMultiplier);
    local shieldBreak = 0;
    if self.Shields < 0 then
        shieldBreak = math.abs(self.Shields);
        self.Shields = 0;
    end
    return shieldBreak;
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
        --print(" unit | function Unit:addHealth");
        return
    end
    self.health = self.health + (amount*self.healMultiplier);
    if self.health > self.maxHealth then
        self.health = self.maxHealth;
    end
end

function Unit:minusHealth(amount)
    assert(self.health);
    if self.isDamageImmune then
        return --Don't take damage
    end
    amount = self:minusShields(amount);
    self.health = self.health - (amount*self.incomingDamageMultiplier);
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

-------------
----AURAS----
-------------
function Unit:addBuff(buff)
    table.insert(self.buffs, buff);
    if buff.onApply then
        buff:onApply();
    end
end

function Unit:addDebuff(debuff)
    table.insert(self.debuffs, debuff);
    if debuff.onApply then
        debuff:onApply();
    end
end

-------------
----ITEMS----
-------------
function Unit:makeItemEffectsActive()
    for _, itemEffect in ipairs(self.itemEffects) do
        itemEffect:effect(self);
    end
end

function Unit:disableItemEffects()
    for _, itemEffect in ipairs(self.itemEffects) do
        itemEffect.makeInactive = true;
        itemEffect:effect(self)
    end
end

function Unit:enableItemEffects()
    for _, itemEffect in ipairs(self.itemEffects) do
        itemEffect.makeInactive = false;
        itemEffect:effect(self)
    end
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

function Unit:hasSpell(spellIdentifier)
    for _, spell in pairs(self.spells) do
        if spell.name == spellIdentifier then
            return true;
        end
    end
    return false;
end

function CreateUnit()
    return Create(Unit);
end

return {CreateUnit, Unit};