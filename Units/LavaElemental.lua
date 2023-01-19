local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Enemy = unpack(require("Units.Enemy"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board")
local UnitIdentifierList = require("Units.UnitIdentifierList");

local LavaElemental = {};
------------
--ANALYSIS--
------------
-- This enemy has a decent HP pool and mainly uses an aoe spell to do damage.
------------
function LavaElemental:init()
    self.maxHealth = 1000;
    self.maxMana = 5;
    self.health = self.maxHealth;
    self.mana = 0;
    self.attackDamage = 40;
    self.attackInterval = 1;
    self.timeSinceLastAttack = 0;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.name = UnitIdentifierList.LavaElemental;
    self.cost = 25;
    self.duplicatesAllowed = 2;
end

function LavaElemental:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getTankPreferredTarget();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function LavaElemental:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        self.spells[1]:cast(nil)
        self.mana = 0;
    end
end

function CreateLavaElemental()
    local newLavaElemental = Create(Unit, Enemy, LavaElemental);

    --Starting Spells--
    local LavaWave = SpellList.LavaWave(newLavaElemental);
    table.insert(newLavaElemental.spells, LavaWave);
    return newLavaElemental;
end

return {CreateLavaElemental, LavaElemental}