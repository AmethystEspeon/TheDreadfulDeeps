local SpellList = require("Spells.SpellList")
local Board = require("Core.Board")
local CardPool = {};

function CardPool:init()
    self.Common = {
        Heal = {Cards = 1, Spell = SpellList.Heal(Board:getPlayer())};
        Cauterize = {Cards = 1, Spell = SpellList.Cauterize(Board:getPlayer())};
        Regeneration = {Cards = 1, Spell = SpellList.Regeneration(Board:getPlayer())};
        PrayToDarkness = {Cards = 1, Spell = SpellList.PrayToDarkness(Board:getPlayer())};

        Cards = 4;
    };

    self.Rare = {
        ArcaneConversion = {Cards = 1, Spell = SpellList.ArcaneConversion(Board:getPlayer())};
        Shatter = {Cards = 1, Spell = SpellList.Shatter(Board:getPlayer())};

        Cards = 2;
    };

    self.Epic = {
        FeralLunge = {Cards = 1, Spell = SpellList.FeralLunge(Board:getPlayer())};
        RewindFate = {Cards = 1, Spell = SpellList.RewindFate(Board:getPlayer())};

        Cards = 2;
    };

    self.Legendary = {
        Miracle = {Cards = 1, Spell = SpellList.Miracle(Board:getPlayer())};

        Cards = 1;
    };
    
    self.totalCards = 9;
    self:CheckCardCount();
end

function CardPool:CheckCardCount()
    self.totalCards = 0;
    for rarity in pairs(CardPool) do
        if rarity.Cards then    
            rarity.Cards = 0;
            for spell in pairs(rarity) do
                if spell.getCardCount then
                    spell.Cards = spell.Spell:getCardCount(true);
                    rarity.Cards = rarity.Cards + spell.Cards;
                else
                    spell.Cards = 0;
                end
            end
            self.totalCards = self.totalCards + rarity.Cards;
        end
    end
end

return CardPool