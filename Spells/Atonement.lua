local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");
local Board = require("Core.Board");

local Atonement = {};
------------
--ANALYSIS--
------------
-- Basic spell that deals a small amount of damage and then gives a shield to the
-- lowest health+shields ally proportionate to the damage dealt.
------------

function Atonement:init()
    self.image = ImageList.Atonement;
    self.maxCooldown = 5;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.damage = 200;
    self.effect = 0.5;

    self.name = SpellIdentifierList.Atonement;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnOpposing = true;

    self.description = "A basic damage spell that gives a shield to the weakest ally proportional to the damage dealt." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDamage: " .. tostring(self.damage) ..
        "\nDamage Converted: " .. tostring(self.effect) .. "%";
    
    self:addUpgrades();

    -----------------------------
    --NONAPPLICABLE MULTIPLIERS--
    -----------------------------
    self.durationMultiplier = 0;
end

function Atonement:addUpgrades()
    local function updateDescription()
        self.description = "A basic damage spell that gives a shield to the weakest ally proportional to the damage dealt." .. "\n\n" ..
            "MP Cost: " .. tostring(self.manaCost) ..
            "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
            "\nDamage: " .. tostring(self.damage) ..
            "\nDamage Converted: " .. tostring(self.effect) .. "%";
        if self.upgrades[1].applied then
            self.description = self.description .. "\n\n" .. self.upgrades[1].description;
        end
        if self.upgrades[2].applied then
            string.gsub(self.description, "Damage: " .. tostring(self.damage), "Damage: " .. tostring(self.damage) .. " + " ..
                tostring(self.upgrades[2].damageMultiplier*100) .. "% of target's current health");
        end
    end
    self.upgrades = self.upgrades or {};
    self.upgrades[1] = {
        upgrade = true;
        inRewards = false;
        name = SpellIdentifierList.Atonement .. ": " .. SpellIdentifierList.Upgrades.Effect;
        image = self.image;
        description = "If the weakest ally already has shields, increase the amount of damage converted by 300%";

        shieldMultiplier = 3;
        applied = false;
        choose = function()
            self.upgrades[1].applied = true;
            updateDescription();
        end
    }

    self.upgrades[2] = {
        upgrade = true;
        inRewards = false;
        name = SpellIdentifierList.Atonement .. ": " .. SpellIdentifierList.Upgrades.Damage;
        image = self.image;
        description = "Increase the damage dealt by 5% of the target's current health";

        damageMultiplier = 0.05;
        applied = false;
        choose = function()
            self.upgrades[2].applied = true;
            updateDescription();
        end
    }
end

function Atonement:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    return cards;
end

function Atonement:cast(target)
    if not target then
        --
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    if self.upgrades[2].applied then
        target:minusHealth((self.damage*self.damageHealMultiplier + target.health * self.upgrades[2].damageMultiplier)*self.castingUnit.damageMultiplier);
    else
        target:minusHealth(self.damage*self.damageHealMultiplier);
    end
    local weakestAlly = Board:getLowestHealthShieldAliveAlly();
    if weakestAlly then
        if self.upgrades[1].applied and weakestAlly:getShields() > 0 then
            weakestAlly:addShields(self.damage*self.damageHealMultiplier * (self.effect + self.effect * self.upgrades[1].shieldMultiplier));
        else
            weakestAlly:addShields(self.damage*self.damageHealMultiplier * self.effect);
        end
    end
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateAtonement(caster)
    assert(caster);
    local newAtonement = Create(Spell,Atonement);
    newAtonement.castingUnit = caster;
    return newAtonement;
end

return {CreateAtonement, Atonement};