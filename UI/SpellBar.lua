local Create = require("Core.Create");
local SpellFrame = unpack(require("UI.SpellFrame"));

local SpellBar = {};

function SpellBar:init()
    self.name = "SpellBar";
    self.spellFrames = {};
end

function SpellBar:insertSpell(spell, slot)
    self.spellFrames[slot]:setSpell(spell);
end

function SpellBar:drawAllCooldowns()
    for _, spellFrame in pairs(self.spellFrames) do
        if spellFrame.spell then
            spellFrame:drawCooldown();
        end
    end
end

function CreateSpellBar(settings)
    local newSpellBar = Create(SpellBar);
    for i=1,10 do
        local frameParent;
        if i == 1 then
            frameParent = nil;
        else
            frameParent = newSpellBar.spellFrames[i-1];
        end
        settings.name = settings.name or "";
        local frameSettings = {
            name = "SpellFrameOnBar " .. settings.name .. ": " .. i,
            scale = settings.scale;
            x = settings.x;
            y = settings.y;
            w = settings.w;
            h = settings.h;
            offsetX = settings.separation or settings.offsetX;
            parent = frameParent;
        }
        newSpellBar.spellFrames[i] = SpellFrame(frameSettings)
    end

    return newSpellBar;
end

return {CreateSpellBar, SpellBar};