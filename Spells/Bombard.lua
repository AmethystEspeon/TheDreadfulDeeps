local Create = require("Core.Create");
local Board = require("Core.Board");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Bombard = {};

function Bombard:init()
    self.image = ImageList.Bombard;
    self.maxCooldown = 5;
    self.currentCooldown = 0;
    self.manaCost = 5;
    self.damage = 75;

    self.name = SpellIdentifierList.Bombard;

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

function Bombard:cast(target)
    if not self:isCastable(nil) then
        return
    end
    assert(self.castingUnit);
    if self.castingUnit.isAlly then
        for _, unit in ipairs(Board.enemies) do
            unit:minusHealth(self.damage);
        end
    elseif self.castingUnit.isEnemy then
        for _, unit in ipairs(Board.allies) do
            unit:minusHealth(self.damage);
        end
    end
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateBombard(caster)
    assert(caster);
    local bombardSpell = Create(Spell,Bombard);
    bombardSpell.castingUnit = caster;
    return bombardSpell;
end

return {CreateBombard, Bombard};