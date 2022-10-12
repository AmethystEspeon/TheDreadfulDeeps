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
    self.activeSpellList = {};
    self.isHealer = true;

    self.items = {};
end

local function setActiveSpellList(playerUnit)
    --playerUnit.spells = Player.spells or {};
    playerUnit.activeSpellList = {}; --TODO: Does this fully remove the list and garbage collect? If not, reset it another way.
    for i, k in ipairs(playerUnit.spells) do
        if k.activeSlot then
            table.insert(playerUnit.activeSpellList, k);
        end
    end
end

function Player:placeInActiveSpellList(spell, placement)
    for i, k in ipairs(self.spells) do
        if k.activeSlot == placement then
            k.activeSlot = nil;
        end
    end
    spell.activeSlot = placement
    setActiveSpellList(self)
end

function Player:castSpellInSlot(target, number)
    for i, k in ipairs(self.activeSpellList) do
        if k.activeSlot == number then
            if k.currentCooldown <= 0 then
                k:cast(target);
            else
                print("Still on cooldown")
            end
            return
        end
    end
end

function CreatePlayer()
    return Create(Unit, Ally, Player)
end

return {CreatePlayer, Player};