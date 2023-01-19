local Create = require("Core.Create");
local _, Item = unpack(require("Items.Item"));
local ItemIdentifierList = require("Items.ItemIdentifierList");
local ImageList = require("Images.ImageList");
local Board = require("Core.Board")

local CastBand = {};

function CastBand:init()
    self.image = ImageList.CastBand;
    self.name = ItemIdentifierList.CastBand;
    self.rarity = ItemIdentifierList.Rarity.Epic;

    self.maxStacks = 4;

    self.description = "Decreases max mana of all allies by half for each stack. Stacks up to 4 times.";
end

function CastBand:resetEffect(unit, table)
    unit.maxMana = unit.maxMana*(2^table.stacks);
end

function CastBand:applyEffect(unit, table)
    unit.maxMana = unit.maxMana/(2^self.stacks);
end

function CastBand:use()
    for i, unit in ipairs(Board.allies) do
        local applied = self:checkIfApplied(unit);
        if not applied then
            local itemEffect = self:createItemEffectTable();
            table.insert(unit.itemEffects, itemEffect);
        end
        unit:makeItemEffectsActive();
    end
end

function CreateCastBand()
    local newCastBand = Create(Item, CastBand);
    return newCastBand;
end

return {CreateCastBand, CastBand}