local Create = require("Core.Create");
local Board = require("Core.Board");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local LavaWave = {};

function LavaWave:init()
    self.image = ImageList.LavaWave;
    self.maxCooldown = 15;
    self.currentCooldown = 0;
    self.manaCost = 15;
    self.damage = 75;

    self.name = SpellIdentifierList.LavaWave;
    --self.rarity = SpellIdentifierList.Rarity.Rare;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;
    self.aoe = true;

    self.description = "Deals damage to all opposing units." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDamage: " .. tostring(self.damage);

    -----------------------------
    --NONAPPLICABLE MULTIPLIERS--
    -----------------------------
    self.durationMultiplier = 0;
end

function LavaWave:cast(target)
    if not self:isCastable(nil) then
        return
    end
    assert(self.castingUnit);
    if self.castingUnit.isAlly then
        for _, unit in ipairs(Board.enemies) do
            unit:minusHealth(self.damage*self.damageHealMultiplier);
        end
    elseif self.castingUnit.isEnemy then
        for _, unit in ipairs(Board.allies) do
            unit:minusHealth(self.damage*self.damageHealMultiplier);
        end
    end
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateLavaWave(caster)
    assert(caster);
    local lavaWaveSpell = Create(Spell,LavaWave);
    lavaWaveSpell.castingUnit = caster;
    return lavaWaveSpell;
end

return {CreateLavaWave, LavaWave};