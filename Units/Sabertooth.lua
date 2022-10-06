local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));
local SpellList = require("Spells.SpellList");
local Board = require("Core.Board");
local Sabertooth = {};
----------------
----ANALYSIS----
----------------
-- Unit is supposed to have somewhat low hp, but high normal attack damage
-- and an execute ability that deals a lot of damage if the target is how hp
-- that always attacks the lowest hp enemy. Only does single target.
----------------
function Sabertooth:init()
    self.maxHealth = 1200;
    self.maxMana = 30;
    self.mana = 0;
    self.health = 1200;
    self.attackDamage = 100;
    self.isDPS = true
    self.attackInterval = 0.5;
    self.timeSinceLastAttack = self.attackInterval;
end

function Sabertooth:attack(dt)
    self.timeSinceLastAttack = self.timeSinceLastAttack + dt;
    if self.timeSinceLastAttack >= self.attackInterval then
        local target = Board:getLowestHealthAliveEnemy()
        if target then
            target:minusHealth(self.attackDamage)
        end
        self.timeSinceLastAttack = 0;
    end
end

function Sabertooth:useAbility(dt)
    if self:isDead() then
        return
    end
    if self.mana >= self.maxMana then
        local target = Board:getLowestHealthAliveEnemy()
        if target then
            self.spells[1]:cast(target)
            self.mana = 0;
        end
    end
end

function CreateSabertooth()
    local newSabertooth = Create(Unit, Ally, Sabertooth);
    --Starting Spells--
    local FeralLunge = SpellList.FeralLunge(newSabertooth);
    table.insert(newSabertooth.spells, FeralLunge);
    return newSabertooth;
end

return {CreateSabertooth, Sabertooth};