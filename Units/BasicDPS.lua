local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local BasicDPS = {};
local UnitIdentifierList = require("Units.UnitIdentifierList");
local ImageList = require("Images.ImageList");
----------------
----ANALYSIS----
----------------
-- The basic DPS you start with. Low hp, high damage.
----------------
function BasicDPS:init()
    self.image = ImageList.BasicDPS;
    self.maxHealth = 800;
    self.health = self.maxHealth;
    self.attackDamage = 100;
    self.attackInterval = 0.8;
    self.timeSinceLastAttack = 0;
    self.maxMana = 10;
    self.mana = 0;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.isDPS = true;
    self.name = UnitIdentifierList.BasicDPS;

    self.description = "The basic DPS - Low health, high damage. Has a heavy attack that deals some damage.";
end

function BasicDPS:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getRandomAliveEnemy();
        if target then
            target:minusHealth(self.attackDamage);
        end
        self.timeSinceLastAttack = 0;
    end
end

function BasicDPS:useAbility(dt)
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

function CreateBasicDPS()
    local newBasicDPS = Create(Unit, Ally, BasicDPS);
    --Starting Spells--
    local HeavyAttack = SpellList.HeavyAttack(newBasicDPS);
    table.insert(newBasicDPS.spells, HeavyAttack);
    return newBasicDPS;
end

return {CreateBasicDPS, BasicDPS};