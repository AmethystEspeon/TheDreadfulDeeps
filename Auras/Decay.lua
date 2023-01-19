local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));
local _, Debuff = unpack(require("Auras.Debuff"));
local ImageList = require("Images.ImageList");
local ItemIdentifierList = require("Items.ItemIdentifierList");

local Decay = {};

function Decay:init()
    self.name = ItemIdentifierList.DecayingPower;
    self.castSpellName = SpellIdentifierList.DecayingPower;
    self.image = ImageList.DecayingPower;
    self.timeSinceLastTick = 0;
    self.tickInterval = 1;
    self.damagePerTick = 15;

    self.isDispellable = false;
end

function Decay:removeAura()
    self.expired = true;
    self.isDispellable = true;
end

function CreateDecayingPower(target)
    assert(target);
    local decayingPowerDebuff = Create(Aura, Debuff, Decay);
    decayingPowerDebuff.target = target;
    return decayingPowerDebuff;
end

function Decay:tick(dt)
    if self.expired then
        return;
    end
    self.timeSinceLastTick = self.timeSinceLastTick + dt;
    if self.timeSinceLastTick >= self.tickInterval then
        self.target:minusHealth(self.damagePerTick);
        self.timeSinceLastTick = 0;
    end
end

return {CreateDecayingPower, Decay};