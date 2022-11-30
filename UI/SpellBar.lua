local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));
local SpellFrame = unpack(require("UI.SpellFrame"));
local BackgroundFrame = unpack(require("UI.BackgroundFrame"));

local SpellBar = {};

function SpellBar:init()
    self.name = "SpellBar";
    self.spellFrames = {};
end

function SpellBar:drawAllCooldowns()
    for _, spellFrame in pairs(self.spellFrames) do
        if spellFrame.drawAllCooldowns then
            spellFrame.backgroundFrame:draw();
            spellFrame:drawAllCooldowns();
        end
    end
end

function SpellBar:setSpellInSlot(spell, slot)
    self.spellFrames[slot]:setSpell(spell);
end

function SpellBar:setInNextSlot(spell)
    for i = 1, self.maxSpells do
        if not self.spellFrames[i].spell then
            self.spellFrames[i]:setSpell(spell);
            return;
        end
    end
end

function SpellBar:getSpellInSlot(slot)
    return self.spellFrames[slot].spell;
end

function SpellBar:getFrameHovering(x, y)
    for _, spellFrame in pairs(self.spellFrames) do
        if spellFrame:mouseHoveringFrame(x, y) then
            return spellFrame;
        end
    end
    return nil;
end

function SpellBar:castSpellInSlot(slot,target)
    if not self.spellFrames or not self.spellFrames[slot] or not self.spellFrames[slot].spell then
        return;
    end
    local spell = self.spellFrames[slot].spell;
    local player = self.spellFrames[slot].spell.castingUnit;
    if player.mana < spell.manaCost then
        return;
    end
    if spell.currentCooldown ~= 0 then
        return;
    end
    self.spellFrames[slot].spell:cast(target);
end

function SpellBar:applySpellBarSettings(settings)
    self:applyFrameSettings(settings);
    self.maxSpells = settings.maxSpells or 9;
    self.spellFrames = {};
    local separation = settings.separation or 0;
    self.scale = settings.scale or 0.15;
    self.w = settings.w or (512*self.scale); --512 is the width of the spell texture.
    for i = 1, self.maxSpells do
        local spellSettings = {
            name = "SpellFrameOnBar " .. self.name .. " " .. i,
            parent = self,
            offsetX = (i-1)*(self.w+separation),
            scale = self.scale,
            w = self.w,
            h = self.w,
        };



        local spellFrame = SpellFrame(spellSettings);
        local backgroundSettings = {
            name = "BackgroundFrameOnBar " .. self.name .. " " .. i,
            parent = spellFrame,
            w = spellFrame.w,
            h = spellFrame.h,
            backgroundColor = {0.2,0.2,0.2,0.8}
        }
        local background = BackgroundFrame(backgroundSettings);
        self.spellFrames[i] = spellFrame;
        self.spellFrames[i].backgroundFrame = background;
    end
end


function CreateSpellBar(settings)
    local newSpellBar = Create(Frame, SpellBar);
    newSpellBar:applySpellBarSettings(settings);
    return newSpellBar;
end

return {CreateSpellBar, SpellBar};