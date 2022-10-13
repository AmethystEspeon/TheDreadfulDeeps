local SpellList = require("Spells.SpellList")
local Board = require("Core.Board")
local CardPool = {};

function CardPool:init()
    self.Common = {
        Heal = {Cards = 1, Spell = SpellList.Heal(Board:getPlayer()), inRewards = false};
        Cauterize = {Cards = 1, Spell = SpellList.Cauterize(Board:getPlayer()), inRewards = false};
        Regeneration = {Cards = 1, Spell = SpellList.Regeneration(Board:getPlayer()), inRewards = false};
        PrayToDarkness = {Cards = 1, Spell = SpellList.PrayToDarkness(Board:getPlayer()), inRewards = false};

        Cards = 4;
    };

    self.Rare = {
        ArcaneConversion = {Cards = 1, Spell = SpellList.ArcaneConversion(Board:getPlayer()), inRewards = false};
        Shatter = {Cards = 1, Spell = SpellList.Shatter(Board:getPlayer()), inRewards = false};

        Cards = 2;
    };

    self.Epic = {
        FeralLunge = {Cards = 1, Spell = SpellList.FeralLunge(Board:getPlayer()), inRewards = false};
        RewindFate = {Cards = 1, Spell = SpellList.RewindFate(Board:getPlayer()), inRewards = false};

        Cards = 2;
    };

    self.Legendary = {
        Miracle = {Cards = 1, Spell = SpellList.Miracle(Board:getPlayer()), inRewards = false};

        Cards = 1;
    };
    
    self.totalCards = 9;
    self:checkCardCount(true);
end

function CardPool:checkCardCount(preventDupes)
    self.totalCards = 0;
    for k,rarity in pairs(CardPool) do
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

function CardPool:setInRewards(searchSpell, bool)
    for rarity in pairs(CardPool) do
        if not rarity.Cards then
            goto ENDCARD
        end
        for spell in pairs(rarity) do
            if spell.Spell and spell.Spell.name == searchSpell.name then
                spell.inRewards = bool;
            end
        end
        ::ENDCARD::
    end
end

return CardPool