local SpellList = require("Spells.SpellList");
local UnitList = require("Units.UnitList");
local Board = require("Core.Board");
local PlayerInput = require("Core.PlayerInput");
local SceneList = require("Core.SceneList");
local Reward = require("Core.Reward");
local UnitCardPool = require("Units.UnitCardPool");

local initialized = false;

--POSITIONS--
local ScreenWidth = love.graphics.getWidth();
local ScreenHeight = love.graphics.getHeight();
local CenterX = (ScreenWidth-Board.AllyBarWidth)*0.5;
local CenterY = (ScreenHeight-Board.AllyBarHeight)*0.5;
local StartingEnemyBarX = CenterX+1.8*Board.EnemyBarWidth;
local StartingEnemyBarY = love.graphics.getHeight()-(9)*(Board.EnemyBarHeight+3);

local scene = SceneList.fight;

local player = UnitList.Priest();
local dps1 = UnitList.BasicDPS();
local dps2 = UnitList.BasicDPS();
local dps3 = UnitList.BasicDPS();
local tank = UnitList.BasicTank()
local enemy1 = UnitList.EarthShatterer();
local enemy2 = UnitList.CrazedGhoul();
local enemy3 = UnitList.CrazedGhoul();
local enemy4 = UnitList.CrazedGhoul();

Board:addAlly(player);
Board:addAlly(dps1);
Board:addAlly(dps2);
Board:addAlly(dps3);
Board:addAlly(tank);
Board:addEnemy(enemy1);
Board:addEnemy(enemy2);
Board:addEnemy(enemy3);
Board:addEnemy(enemy4);
 
--Testing Spells Here-
table.insert(player.spells, SpellList.Cauterize(player));
table.insert(player.spells, SpellList.Regeneration(player));
player:placeInActiveSpellList(player.spells[2], 2);
player:placeInActiveSpellList(player.spells[3], 3);

function love.load()
    Reward:init();
    UnitCardPool:init();
    local reward1=Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);
    print(reward1.name)
    Reward:addReward(reward1);
    local reward2=Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);
    print(reward2.name)
    Reward:addReward(reward2);
    local reward3=Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary);
    print(reward3.name)
    Reward:addReward(reward3);

    initialized = true;
end

function love.draw()
    if scene == SceneList.fight or scene == SceneList.reward then
        Board:drawAllies(CenterX, love.graphics.getHeight()*(2/3), 1);
        Board:drawEnemies(StartingEnemyBarX, StartingEnemyBarY, 0.6);
        Board:drawSpells(100, 500, 0.15);
    end
    if scene == SceneList.reward then
        Reward:drawReward(ScreenWidth,ScreenHeight)
    end
end

function love.update(dt)
    if scene == SceneList.fight then
        Board:useAttacks(dt);
        Board:useAbilities(dt);
        Board:useManaGain(dt);
        Board:useAurasTick(dt);
        Board:tickAllCooldowns(dt);
        Board:reapBuffs();
    end
end

function love.keypressed(key, scanCode, isRepeat)
    if not initialized then
        return;
    end
    if scene == SceneList.fight then
        PlayerInput:fightSceneKeyCheck(key, scanCode, Board:getPlayer());
    end
end

function love.mousepressed(x,y,button,istouch,presses)
    if not initialized then
        return;
    end
    if scene == SceneList.reward and button == 1 then
        local chosenReward = PlayerInput:rewardGetMouseover(Reward.rewards)
        if chosenReward then
            print(chosenReward.name)
        end
        --[[if Reward:chooseReward(chosenReward,Board:getPlayer()) then
            
            scene = SceneList.fight;
        end]]
    end
end
