local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local UnitIdentifierList = require("Units.UnitIdentifierList");
local ImageList = require("Images.ImageList");
----------------
----ANALYSIS----
----------------
-- A tank with an ability that increases damage resistance based on
-- how much health is missing. Has an ability that heals himself based on
-- his missing HP that charges as he takes damage.
----------------
local Survivalist = {};

function Survivalist:init()
    self.image = ImageList.Survivalist;
    self.maxHealth = 5000;
    self.health = self.maxHealth;
    self.attackDamage = 40;
    self.attackInterval = 1;
    self.timeSinceLastAttack = 0;
    self.maxMana = 100;
    self.mana = 0;

    self.manaPerSecond = -1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.timeSinceLastAbility = 0;
    self.damageReduction = 0;

    self.isTank = true;
    self.name = UnitIdentifierList.Survivalist;

    self.description = "Tank - A difficult to kill tank that gets tankier the lower HP they get. Their ability heals themselves based "..
        "on their missing HP and how long it has been since they last used it.";
end

function Survivalist:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getRandomAliveEnemy();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function Survivalist:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        local missingHP = self.maxHealth - self.health;
        local multiplier = math.max(1, self.timeSinceLastAbility/10)
        self:addHealth(0.2 * missingHP * multiplier);
        self.mana = 0;
    else
        self.timeSinceLastAbility = self.timeSinceLastAbility + dt;
    end
end

function Survivalist:minusHealth(amount)
    assert(self.health);
    if self.isDamageImmune then
        return --Don't take damage
    end
    self:addMana(amount/self.maxHealth*100*0.75)
    self.damageReduction = (1 - self.health/self.maxHealth) * 0.3;
    local amountReduced = amount * (1 - self.damageReduction);
    amountReduced = self:minusShields(amountReduced);
    self.health = self.health - amountReduced;
    if self.health <= 0 then
        self.health = 0;
        self:die();
    end
end

function CreateSurvivalist()
    local newSurvivalist = Create(Unit, Ally, Survivalist);
    --Starting Spells--
    --TODO: Turn ability into a spell
    return newSurvivalist;
end

return {CreateSurvivalist, Survivalist};