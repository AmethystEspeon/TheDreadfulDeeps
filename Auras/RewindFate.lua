local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));

local RewindFate = {};

function RewindFate:init()
    self.castSpellName = SpellIdentifierList.RewindFate;
    self.image = ImageList.RewindLate;
    self.startingDuration = 5;
    self.currentDuration = 5;
end

function CreateRewindFate(target, caster)
    assert(target)
    local rewindFateBuff = Create(Aura,Buff,RewindFate);
    rewindFateBuff.target = target;
    rewindFateBuff.caster = caster;
    rewindFateBuff.previousHealth = target.health;
    rewindFateBuff.previousMana = target.mana;
    --TODO: Find a different way around this.
    if target ~= "dummy" then
        rewindFateBuff.previousDead = target:isDead();
    end
    --TODO: Make it rewind other buffs maybe?
    return rewindFateBuff;
end

function RewindFate:onExpire()
    print("OLD:" .. self.previousHealth .. " NEW:" .. self.target.health)
    self.target.health = self.previousHealth;
    self.target.mana = self.previousMana;
    self.target.dead = self.previousDead;
end

function RewindFate:tick(dt)
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateRewindFate, RewindFate};