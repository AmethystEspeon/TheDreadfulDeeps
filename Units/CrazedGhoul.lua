local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Enemy = unpack(require("Units.Enemy"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local UnitIdentifierList = require("Units.UnitIdentifierList");

local CrazedGhoul = {};
----------------
----ANALYSIS----
----------------
-- An enemy unit that attacks a random target. Has medium damage with a above average
-- attack rate. Has a spell that deals a small damage over time to all enemies.
----------------
function CrazedGhoul:init()
    self.maxHealth = 1000;
    self.maxMana = 18;
    self.health = self.maxHealth;
    self.mana = 0;
    self.attackDamage = 80;
    self.attackInterval = 0.8;
    self.timeSinceLastAttack = 0;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.name = UnitIdentifierList.CrazedGhoul;
    self.cost = 15;
    self.duplicatesAllowed = 3;
end

function CrazedGhoul:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getRandomAliveAlly();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function CrazedGhoul:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        for k,unit in pairs(Board.allies) do
            if not unit:isDead() then
                self.spells[1]:cast(unit);
                self.mana = 0;
            end
        end
    end
end

function CreateCrazedGhoul()
    local newCrazedGhoul = Create(Unit, Enemy, CrazedGhoul);

    --Starting Spells--
    local ScatterDisease = SpellList.ScatterDisease(newCrazedGhoul);
    table.insert(newCrazedGhoul.spells, ScatterDisease);
    return newCrazedGhoul;
end

return {CreateCrazedGhoul, CrazedGhoul};