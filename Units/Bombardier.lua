local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local UnitIdentifier = require("Units.UnitIdentifierList");
local ImageList = require("Images.ImageList");
----------------
----ANALYSIS----
----------------
-- Aoe Damager. Fairly low health, high damage. Hard hitting, though slow, normal attack
----------------
local Bombardier = {};

function Bombardier:init()
    self.image = ImageList.Bombardier;
    self.maxHealth = 1000;
    self.maxMana = 5;
    self.mana = 0;
    self.health = 600;
    self.attackDamage = 250;
    self.isDPS = true
    self.attackInterval = 2;
    self.timeSinceLastAttack = self.attackInterval;

    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;

    self.name = UnitIdentifier.Bombardier;

    self.description = "DPS - Has high damage, but slow attack speed. Their ability does solid damage to all enemies at a decent cast rate."
end

function Bombardier:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getHighestHealthAliveEnemy()
        if target then
            target:minusHealth(self.attackDamage)
        end
        self.timeSinceLastAttack = 0;
    end
end

function Bombardier:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        self.spells[1]:cast(nil)
        self.mana = 0;
    end
end

function CreateBombardier()
    local newBombardier = Create(Unit, Ally, Bombardier);
    --Starting Spells--
    local Bombard = SpellList.Bombard(newBombardier);
    table.insert(newBombardier.spells, Bombard);
    return newBombardier;
end

return {CreateBombardier, Bombardier};