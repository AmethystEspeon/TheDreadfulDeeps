local Create = require("Core.Create")
local _, Unit = unpack(require("Units.Unit"));
local _, Ally = unpack(require("Units.Ally"));

local Player = {};

function Player:init()
    self.maxHealth = 1000;
    self.maxMana = 100;
    self.health = self.maxHealth;
    self.mana = self.maxMana;
    self.manaPerSecond = 10;
    self.attackDamage = 10;
    self.isHealer = true;

    self.items = {};
end


-----------------
--SPELL REWARDS--
-----------------
function Player:getSpellUpgrades()
    local spellUpgrades = {};
    for i, k in ipairs(self.spells) do
        for j, l in ipairs(k.upgrades) do
            if not l.applied and  not l.inRewards then
                table.insert(spellUpgrades, l);
            end
        end
    end
end

-----------------
function CreatePlayer()
    return Create(Unit, Ally, Player)
end

return {CreatePlayer, Player};