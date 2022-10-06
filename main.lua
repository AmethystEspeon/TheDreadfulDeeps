local SpellList = require("Spells.SpellList")
local UnitList = require("Units.UnitList")
local Board = require("Core.Board")
local PlayerInput = require("Core.PlayerInput")

--POSITIONS--
local CenterX = (love.graphics.getWidth()-Board.AllyBarWidth)*0.5;
local CenterY = (love.graphics.getHeight()-Board.AllyBarHeight)*0.5;
local StartingEnemyBarX = CenterX+1.8*Board.EnemyBarWidth;
local StartingEnemyBarY = love.graphics.getHeight()-(9)*(Board.EnemyBarHeight+3);

local scene = {fight = true};

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


function love.draw()
    if scene.fight then
        Board:drawAllies(CenterX, love.graphics.getHeight()*(2/3), 1);
        Board:drawEnemies(StartingEnemyBarX, StartingEnemyBarY, 0.6);
        Board:drawSpells(100, 500, 0.15)
    end
end

function love.update(dt)
    if scene.fight then
        Board:useAttacks(dt);
        Board:useAbilities(dt);
        Board:useManaGain(dt);
        Board:useAurasTick(dt);
        Board:tickAllCooldowns(dt);
        Board:reapBuffs();
    end
end

function love.keypressed(key, scanCode, isRepeat)
    if scene.fight then
        PlayerInput:fightSceneKeyCheck(key, scanCode, Board:getPlayer());
    end
end