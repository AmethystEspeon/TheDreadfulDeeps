local Create = require("Core.Create")
local _, Unit = unpack(require("Units.Unit"));
local _, Enemy = unpack(require("Units.Enemy"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board")
local UnitIdentifierList = require("Units.UnitIdentifierList");

local EarthShatterer = {};
------------
--ANALYSIS--
------------
-- This enemy has a large HP pool and a high damage attack, but attacks very slowly. Has
-- a tank buster style ability that does massive damage to the tank and will oneshot a target
-- if it isn't a tank. This ability also has a large cooldown.
------------
function EarthShatterer:init()
    self.maxHealth = 1500;
    self.maxMana = 20;
    self.health = self.maxHealth;
    self.mana = 0;
    self.attackDamage = 500;
    self.attackInterval = 1;
    self.timeSinceLastAttack = 0;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.name = UnitIdentifierList.EarthShatterer;
    self.cost = 50;
end

function EarthShatterer:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getTankPreferredTarget();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function EarthShatterer:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        local target = Board:getTankPreferredTarget();
        if target then
            self.spells[1]:cast(target);
            self.mana = 0;
        end
    end
end

function CreateEarthShatterer()
    local newEarthShatterer = Create(Unit, Enemy, EarthShatterer);

    --Starting Spells--
    local Shatter = SpellList.Shatter(newEarthShatterer);
    table.insert(newEarthShatterer.spells, Shatter);
    return newEarthShatterer;
end

return {CreateEarthShatterer, EarthShatterer};