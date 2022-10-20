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

    self.name = SpellIdentifierList.Atonement;
    self.rarity = SpellIdentifierList.Rarity.Common;

    self.castableOnOpposing = true;

    self.description = "A basic damage spell that gives a shield to the weakest ally equal to 50% of the damage dealt." .. "\n\n" ..
        "MP Cost: " .. tostring(self.manaCost) ..
        "\nCooldown: " .. tostring(self.maxCooldown) .. "s" ..
        "\nDamage: " .. tostring(self.damage);
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
    target:minusHealth(self.damage);
    local weakestAlly = Board:getLowestHealthShieldAliveAlly();
    if weakestAlly then
        weakestAlly:addShields(self.damage/2);
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