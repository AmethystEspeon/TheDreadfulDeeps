local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local Regeneration = {};

function Regeneration:init()
    self.castSpellName = SpellIdentifierList.Regeneration;
    self.image = ImageList.Regeneration;
    self.timeSinceLastTick = 0;
    self.tickInterval = 0.25;

    local castSpell = self:getCastSpell() or {durationMultiplier = 1};
    self.startingDuration = 10*castSpell.durationMultiplier;
    self.currentDuration = 10*castSpell.durationMultiplier;
    self.healPerTick = 10;
    --Total Healing: (1/0.5)*5*10 = 100
end

function CreateRegeneration(target, caster)
    assert(target);
    local regenerationBuff = Create(Aura,Buff,Regeneration);
    regenerationBuff.target = target;
    regenerationBuff.caster = caster;
    return regenerationBuff;
end

function Regeneration:tick(dt)
    local castSpell = self:getCastSpell();
    self.timeSinceLastTick = self.timeSinceLastTick + dt;
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:addHealth(self.healPerTick*castSpell.damageHealMultiplier);
        self.timeSinceLastTick = 0;
    end
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateRegeneration, Regeneration};