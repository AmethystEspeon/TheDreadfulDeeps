local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));
local _, Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");

local Heal = {};

function Heal:init()
    self.name = SpellIdentifierList.Heal .. "Cooldown";
    self.castSpellName = SpellIdentifierList.Heal;
    self.image = ImageList.Heal;
    self.startingDuration = 10;
    self.currentDuration = 10;
    self.stacks = 1;

    self.isDispellable = false;
end

function CreateHeal(target, caster)
    assert(target);
    local healBuff = Create(Aura,Buff,Heal);
    healBuff.target = target;
    healBuff.caster = caster;
    return healBuff;
end

function Heal:tick(dt)
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

function Heal:onExpire()
    for _, spell in pairs(self.caster.spells) do
        if spell.name == SpellIdentifierList.Heal then
            spell.maxCooldown = spell.initialMaxCooldown;
        end
    end
end

return {CreateHeal, Heal}