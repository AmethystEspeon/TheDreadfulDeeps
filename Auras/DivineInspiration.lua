local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));

local DivineInspiration = {};

function DivineInspiration:init()
    self.castSpellName = SpellIdentifierList.DivineInspiration;
    self.image = ImageList.DivineInspiration;
    self.startingDuration = 15;
    self.currentDuration = 15;
end

function CreateDivineInspiration(target, caster)
    assert(target)
    local divineInspirationBuff = Create(Aura,Buff,DivineInspiration);
    divineInspirationBuff.target = target;
    divineInspirationBuff.caster = caster;
    divineInspirationBuff.lastHealth = target.health;
    return divineInspirationBuff;
end

function DivineInspiration:tick(dt)
    if self.target.health > self.lastHealth then
        self.target:addShields((self.target.health - self.lastHealth) * 0.5);
    end
    self.lastHealth = self.target.health;
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateDivineInspiration, DivineInspiration};