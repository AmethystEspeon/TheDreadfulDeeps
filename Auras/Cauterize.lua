local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local Cauterize = {};

function Cauterize:init()
    self.castSpellName = SpellIdentifierList.Cauterize;
    self.image = ImageList.Cauterize;
    self.timeSinceLastTick = 0;
    self.tickInterval = 0.1;

    local castSpell = self:getCastSpell() or {durationMultiplier = 1}
    self.startingDuration = 5*castSpell.durationMultiplier;
    self.currentDuration = 5*castSpell.durationMultiplier;
    self.healPerTick = 20;
end

function CreateCauterize(target, caster)
    assert(target);
    local cauterizeBuff = Create(Aura,Buff,Cauterize);
    cauterizeBuff.target = target;
    cauterizeBuff.caster = caster;
    return cauterizeBuff;
end

function Cauterize:tick(dt)
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

return {CreateCauterize, Cauterize};