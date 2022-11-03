local SpellList = require("Spells.SpellList");
local SpellIdentifierList = require("Spells.SpellIdentifierList");
local Board = require("Core.Board");
local SpellCardPool = {};

function SpellCardPool:init()
    self.Common = {
        Cards = 0;
    };

    self.Rare = {
        Cards = 0;
    };

    self.Epic = {
        Cards = 0;
    };

    self.Legendary = {
        Cards = 0;
    };
    self.totalCards = 9;
    for k,v in pairs(SpellList) do
        local spellName = v(Board:getPlayer())
        if spellName.rarity == SpellIdentifierList.Rarity.Common then
            self.Common[spellName.name] = {Cards = 1, Spell = spellName, inRewards = false}
            self.Common.Cards = self.Common.Cards + 1
        elseif spellName.rarity == SpellIdentifierList.Rarity.Rare then
            self.Rare[spellName.name] = {Cards = 1, Spell = spellName, inRewards = false}
            self.Rare.Cards = self.Rare.Cards + 1
        elseif spellName.rarity == SpellIdentifierList.Rarity.Epic then
            self.Epic[spellName.name] = {Cards = 1, Spell = spellName, inRewards = false}
            self.Epic.Cards = self.Epic.Cards + 1
        elseif spellName.rarity == SpellIdentifierList.Rarity.Legendary then
            self.Legendary[spellName.name] = {Cards = 1, Spell = spellName, inRewards = false}
            self.Legendary.Cards = self.Legendary.Cards + 1
        end
        self.totalCards = self.totalCards + 1;
    end
    self:checkCardCount(true);
end

function SpellCardPool:checkCardCount(preventDupes)
    self.totalCards = 0;
    for k,rarity in pairs(SpellCardPool) do
        if type(rarity) == "table" then
            rarity.Cards = 0;
            for l, spell in pairs(rarity) do
                if type(spell) == "table" then
                    if spell.Spell.getCardCount and spell.inRewards == false then
                        spell.Cards = spell.Spell:getCardCount(preventDupes);
                        rarity.Cards = rarity.Cards + spell.Cards;
                    else
                        spell.Cards = 0;
                    end
                end
            end
            self.totalCards = self.totalCards + rarity.Cards;
        end
    end
end


local function checkIfInRewards(searchSpell, bool, rarity)
    if not searchSpell then
        return;
    end
    if type(rarity) ~= "table" then
        return;
    end
    if not rarity.Cards then
        return;
    end
    for i, spell in pairs(rarity) do
        if type(spell) == "table" then
            if spell.Spell and spell.Spell.name == searchSpell.name then
                spell.inRewards = bool;
                print(spell.Spell.name, spell.inRewards)
            end
        end
    end
end

function SpellCardPool:setSpellInRewards(searchSpell, bool)
    for i, rarity in pairs(SpellCardPool) do
        checkIfInRewards(searchSpell, bool, rarity);
    end
end

return SpellCardPool