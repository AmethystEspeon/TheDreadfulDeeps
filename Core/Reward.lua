--TODO: What happens when all cards are picked? (Can this even happen?)

local SpellIdentifierList = require("Spells.SpellIdentifierList");
local SpellList = require("Spells.SpellList");
local SpellCardPool = require("Spells.SpellCardPool");

local Reward = {
    rarityChance = {
        common = 50,
        rare = 30,
        epic = 15,
        legendary = 5,
        --50+30=80+15=95+5=100
    },
    rewards = {},
    rewardChosen = false,
}

------------------
--Core Functions--
------------------
function Reward:init()
    SpellCardPool:init();
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
    if chance <= Reward.rarityChance.common and SpellCardPool.Common.Cards ~= 0 then
        return SpellIdentifierList.Rarity.Common;
    elseif chance <= Reward.rarityChance.common + Reward.rarityChance.rare and SpellCardPool.Rare.Cards ~= 0 then
        return SpellIdentifierList.Rarity.Rare;
    elseif chance <= Reward.rarityChance.common + Reward.rarityChance.rare + Reward.rarityChance.epic and SpellCardPool.Epic.Cards ~= 0 then
        return SpellIdentifierList.Rarity.Epic;
    else --if chance > all the others
        return SpellIdentifierList.Rarity.Legendary;
    end
end

---------------------
--CREATORS/REMOVERS--
---------------------
function Reward:addReward(reward)
    if reward then
        table.insert(self.rewards, reward);
    end
end

function Reward:clearRewards()
    self.rewards = {};
end

local function drawCard(randomCard, value)
    if type(value) ~= "table" then
        return randomCard, nil;
    end
    randomCard = randomCard - value.Cards;
    if randomCard <= 0 then
        value.inRewards = true;
        return 0, value;
    end
    return randomCard, nil;
end

local function getCard(rarity, randomCard)
    local pick;
    if rarity == SpellIdentifierList.Rarity.Common then
        for k,v in pairs(SpellCardPool.Common) do
            randomCard, pick = drawCard(randomCard, v)
            if pick then
                return pick.Spell;
            end
        end
    end
    if rarity == SpellIdentifierList.Rarity.Rare then
        for k,v in pairs(SpellCardPool.Rare) do
            randomCard, pick = drawCard(randomCard, v)
            if pick then
                return pick.Spell;
            end
        end
    end
    if rarity == SpellIdentifierList.Rarity.Epic then
        for k,v in pairs(SpellCardPool.Epic) do
            randomCard, pick = drawCard(randomCard, v)
            if pick then
                return pick.Spell;
            end
        end
    end
    if rarity == SpellIdentifierList.Rarity.Legendary then
        for k,v in pairs(SpellCardPool.Legendary) do
            randomCard, pick = drawCard(randomCard, v)
            if pick then
                return pick.Spell;
            end
        end
    end
end

--Check out weighted pool for another way
function Reward:generateReward(minimumRarity, maximumRarity)
    SpellCardPool:checkCardCount(true);
    local rarity = self:getRandomRarity(minimumRarity, maximumRarity);
    local cards = 0;
    --print(rarity)
    if rarity == SpellIdentifierList.Rarity.Common then
        cards = SpellCardPool.Common.Cards;
    elseif rarity == SpellIdentifierList.Rarity.Rare then
        cards = SpellCardPool.Rare.Cards;
    elseif rarity == SpellIdentifierList.Rarity.Epic then
        cards = SpellCardPool.Epic.Cards;
    else --rarity == SpellIdentifierList.Rarity.Legendary then
        cards = SpellCardPool.Legendary.Cards;
    end
    local randomCard = math.random(cards);
    local randomSpell = getCard(rarity, randomCard);
    SpellCardPool:setInRewards(randomSpell, true);
    return randomSpell;
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
    for i, v in pairs(self.rewards) do
        if v ~= reward then
            SpellCardPool:setInRewards(v, false);
        end
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
    local partitionHeight = screenHeight*0.8;
    local partitionWidth = screenWidth*0.3;
    local centerX = screenWidth*0.5;
    local centerY = screenHeight*0.5;
    local scale = 0.3;
    love.graphics.push();
    
    --get width of reward screen--
    local totalWidth = 0;
    --local totalHeight = partitionHeight;
    for i, v in ipairs(self.rewards) do
        totalWidth = totalWidth + partitionWidth;
    end
    
    --get reward table X position--
    local rewardTableX = centerX - totalWidth*0.5;
    local rewardTableY = centerY - partitionHeight*0.5;

    --get startingx for each reward--
    for i = 1, #self.rewards do
        self.rewards[i].startingX = rewardTableX + (i-1)*partitionWidth;
    end

    --draw rectangle for all rewards
    love.graphics.setColor(love.math.colorFromBytes(207,185,151)); --Beige color picks I guess?
    love.graphics.rectangle("fill", rewardTableX, rewardTableY, totalWidth, partitionHeight);
    
    --draw individual rewards
    for i, v in ipairs(self.rewards) do
        --draw name of reward
        love.graphics.setColor(0,0,0,1);
        love.graphics.printf(v.name, self.rewards[i].startingX, rewardTableY+10, partitionWidth, "center");
        --draw image of reward
        love.graphics.push();
        local imageWidth = v.image:getWidth();
        local imageHeight = v.image:getHeight();
        love.graphics.scale(scale);
        love.graphics.setColor(1,1,1,1);
        love.graphics.draw(v.image, (self.rewards[i].startingX+0.5*partitionWidth-0.5*imageWidth*scale)/scale, (rewardTableY+10+20)/scale);
        love.graphics.pop();
        --draw description of reward
        love.graphics.setColor(0,0,0,1);
        love.graphics.printf(v.description, self.rewards[i].startingX+partitionWidth*0.1, rewardTableY+10+imageHeight*scale+30, partitionWidth*0.8, "center");
        --draw choose button
        love.graphics.setColor(love.math.colorFromBytes(225,198,153));
        love.graphics.rectangle("fill", self.rewards[i].startingX+partitionWidth*0.3, rewardTableY+partitionHeight*0.8, partitionWidth*0.4, 50);
        love.graphics.setColor(0,0,0);
        love.graphics.printf("Choose",self.rewards[i].startingX, rewardTableY+partitionHeight*0.84, partitionWidth, "center");
        --add choose button locations into table
        self.rewards[i].buttonPos = {x = self.rewards[i].startingX+partitionWidth*0.3, y = rewardTableY+partitionHeight*0.8, w = partitionWidth*0.4, h = 50};
    end
    love.graphics.pop()
end

return Reward
--Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);