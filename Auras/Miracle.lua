local Create = require("Core.Create");
local _,Aura = unpack(require("Auras.Aura"));
local _,Buff = unpack(require("Auras.Buff"));
local ImageList = require("Images.ImageList");

local Miracle = {};

function Miracle:init()
    self.castSpellName = SpellIdentifierList.Miracle;
    self.image = ImageList.Miracle;
    local castSpell = self:getCastSpell() or {durationMultiplier = 1};
    self.startingDuration = 5*castSpell.durationMultiplier;
    self.currentDuration = 5*castSpell.durationMultiplier;
end

function CreateMiracle(target, caster)
    assert(target);
    local miracleBuff = Create(Aura,Buff,Miracle);
    miracleBuff.target = target;
    miracleBuff.caster = caster;
    return miracleBuff;
end

function Miracle:onApply()
    self.target.isDamageImmune = true;
end

function Miracle:onExpire()
    self.target.isDamageImmune = false;
end

function Miracle:tick(dt)
    if self.currentDuration > 0 then
        self.currentDuration = self.currentDuration - dt;
    elseif self.currentDuration <= 0 then
        self.currentDuration = 0;
        self.expired = true;
    end
end

return {CreateMiracle, Miracle};