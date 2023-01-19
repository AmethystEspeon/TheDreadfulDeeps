local SpellList = require("Spells.SpellList");
local UnitList = require("Units.UnitList");
local Board = require("Core.Board");
local PlayerInput = require("Core.PlayerInput");
local SceneList = require("Core.SceneList");
local SpellBook = require("Core.SpellBook");
local UnitCardPool = require("Units.UnitCardPool");
local EnemyDirector = require("Directors.EnemyDirector");
local RewardDirector = require("Directors.RewardDirector");

local initialized = false;

--POSITIONS--
local ScreenWidth = love.graphics.getWidth();
local ScreenHeight = love.graphics.getHeight();
local CenterX = (ScreenWidth-Board.AllyBarWidth)*0.5;
local CenterY = (ScreenHeight-Board.AllyBarHeight)*0.5;
local StartingEnemyBarX = CenterX+1.8*Board.EnemyBarWidth;
local StartingEnemyBarY = love.graphics.getHeight()-(9)*(Board.EnemyBarHeight+3);

SceneList.currentScene = SceneList.spellBook;
SpellBook:setNextScene(SceneList.fight, true);

-------------------
--LOCAL FUNCTIONS--
-------------------
local function changeSceneFromFight()
    if Board:getNumberAliveAllies() == 0 then
        SceneList.currentScene = SceneList.gameOver;
    elseif Board:getNumberAliveEnemies() == 0 then
        local currentTokens = EnemyDirector:getTokens();
        EnemyDirector:addTokens(currentTokens*0.1);
        RewardDirector:getRewards()
        SceneList.currentScene = SceneList.reward;
    end
end

local function changeSceneFromReward(reward)
    local player = Board:getPlayer();
    player:disableItemEffects();
    player.manaPerSecond = player.manaPerSecond + player.manaRegenPerLevel;
    player.maxMana = player.maxMana + player.maxManaPerLevel;
    player:enableItemEffects();
    Board:healAfterFight(.20)
    Board:resetEnemyBoard();
    UnitCardPool:resetEnemyPool();
    EnemyDirector:fillBoard();
end
------------------
--LOVE FUNCTIONS--
------------------
function love.load()
    Board:init();
local player = UnitList.Priest();
local dps1 = UnitList.BasicDPS();
local dps2 = UnitList.BasicDPS();
local dps3 = UnitList.BasicDPS();
local tank = UnitList.BasicTank()

Board:addAlly(player);
Board:addAlly(dps1);
Board:addAlly(dps2);
Board:addAlly(dps3);
Board:addAlly(tank);
SpellBook:init();
--Testing Spells Here-
SpellBook:setSpellsInSpellBook();

    UnitCardPool:init();
    EnemyDirector:init();
    RewardDirector:init();
    --TODO: REPLACE THIS
    EnemyDirector:fillBoard();
    initialized = true;
end

function love.draw()
    if SceneList.currentScene == SceneList.fight or SceneList.currentScene == SceneList.reward then
        Board:drawAllies(CenterX, love.graphics.getHeight()*(2/3), 1);
        Board:drawEnemies(StartingEnemyBarX, StartingEnemyBarY, 0.6);
        Board:drawSpells();
    end
    if SceneList.currentScene == SceneList.reward then
        RewardDirector:drawRewards()
    end
    if SceneList.currentScene == SceneList.spellBook then
        Board:drawSpells();
        SpellBook:draw();
    end
end

function love.update(dt)
    if SceneList.currentScene == SceneList.fight then
        changeSceneFromFight();
        Board:useAttacks(dt);
        Board:useAbilities(dt);
        Board:useManaGain(dt);
        Board:useAurasTick(dt);
        Board:tickAllCooldowns(dt);
        Board:reapAuras();
    end
    if SceneList.currentScene == SceneList.reward and #RewardDirector.rewardFrame.children == 0 then
        if RewardDirector.currentReward then
            return;
        end
        changeSceneFromReward();
        SpellBook:setSpellsInSpellBook();
        SpellBook:setNextScene(SceneList.fight, true);
        SceneList.currentScene = SceneList.spellBook;
    end
end

function love.keypressed(key, scanCode, isRepeat)
    if not initialized then
        return;
    end
    if SceneList.currentScene == SceneList.fight then
        PlayerInput:fightSceneKeyCheck(key, scanCode);
    end
end

function love.mousepressed(x,y,button,istouch,presses)
    if not initialized then
        return;
    end
    if SceneList.currentScene == SceneList.reward and button == 1 then
        PlayerInput:rewardMousePressed(x,y);
        return;
    end
    if SceneList.currentScene == SceneList.spellBook and button == 1 then
        PlayerInput:spellBookMousePressed(x,y, Board.spellBar);
        return;
    end
end

function love.mousereleased(x,y,button,istouch,presses)
    if not initialized then
        return;
    end
    if SceneList.currentScene == SceneList.reward and button == 1 then
        local reward = PlayerInput:rewardMouseReleased(x,y);
        if reward then
            RewardDirector:chooseReward(reward);
        end
        return;
    end
    if SceneList.currentScene == SceneList.spellBook and button == 1 then
        PlayerInput:spellBookMouseReleased(x,y, Board.spellBar);
        return;
    end
end
