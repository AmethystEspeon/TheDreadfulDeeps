local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local _, Player = unpack(require("Units.Player"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local UnitIdentifierList = require("Units.UnitIdentifierList");

local Priest = {};

------------
--ANALYSIS--
------------
-- The priest is a low health healer that starts with a larger than average mana pool and mana regen.
-- and strong instant heals. They have low damage output to start with.
------------
function Priest:init()
    self.maxHealth = 800;
    self.maxMana = 150;
    self.health = self.maxHealth;
    self.mana = self.maxMana;
    self.manaPerSecond = 20;
    self.attackDamage = 20;
    self.attackInterval = 1;
    self.timeSinceLastAttack = self.attackInterval;

    self.name = UnitIdentifierList.Priest;
end

function Priest:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getRandomAliveEnemy()
        if target then
            target:minusHealth(self.attackDamage)
        end
        self.timeSinceLastAttack = 0;
    end
end

function CreatePriest()
    local newPriest = Create(Unit, Ally, Player, Priest);

    --Starting Spells--
    local Heal = SpellList.Heal(newPriest);
    table.insert(newPriest.spells, Heal);
    Board.spellBar:setInNextSlot(Heal);
    return newPriest;
end

return {CreatePriest, Priest};