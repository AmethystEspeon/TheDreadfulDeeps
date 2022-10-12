local Create = require("Core.Create");
local _, Spell = unpack(require("Spells.Spell"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Shatter = {};
------------
--ANALYSIS--
------------
--This spell is an enemy ability. It is a tankbuster meant to do serious damage to
--the tank. If the tank is dead, it will likely kill whoever else it hits (or at least
--do near lethal damage). It has a long cooldown.
------------
function Shatter:init()
    self.image = ImageList.Shatter;
    self.maxCooldown = 20;
    self.currentCooldown = 0;
    self.manaCost = 20;
    self.damage = 800;

    self.name = SpellIdentifierList.Shatter;
    --self.rarity = SpellIdentifierList.Rarity.Rare;

    self.castableOnOpposing = true;
    self.castableOnMaxHealth = true;
end

function Shatter:cast(target)
    if not target then
        print("No target selected");
        return
    end
    assert(self.castingUnit);
    if not self:isCastable(target) then
        return
    end
    target:minusHealth(self.damage);
    self.castingUnit:minusMana(self.manaCost);
    self.currentCooldown = self.maxCooldown;
end

function CreateShatter(caster)
    assert(caster);
    local shatterSpell = Create(Spell,Shatter);
    shatterSpell.castingUnit = caster;
    return shatterSpell;
end

return {CreateShatter, Shatter};