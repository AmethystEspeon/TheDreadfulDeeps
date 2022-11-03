--TODO: What happens when all cards are picked? (Can this even happen?)
local Table = require("Core.TableFuncs");
local SpellIdentifierList = require("Spells.SpellIdentifierList");
local SpellList = require("Spells.SpellList");
local SpellCardPool = require("Spells.SpellCardPool");
local Board = require("Core.Board");
local UIList = require("UI.UIList");

local Reward = {
    rarityChance = {
        common = 50,
        rare = 30,
        epic = 15,
        legendary = 5,
        --50+30=80+15=95+5=100
    },
    rewardChosen = false,
}

------------------
--Core Functions--
------------------
function Reward:init()
    SpellCardPool:init();
    local frameSettings = {
        name = "RewardParent",
        w = 0,
        h = 0,
        x = love.graphics.getWidth()/2-love.graphics.getWidth()*0.3*0.5,
        y = love.graphics.getHeight()/2-love.graphics.getHeight()*0.8*0.5,
    };
    self.rewards = UIList.Frame(frameSettings);
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
        local settings = {
            reward = reward,
            name = "Reward: " .. reward.name,
            w = love.graphics.getWidth()*0.3,
            h = love.graphics.getHeight()*0.8,
            texture = reward.image,
            parent = self.rewards,
            buttonPressedColor = {0.4922,0.3906,0.2773}
        };
        if self.lastReward then
            settings.parent = self.lastReward;
            settings.offsetX = settings.w
            self.rewards.children[1].offsetX = self.rewards.children[1].offsetX-settings.w*0.5;
            self.rewards:updatePosition();
        end
        Reward.lastReward = UIList.RewardFrame(settings);
        --table.insert(self.rewards, reward);
    end
end

function Reward:clearRewards()
    self.lastReward = nil;
    self.rewards:deleteChildren();
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
function Reward:generateSpellReward(minimumRarity, maximumRarity)
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
    SpellCardPool:setSpellInRewards(randomSpell, true);
    return randomSpell;
end

function Reward:generateUpgradeReward(minimumRarity, maximumRarity)
    --TODO: Implement weighted pool for upgrades
    local upgradeList = Board:getPlayer():getSpellUpgrades();
    local reward = upgradeList[math.random(#upgradeList)]
    reward.inRewards = true;
    return reward;
end

function Reward:chooseReward(reward, player)
    if not reward then
        return false;
    end
    if reward.item then
        table.insert(player.items, reward);
        --TODO: Create item stuff
    elseif reward.spell then
        table.insert(player.spells, reward);
        for i, v in pairs(self:getAllRewards()) do
            if v ~= reward then
                SpellCardPool:setSpellInRewards(v, false);
            end
        end
    elseif reward.upgrade then
        reward.choose();
        for i, v in pairs(self:getAllRewards()) do
            if v ~= reward then
                v.inRewards = false;
            end
        end
    end

    Reward:clearRewards();
    return true;
end

function Reward:getRewardButtons()
    local allButtons = {};
    if not self.rewards.children or #self.rewards.children == 0 then
        return;
    end
    if #self.rewards.children == 1 then
        return self.rewards.children[1]:getAllButtons();
    end
    for i in self.rewards.children do
        Table:addTable(allButtons, i:getAllButtons());
    end
    return allButtons;
end

function Reward:getAllRewards()
    local allRewards = {};
    if not self.rewards.children or #self.rewards.children == 0 then
        return;
    end
    if #self.rewards.children == 1 then
        return self.rewards.children[1]:getAllRewards();
    end
    for i in self.rewards.children do
        Table:addTable(allRewards, i:getAllRewards());
    end
    return allRewards;
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

function Reward:drawReward()
    self:drawGrayScreen(love.graphics.getWidth(), love.graphics.getHeight());
    self.rewards:drawAllChildren();
end

return Reward;
--Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);