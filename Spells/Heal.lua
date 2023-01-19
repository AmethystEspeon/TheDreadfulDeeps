local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Heal = {};

local CreateHealDispelBuff = unpack(require("Auras.HealDispel"));
local CreateHealCooldownBuff = unpack(require("Auras.HealCooldown"));
function Heal:init()
    self.image = ImageList.Heal;
    self.maxCooldown = 3;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.heal = 300;

    self.name = SpellIdentifierList.Heal;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnSame = true

    self.description = "A small instant heal on a low cooldown." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nHeal: " ..tostring(self.heal);

    self:addUpgrades();

    self.maxStacks = 5;
    self.initialMaxCooldown = self.maxCooldown;

    -----------------------------
    --NONAPPLICABLE MULTIPLIERS--
    -----------------------------
    self.durationMultiplier = 0;
end

function Heal:addUpgrades()
    local function updateDescription()
        self.description = "A small instant heal on a low cooldown." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nHeal: " ..tostring(self.heal);
        if self.upgrades[1].applied then
            self.description = self.description .. "\n\n" .. self.upgrades[1].description;
        end
        if self.upgrades[2].applied then
            self.description = self.description .. "\n\n" .. self.upgrades[2].description;
        end
    end
    self.upgrades = self.upgrades or {};

    self.upgrades[1] = {
        uniqueUpgrade = true;
        name = SpellIdentifierList.Heal .. ": Unique " .. SpellIdentifierList.Upgrades.Special;
        image = self.image;
        description = "Heal instantly dispels incoming debuffs for 1 second.";
        applied = false;

        choose = function()
            self.upgrades[1].applied = true;
            self.castableOnMaxHealth = true;
            updateDescription();
        end;
    }
    self.upgrades[2] = {
        uniqueUpgrade = true;
        name = SpellIdentifierList.Heal .. ": Unique " .. SpellIdentifierList.Upgrades.Cooldown;
        image = self.image;
        description = "Casting adds/refreshes a buff that reduces the cooldown of Heal by 0.5s per stack. Max 5 stacks.";
        applied = false;

        choose = function()
            self.upgrades[2].applied = true;
            updateDescription();
        end;
    }
end

function Heal:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    return cards;
end

function Heal:cast(target)
    if not target then
        
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    target:addHealth(self.heal*self.damageHealMultiplier);
    if self.upgrades[1].applied then
        target:addBuff(CreateHealDispelBuff(target,self.castingUnit));
    end
    if self.upgrades[2].applied then
        self.stacks = self.stacks or 0;
        if self.stacks < self.maxStacks then
            self.stacks = self.stacks + 1;
        end

        local buffAlreadyApplied = false;
        for _, healBuff in pairs(self.castingUnit.buffs) do
            if healBuff.name == self.name .. "Cooldown" then
                healBuff.stacks = self.stacks;
                healBuff.currentDuration = healBuff.startingDuration;
                buffAlreadyApplied = true;
            end
        end
        if not buffAlreadyApplied then
            self.castingUnit:addBuff(CreateHealCooldownBuff(self.castingUnit,self.castingUnit));
        end
        self.maxCooldown = self.initialMaxCooldown - 0.5*self.stacks;
    end
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
    print(target.maxMana)
end

function CreateHeal(caster)
    assert(caster);
    local newHeal = Create(Spell,Heal);
    newHeal.castingUnit = caster;
    return newHeal;
end

return {CreateHeal, Heal};