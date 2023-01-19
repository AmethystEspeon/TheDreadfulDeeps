local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local BasicTank = {};
local UnitIdentifierList = require("Units.UnitIdentifierList");
local ImageList = require("Images.ImageList");
----------------
----ANALYSIS----
----------------
-- The basic tank you start with. High hp, extremely low damage.
---------------
function BasicTank:init()
    self.image = ImageList.BasicTank;
    self.maxHealth = 5000;
    self.health = self.maxHealth;
    self.attackDamage = 10;
    self.attackInterval = 1;
    self.timeSinceLastAttack = 0;
    self.maxMana = 10;
    self.mana = 0;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.isTank = true;
    self.name = UnitIdentifierList.BasicTank;

    self.description = "The basic tank - High health, extremely low damage. Has a heavy attack that deals some damage.";
end

function BasicTank:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getRandomAliveEnemy();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function BasicTank:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        local target = Board:getRandomAliveEnemy();
        if target then
            self.spells[1]:cast(target);
            self.mana = 0;
        end
    end
end

function CreateBasicTank()
    local newBasicTank = Create(Unit, Ally, BasicTank);
    --Starting Spells--
    local HeavyAttack = SpellList.HeavyAttack(newBasicTank);
    table.insert(newBasicTank.spells, HeavyAttack);
    return newBasicTank;
end

return {CreateBasicTank, BasicTank};