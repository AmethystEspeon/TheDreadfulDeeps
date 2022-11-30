local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local CreateArcaneConversionBuff = unpack(require("Auras.ArcaneConversion"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local ArcaneConversion = {};

local descBuff = CreateArcaneConversionBuff("dummy",0);
function ArcaneConversion:init()
    self.image = ImageList.ArcaneConversion;
    self.maxCooldown = 20;
    self.currentCooldown = 0;
    self.manaCost = 30;

    self.name = SpellIdentifierList.ArcaneConversion;
    self.rarity = SpellIdentifierList.Rarity.Rare;

    self.castableOnSame = true;
    self.castableOnMaxHealth = true;

    self.description = "Dispels all debuffs from an ally and converts them into a heal over time that grows in strength per debuff dispelled." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDuration: " .. tostring(descBuff.startingDuration) .. "s" ..
        "\nHeal = " ..tostring(descBuff.healPerTick/descBuff.tickInterval) .. "/s" .. "\nAdditional Heal per Debuff: " ..tostring(descBuff.healPerTick/descBuff.tickInterval) ..
        "/s";

    self:addUpgrades();
end

function ArcaneConversion:addUpgrades()
    local function updateDescription()
        self.description = "Dispels all debuffs from an ally and converts them into a heal over time that grows in strength per debuff dispelled." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDuration: " .. tostring(descBuff.startingDuration) .. "s" ..
        "\nHeal = " ..tostring(descBuff.healPerTick/descBuff.tickInterval) .. "/s" .. "\nAdditional Heal per Debuff: " ..tostring(descBuff.healPerTick/descBuff.tickInterval) ..
        "/s";
        if self.upgrades[1].applied then
            self.description = self.description .. "\n\n" .. self.upgrades[1].description;
        end
        if self.upgrades[2].applied then
            self.description = self.description .. "\n\n" .. self.upgrades[2].description;
        end
    end
    self.upgrades = self.upgrades or {};
    self.upgrades[1] = {
        upgrade = true;
        inRewards = false;
        name = SpellIdentifierList.ArcaneConversion .. ": " .. SpellIdentifierList.Upgrades.Cooldown;
        image = self.image;
        description = "Every debuff dispelled reduces the cooldown by 5s";

        applied = false;
        choose = function()
            self.upgrades[1].applied = true;
            updateDescription();
        end
    }

    self.upgrades[2] = {
        upgrade = true;
        inRewards = false;
        name = SpellIdentifierList.ArcaneConversion .. ": " .. SpellIdentifierList.Upgrades.ManaCost;
        image = self.image;
        description = "Every debuff dispelled refunds 20% of the mana cost";

        applied = false;
        choose = function()
            self.upgrades[2].applied = true;
            updateDescription();
        end
    }
end

function ArcaneConversion:getCardCount(preventDupes)
    local cards = 1;

    if self.castingUnit:hasSpell(self.name) and preventDupes then
        cards = 0;
        return cards;
    end

    if self.castingUnit:hasSpell(SpellIdentifierList.PrayToDarkness) then
        cards = cards+1;
    end

    return cards;
end

function ArcaneConversion:cast(target)
    if not target then
        --
        return;
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return;
    end
    local numDebuffRemoved = 0;
    for i, v in pairs(target.debuffs) do
        if not v.expired and v.isDispellable then
            v:dispel(self.castingUnit);
            numDebuffRemoved = numDebuffRemoved + 1;
        end
    end
    local buff = CreateArcaneConversionBuff(target, numDebuffRemoved);
    target:addBuff(buff);
    self.castingUnit:minusMana(self.manaCost);
    if self.upgrades[2].applied then
        self.castingUnit:addMana(self.manaCost * 0.2 * numDebuffRemoved);
    end
    self.currentCooldown = self.maxCooldown;
    if self.upgrades[1].applied then
        self.currentCooldown = self.currentCooldown - numDebuffRemoved*5;
        if self.currentCooldown < 0 then
            self.currentCooldown = 0;
        end
    end
end

function CreateArcaneConversion(caster)
    assert(caster);
    local arcaneConversionSpell = Create(Spell,ArcaneConversion);
    arcaneConversionSpell.castingUnit = caster;
    return arcaneConversionSpell;
end

return {CreateArcaneConversion, ArcaneConversion};