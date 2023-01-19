local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local FeralLunge = {};

function FeralLunge:init()
    self.image = ImageList.FeralLunge;
    self.maxCooldown = 30;
    self.currentCooldown = 0;
    self.manaCost = 30;
    self.damage = 100;
    self.lostHealthMultiplier = 0.3;

    self.name = SpellIdentifierList.FeralLunge;
    --self.rarity = SpellIdentifierList.Rarity.Epic;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;

    self.description = "A long cooldown ability that deals damage to an opponent based on their missing HP. On NPCs they will always target the lowest HP opponent." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDamage: " ..tostring(self.damage) .. " + " .. tostring(self.lostHealthMultiplier) .. "x missing HP";
end

function FeralLunge:cast(target)
    if not target then
        --
        return
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return
    end
    local additionalDamage = (target:getMaxHealth() - target:getHealth())*self.lostHealthMultiplier;
    target:minusHealth((self.damage + additionalDamage)*self.damageHealMultiplier);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;

    -----------------------------
    --NONAPPLICABLE MULTIPLIERS--
    -----------------------------
    self.durationMultiplier = 0;
end

function CreateFeralLunge(caster)
    assert(caster);
    local feralLungeSpell = Create(Spell,FeralLunge);
    feralLungeSpell.castingUnit = caster;
    return feralLungeSpell;
end

return {CreateFeralLunge, FeralLunge};