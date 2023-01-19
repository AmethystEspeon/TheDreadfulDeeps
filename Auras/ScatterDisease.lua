local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));
local _, Debuff = unpack(require("Auras.Debuff"));
local ImageList = require("Images.ImageList");

local ScatterDisease = {};

function ScatterDisease:init()
    self.castSpellName = SpellIdentifierList.ScatterDisease;
    self.image = ImageList.ScatterDisease;
    self.timeSinceLastTick = 0;
    self.tickInterval = 1;

    local castSpell = self:getCastSpell() or {durationMultiplier = 1};
    self.startingDuration = 10*castSpell.durationMultiplier;
    self.currentDuration = 10*castSpell.durationMultiplier;
    self.damagePerTick = 25;
end

function CreateScatterDisease(target, caster)
    assert(target);
    local scatterDiseaseDebuff = Create(Aura, Debuff, ScatterDisease);
    scatterDiseaseDebuff.target = target;
    scatterDiseaseDebuff.caster = caster;
    return scatterDiseaseDebuff;
end

function ScatterDisease:tick(dt)
    local castSpell = self:getCastSpell();
    self.timeSinceLastTick = self.timeSinceLastTick + dt;
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:minusHealth(self.damagePerTick*castSpell.damageHealMultiplier);
        self.timeSinceLastTick = 0;
    end
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateScatterDisease, ScatterDisease};