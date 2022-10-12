local SpellIdentifierList = require("Spells.SpellIdentifierList");
local SpellList = require("Spells.SpellList");
local CardPool = require("Spells.CardPool");

local Reward = {
    rarityChance = {
        common = 50,
        rare = 30,
        epic = 15,
        legendary = 5,
        --50+30=80+15=95+5=100
    },
    rewards = {},
}

------------------
--Core Functions--
------------------
function Reward:init()
    CardPool:init();
end

--Randomize the RNG
math.randomseed(os.time());
math.random(); math.random(); math.random();

local function getRarityChance(minimumRarity, maximumRarity)
    local min, max
    if minimumRarity == SpellIdentifierList.Rarity.Legendary then
        min = Reward.rarityChance.common+Reward.rarityChance.rare+Reward.rarityChance.epic+1;
    elseif minimumRarity == SpellIdentifierList.Rarity.Epic then
        min = Reward.rarityChance.common+Reward.rarityChance.rare+1;
    elseif minimumRarity == SpellIdentifierList.Rarity.Rare then
        min = Reward.rarityChance.common+1;
    else --minimumRarity == SpellIdentifierList.Rarity.Common
        min = 1;
    end
    if maximumRarity == SpellIdentifierList.Rarity.Common then
        max = Reward.rarityChance.common;
    elseif maximumRarity == SpellIdentifierList.Rarity.Rare then
        max = Reward.rarityChance.common+Reward.rarityChance.rare;
    elseif maximumRarity == SpellIdentifierList.Rarity.Epic then
        max = Reward.rarityChance.common+Reward.rarityChance.rare+Reward.rarityChance.epic;
    else --maximumRarity == SpellIdentifierList.Rarity.Legendary then
        max = 100;
    end
    return min, max;
end

function Reward:getRandomRarity(minimumRarity, maximumRarity)
    local chance = math.random(getRarityChance(minimumRarity, maximumRarity));
    if chance <= Reward.rarityChance.common then
        return SpellIdentifierList.Rarity.Common;
    elseif chance <= Reward.rarityChance.common + Reward.rarityChance.rare then
        return SpellIdentifierList.Rarity.Rare;
    elseif chance <= Reward.rarityChance.common + Reward.rarityChance.rare + Reward.rarityChance.epic then
        return SpellIdentifierList.Rarity.Epic;
    else --if chance > all the others
        return SpellIdentifierList.Rarity.Legendary;
    end
end

---------------------
--CREATORS/REMOVERS--
---------------------
function Reward:addReward(reward)
    table.insert(self.rewards, reward);
end

function Reward:clearRewards()
    self.rewards = {};
end

local function getCard(rarity, randomCard)
    if rarity == SpellIdentifierList.Rarity.Common then
        for k,v in pairs(CardPool.Common) do
            if type(v) ~= "table" then
                goto ENDCOMMON
            end
            randomCard = randomCard - v.Cards;
            if randomCard <= 0 then
                return v.Spell;
            end
            ::ENDCOMMON::
        end
    end
    if rarity == SpellIdentifierList.Rarity.Rare then
        for k,v in pairs(CardPool.Rare) do
            if type(v) ~= "table" then
                goto ENDRARE
            end
            randomCard = randomCard - v.Cards;
            if randomCard <= 0 then
                return v.Spell;
            end
            ::ENDRARE::
        end
    end
    if rarity == SpellIdentifierList.Rarity.Epic then
        for k,v in pairs(CardPool.Epic) do
            if type(v) ~= "table" then
                goto ENDEPIC
            end
            randomCard = randomCard - v.Cards;
            if randomCard <= 0 then
                return v.Spell;
            end
            ::ENDEPIC::
        end
    end
    if rarity == SpellIdentifierList.Rarity.Legendary then
        for k,v in pairs(CardPool.Legendary) do
            if type(v) ~= "table" then
                goto ENDLEGENDARY
            end
            randomCard = randomCard - v.Cards;
            if randomCard <= 0 then
                return v.Spell;
            end
            ::ENDLEGENDARY::
        end
    end
end

--Check out weighted pool for another way
function Reward:generateReward(minimumRarity, maximumRarity)
    local rarity = self:getRandomRarity(minimumRarity, maximumRarity);
    local cards = 0;
    if rarity == SpellIdentifierList.Rarity.Common then
        cards = CardPool.Common.Cards;
    elseif rarity == SpellIdentifierList.Rarity.Rare then
        cards = CardPool.Rare.Cards;
    elseif rarity == SpellIdentifierList.Rarity.Epic then
        cards = CardPool.Epic.Cards;
    else --rarity == SpellIdentifierList.Rarity.Legendary then
        cards = CardPool.Legendary.Cards;
    end
    local randomCard = math.random(cards);
    return getCard(rarity, randomCard);
end

function Reward:chooseReward(reward, player)
    if not reward then
        return false;
    end
    if reward.item then
        table.insert(player.items, reward);
    elseif reward.spell then
        table.insert(player.spells, reward);
    end
    Reward:clearRewards();

    return true;
end

--------------------
--SCREEN FUNCTIONS--
--------------------
function Reward:drawGrayScreen(screenWidth, screenHeight)
    love.graphics.push();
    love.graphics.setColor(0.2, 0.2, 0.2,0.7);
    love.graphics.rectangle("fill", 0,0, screenWidth, screenHeight);
    love.graphics.pop();
end

function Reward:drawReward(screenWidth, screenHeight)
    local scale = 0.3;
    love.graphics.push();
    
    --get width of reward screen
    local totalWidth = 0;
    for i, v in ipairs(self.rewards) do
        totalWidth = totalWidth + screenWidth*0.3;
    end
    --get X positions of each reward
    for i, v in ipairs(self.rewards) do
        self.rewards[i].xPos = screenWidth*0.5 - totalWidth*0.5+totalWidth/#self.rewards*(i-1);
    end
    --draw rectangle for all rewards
    love.graphics.setColor(207,185,151,1); --Beige color picks I guess?
    love.graphics.rectangle("fill", 1/2*totalWidth, 50, totalWidth, screenHeight*0.8);
    
    --draw individual rewards
    for i, v in ipairs(self.rewards) do
        --draw name of reward
        love.graphics.printf(v.name, self.rewards[i].xPos, 50+10, screenWidth*0.3, "center");
        --draw image of reward
        love.graphics.push();
        love.graphics.scale(scale);
        love.graphics.draw(v.image, self.rewards[i].xPos/scale, (50+10+20)/scale);
        love.graphics.pop();
        --draw description of reward
        --love.graphics.printf(v.description, self.rewards[i].xPos, 50+10+20+154+20, screenWidth*0.3, "center");
        --draw choose button
        love.graphics.setColor(225,198,153,1);
        love.graphics.rectangle("fill", self.rewards[i].xPos+screenWidth*0.3*0.3, screenHeight*0.8-50, screenWidth*0.3*0.7, 50);
        love.graphics.printf("Choose",self.rewards[i].xPos, screenHeight*0.8-50, screenWidth*0.3, "center");
        --add choose button locations into table
        self.rewards[i].buttonPos = {x = self.rewards[i].xPos+screenWidth*0.3*0.3, y = screenHeight*0.8-50, w = screenWidth*0.3*0.7, h = 50};
    end
    love.graphics.pop()
end

return Reward
--Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);