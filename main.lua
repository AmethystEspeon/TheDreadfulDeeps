local SpellList = require("Spells.SpellList")
local UnitList = require("Units.UnitList")
local Board = require("Core.Board")
local PlayerInput = require("Core.PlayerInput")
local SceneList = require("Core.SceneList")
local Reward = require("Core.Reward")

--POSITIONS--
local ScreenWidth = love.graphics.getWidth()
local ScreenHeight = love.graphics.getHeight()
local CenterX = (ScreenWidth-Board.AllyBarWidth)*0.5;
local CenterY = (ScreenHeight-Board.AllyBarHeight)*0.5;
local StartingEnemyBarX = CenterX+1.8*Board.EnemyBarWidth;
local StartingEnemyBarY = love.graphics.getHeight()-(9)*(Board.EnemyBarHeight+3);

local scene = SceneList.reward;

local player = UnitList.Priest();
local ally = UnitList.Sabertooth();
local enemy = UnitList.EarthShatterer();
Board:addAlly(player);
Board:addAlly(ally);
Board:addEnemy(enemy);
 
--Testing Spells Here-
table.insert(player.spells, SpellList.Cauterize(player));
table.insert(player.spells, SpellList.Regeneration(player));
player:placeInActiveSpellList(player.spells[2], 2);
player:placeInActiveSpellList(player.spells[3], 3);

function love.load()
    Reward:init();
    Reward:addReward(Reward:generateReward(SpellIdentifierList.Rarity.Common, SpellIdentifierList.Rarity.Legendary));
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
    if scene == SceneList.fight then
        PlayerInput:fightSceneKeyCheck(key, scanCode, Board:getPlayer());
    end
end

function love.mousepressed(x,y,button,istouch,presses)
    if scene == SceneList.reward and button == 1 then
        if Reward:chooseReward(PlayerInput:rewardGetMouseover(Reward.rewards),Board:getPlayer()) then
            scene = SceneList.fight;
        end
    end
end
