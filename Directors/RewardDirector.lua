local Board = require("Core.Board");
local Table = require("Core.TableFuncs");
local UIList = require("UI.UIList");
local UnitCardPool = require("Units.UnitCardPool");

----------------------------------------------------
--TEMPORARY ADD INS UNTIL DONE WITH VERTICAL SLICE--
----------------------------------------------------
local SpellList = require("Spells.SpellList");
local UnitList = require("Units.UnitList");
local ItemList = require("Items.ItemList");

--==================================================
--==================================================
RewardDirector = {
    wave = 1,
    possibleRewards = {};
    rewardsOnScreen = {};
};

function RewardDirector:init()
    local frameSettings = {
        name = "RewardParent",
        w = 0,
        h = 0,
        x = love.graphics.getWidth()/2-love.graphics.getWidth()*0.3*0.5,
        y = love.graphics.getHeight()/2-love.graphics.getHeight()*0.8*0.5,
    };
    self.rewardFrame = UIList.Frame(frameSettings);
end

function RewardDirector:nextWave()
    local wave = self.wave + 1;
    self.wave = wave;
    if self.wave % 10 then
        UnitCardPool:increaseMaxUnits();
    end
end

function RewardDirector:getRewardForWave()
    print("Wave: " .. self.wave)
    --INITIAL UPGRADES--
    if self.wave == 1 then
        return self:getSpellReward();
    elseif self.wave == 2 then
        return self:getUnitReward();
    elseif self.wave == 3 then
        return self:getSpellReward();
    elseif self.wave == 4 then
        return self:getUpgradeNormalReward()
    elseif self.wave == 5 then
        return self:getUpgradeUniqueReward();
    elseif self.wave == 10 then
        return self:getItemReward();
    end

    if self.wave % 5 == 0 then
        local spell = self:getSpellReward();
        if spell then
            return spell;
        end
    end

    return self:getUpgradeNormalReward();
end

function RewardDirector:getSpellReward()
    local player = Board:getPlayer();
    local spells = {
        SpellList.Regeneration(player),
        SpellList.Miracle(player),
        SpellList.PrayToDarkness(player),
        SpellList.ArcaneConversion(player),
        SpellList.Cauterize(player),
        SpellList.RewindFate(player),
    };
    for i, spell in ipairs(spells) do
        if Table:contains(self.rewardsOnScreen, spell, true, true) then
            table.remove(spells, i);
        elseif Table:contains(player.spells, spell, true) then
            table.remove(spells, i);
        end
    end

    local spell;
    if #spells > 0 then
        spell = spells[math.random(#spells)];
        table.insert(self.rewardsOnScreen, spell);
    end
    return spell;
end

function RewardDirector:getItemReward()
    local items = {
        ItemList.CastBand();
        ItemList.DecayingPower();
        ItemList.OverloadBracelet();
    };
    for i, item in ipairs(items) do
        if Table:contains(self.rewardsOnScreen, item, true, true) then
            table.remove(items, i);
        end
    end
    local item;
    if #items > 0 then
        item = items[math.random(#items)];
        table.insert(self.rewardsOnScreen, item);
    end
    return item;
end

function RewardDirector:getUnitReward( )
    local units = {
        UnitList.Sabertooth(),
        UnitList.Survivalist(),
        UnitList.Bombardier(),
    }
    for i, unit in ipairs(units) do
        if Table:contains(self.rewardsOnScreen, unit, true, true) then
            table.remove(units, i);
        end
        print(unit.name)
    end
    local unit;
    if #units > 0 then
        unit = units[math.random(#units)];
        table.insert(self.rewardsOnScreen, unit);
    end
    return unit;
end

function RewardDirector:getUpgradeUniqueReward()
    local possibleUpgrades = {};
    local player = Board:getPlayer()
    local uniqueUpgrades = {
        player.spells[1].upgrades[1],
        player.spells[1].upgrades[2],
    }
    for i, upgrade in ipairs(uniqueUpgrades) do
        if Table:contains(self.rewardsOnScreen, upgrade, true, true) then
            table.remove(uniqueUpgrades, i);
        end
    end
    local upgrade;
    if #uniqueUpgrades > 0 then
        upgrade = uniqueUpgrades[math.random(#uniqueUpgrades)];
        table.insert(self.rewardsOnScreen, upgrade);
    end
    return upgrade;
end

function RewardDirector:getUpgradeNormalReward()
    local possibleUpgrades = {};
    for _, spell in pairs(Board:getPlayer().spells) do
        if spell.damageHealMultiplier ~= 0 then
            local upgrade = {normalUpgrade = true,
                            name = spell.name .. " " .. SpellIdentifierList.Upgrades.DamageHeal,
                            image = spell.image,
                            spellParent = spell,
                            upgradeType = SpellIdentifierList.Upgrades.DamageHeal,
                            description = "The damage/heal is an extra 10% stronger"
                            };
            if not Table:contains(self.rewardsOnScreen, upgrade, true, true) then
                table.insert(possibleUpgrades, upgrade);
            end
        end
        if spell.durationMultiplier ~= 0 then
            local upgrade = {normalUpgrade = true,
                            name = spell.name .. " " .. SpellIdentifierList.Upgrades.Duration,
                            image = spell.image,
                            spellParent = spell,
                            upgradeType = SpellIdentifierList.Upgrades.Duration,
                            description = "The duration is an extra 10% longer"
                            };
            if not Table:contains(self.rewardsOnScreen, upgrade, true, true) then
                table.insert(possibleUpgrades, upgrade);
            end
        end
        if spell.cooldown ~= 0 then
            local upgrade = {normalUpgrade = true,
                            name = spell.name .. " " .. SpellIdentifierList.Upgrades.Cooldown,
                            image = spell.image,
                            spellParent = spell,
                            upgradeType = SpellIdentifierList.Upgrades.Cooldown,
                            description = "The cooldown ticks an extra .1 second per second"
                            };
            if not Table:contains(self.rewardsOnScreen, upgrade, true, true) then
                table.insert(possibleUpgrades, upgrade);
            end
        end
    end
    local upgrade;
    if #possibleUpgrades > 0 then
        upgrade = possibleUpgrades[math.random(#possibleUpgrades)];
        table.insert(self.rewardsOnScreen, upgrade)
    end
    return upgrade
end

function RewardDirector:drawGrayScreen(screenWidth, screenHeight)
    love.graphics.push();
    love.graphics.setColor(0.2, 0.2, 0.2,0.7);
    love.graphics.rectangle("fill", 0,0, screenWidth, screenHeight);
    love.graphics.pop();
end

function RewardDirector:addReward(reward)
    if reward then
        local settings = {
            reward = reward,
            name = "Reward: " .. reward.name,
            w = love.graphics.getWidth()*0.3,
            h = love.graphics.getHeight()*0.8,
            texture = reward.image,
            parent = self.rewardFrame,
            buttonPressedColor = {0.4922,0.3906,0.2773}
        };
        if self.lastReward then
            settings.parent = self.lastReward;
            settings.offsetX = settings.w
            self.rewardFrame.children[1].offsetX = self.rewardFrame.children[1].offsetX-settings.w*0.5;
            self.rewardFrame:updatePosition();
        end
        RewardDirector.lastReward = UIList.RewardFrame(settings);
        --table.insert(self.rewards, reward);
    end
end

function RewardDirector:getRewardButtons()
    local allButtons = {};
    if not self.rewardFrame.children or #self.rewardFrame.children == 0 then
        return allButtons;
    end
    if #self.rewardFrame.children == 1 then
        return self.rewardFrame.children[1]:getAllButtons();
    end
    for i in self.rewardFrame.children do
        Table:addTable(allButtons, i:getAllButtons());
    end
    return allButtons;
end

function RewardDirector:getRewardSingle()
    local reward = self:getRewardForWave();
    table.insert(self.possibleRewards, reward);
    self:addReward(reward);
end

function RewardDirector:getRewards()
    self.possibleRewards = {};
    local numRewards = 3;
    if self.wave == 5 then
        numRewards = 2;
    end
    for i = 1, numRewards do
        self:getRewardSingle();
    end
    self:nextWave();
end

function RewardDirector:chooseReward(reward)
    if not reward then
        return false;
    end
    local player = Board:getPlayer();

    --Unit Replacement--
    if self.currentReward then
        Board:switchAlly(reward,self.currentReward);
        self.currentReward = nil;
        player:useItems();
        self:clearRewards();
        return;
    end

    --Reward Picking--
    if reward.item then
        table.insert(player.items, reward);
        player:useItems();
    end
    if reward.spell then
        player:disableItemEffects();
        table.insert(player.spells, reward);
        player:enableItemEffects();
    end
    if reward.normalUpgrade then
        player:disableItemEffects();
        reward.spellParent:upgrade(reward);
        player:enableItemEffects();
    end
    if reward.uniqueUpgrade then
        reward:choose();
    end
    if reward.isAlly then
        local immediateReplace, unit = self:setupUnitReplacement(reward);
        if immediateReplace then
            Board:switchAlly(unit, reward);
            player:useItems();
        else
            self.currentReward = reward;
            self.rewardsOnScreen = {};
            return; --Don't clear rewards
        end
    end
    self:clearRewards();
    self.rewardsOnScreen = {};
end

function RewardDirector:setupUnitReplacement(reward)
    RewardDirector:clearRewards();
    if reward.isTank then
        for _, unit in ipairs(Board.allies) do
            if unit.isTank then
                return true, unit;
            end
        end
    end
    if reward.isDPS then
        for _, unit in ipairs(Board.allies) do
            if unit.isDPS then
                RewardDirector:addReward(unit)
                return false, nil;
            end
        end
    end
end

function RewardDirector:clearRewards()
    self.possibleRewards = {};
    self.rewardsOnScreen = {};
    self.lastReward = nil;
    self.rewardFrame:deleteChildren();
end

function RewardDirector:drawRewards()
    self:drawGrayScreen(love.graphics.getWidth(), love.graphics.getHeight());
    self.rewardFrame:drawAllChildren();
end

return RewardDirector;