local Spells = require("Spells");
local Unit = require("Unit");
local PlayerInput = require("PlayerInput");


local function debugPrint(...)
    print(...)
end


--BAR SIZES--
local WIDTH = 150;
local HEIGHT = 60;

--POSITIONS--
local CENTERX = (love.graphics.getWidth()-WIDTH)*0.5;
local CENTERY = (love.graphics.getHeight()-HEIGHT)*0.5;
local STARTINGENEMYBARX = CENTERX+1.8*WIDTH;
local STARTINGENEMYBARY = love.graphics.getHeight()-(9)*(HEIGHT+3);

--USED VARIABLES--
local scene = "fight";
local timer = 0;
local allUnits = {enemies = {}, allies = {}};
local playerBars = {};
local tankSlot = 2

local player = Unit:newUnit{

    maxHealth = 300,
    health = 150,
    maxMana = 100,
    mana = 100,
    baseAttack = 10,
    attack = 10,
    team = "player",
    spells = {},
}

Spells:setKnownSpells(player)
Spells:addSpell(player, {name = "heal", maxCooldown = 3, currentCooldown = 0, manaCost = 10});
Spells:addSpell(player, {name = "cauterize", maxCooldown = 10, currentCooldown = 0, manaCost = 25});
Spells:setSpellSlot(1, Spells:getKnownSpell("heal"))
Spells:setSpellSlot(2, Spells:getKnownSpell("cauterize"))

local enemy1 = Unit:newUnit{
    maxHealth = 100,
    health = 100,
    maxMana = nil,
    mana = nil,
    baseAttack = 10,
    attack = 1,
    team = "enemy",
    buffs = {},
}

local ally1 = Unit:newUnit{
    maxHealth = 100,
    health = 100,
    maxMana = 5,
    mana = 1,
    baseAttack = 10,
    attack = 5,
    team = "ally",
    buffs = {},
}

--allies[1] is always player
table.insert(allUnits.allies, player);
table.insert(allUnits.enemies, enemy1);
table.insert(allUnits.allies, ally1)

--GLOBAL VARIABLES--
local enemyFrames = {};
local allyFrames = {{ x = CENTERX-1, y = love.graphics.getHeight()*(2/3)-1, w = WIDTH+2, h = HEIGHT+2}, { x = CENTERX-1+WIDTH+8, y = love.graphics.getHeight()*(2/3)-1, w = WIDTH+2, h = HEIGHT+2}};
local frames = {enemyFrames, allyFrames};

function love.load()
    --createPlayerBars()
end

local function drawPlayerBars()
    ----Background----
    love.graphics.setColor(1,1,1);
    --Health--
    love.graphics.rectangle("fill", CENTERX-1,love.graphics.getHeight()*(2/3)-1, WIDTH+2, HEIGHT+2);
    --Mana--
    love.graphics.rectangle("fill", CENTERX-1,love.graphics.getHeight()*(2/3)+HEIGHT+1, WIDTH+2, HEIGHT/4+2);

    ----Bars----
    --Health Bar--
    local green = 1 * (player.health/player.maxHealth);
    local red = 1 - green;
    love.graphics.setColor(red, green, 0);
    love.graphics.rectangle("fill", CENTERX, love.graphics.getHeight()*(2/3), WIDTH*player.health/player.maxHealth, HEIGHT);

    --Mana Bar--
    love.graphics.setColor(0,0,1);
    love.graphics.rectangle("fill", CENTERX,love.graphics.getHeight()*(2/3)+HEIGHT+2, WIDTH*player.mana/player.maxMana, HEIGHT/4);
end

local function drawEnemyBar(i)
    local enemy = allUnits.enemies[i];
    ----Background----
    if enemy:isDead() then
        love.graphics.setColor(0.5,0.5,0.5);
    else
        love.graphics.setColor(1,1,1);
    end
    love.graphics.rectangle("fill", STARTINGENEMYBARX-1,STARTINGENEMYBARY+i*(HEIGHT/2+6)-1, WIDTH+2, HEIGHT/2+2);

    ----Bar----
    love.graphics.setColor(1, 0, 0);
    love.graphics.rectangle("fill", STARTINGENEMYBARX, STARTINGENEMYBARY+i*(HEIGHT/2+6), WIDTH*enemy.health/enemy.maxHealth, HEIGHT/2);
end

local function drawAllyBars(i)
    local ally = allUnits.allies[i];
    ----Background----
    if ally:isDead() then
        love.graphics.setColor(.6,.6,.6);
    else
        love.graphics.setColor(1,1,1);
    end
    love.graphics.rectangle("fill", CENTERX-1+(i-1)*(WIDTH+8),love.graphics.getHeight()*(2/3)-1, WIDTH+2, HEIGHT+2);
    if ally:hasMana() then
        love.graphics.rectangle("fill", CENTERX-1+(i-1)*(WIDTH+8),love.graphics.getHeight()*(2/3)+HEIGHT+1, WIDTH+2, HEIGHT/4+2);
    end


    ----Bars----
    --Health Bar--
    local green = 1 * (ally.health/ally.maxHealth);
    local red = 1 - green;
    love.graphics.setColor(red, green, 0);
    love.graphics.rectangle("fill", CENTERX+(i-1)*(WIDTH+8), love.graphics.getHeight()*(2/3), WIDTH*ally.health/ally.maxHealth, HEIGHT);

    --Mana Bar--
    if ally:hasMana() then
        love.graphics.setColor(0,0,1);
        love.graphics.rectangle("fill", CENTERX+(i-1)*(WIDTH+8),love.graphics.getHeight()*(2/3)+HEIGHT+2, WIDTH*ally.mana/ally.maxMana, HEIGHT/4);
    end
end

local function drawSpellBar()
    local scale = 0.15
    for i=1, 10 do
        local spell = Spells:getSpellSlot(i)
        if spell and spell.name then
            Spells:drawCooldown("images/" .. spell.name .. ".png",spell.maxCooldown, spell.currentCooldown, 200+((512+20)*scale*(i-1)), 500, scale)
        end
    end
end

local function ProgressAuras(enemy, ally, dt)
    enemy = enemy or {}
    ally = ally or {}
    for i=1, #enemy do
        enemy[i]:progressBuffs(dt);
        enemy[i]:progressDebuffs(dt);
    end
    for i=1, #ally do
        ally[i]:progressBuffs(dt);
        ally[i]:progressDebuffs(dt);
    end
end

function love.draw()
    if scene == "fight" then
        drawPlayerBars();
        player:addMana(0.3);
        player:makeAttack(allUnits.enemies[1]);
        for i = 1, #allUnits.enemies do
            if not allUnits.enemies[i].dead then
                allUnits.enemies[i]:makeAttack(allUnits.allies[tankSlot]);
            end
            drawEnemyBar(i);
        end

        for i = 2, #allUnits.allies do
            if not allUnits.allies[i].dead then
                allUnits.allies[i]:makeAttack(allUnits.enemies[1]);
            end
            allUnits.allies[i]:makeAttack(allUnits.enemies[1]);
            drawAllyBars(i)
        end

        drawSpellBar()
    end
end

function love.update(dt)
    Spells:ProgressSpellCooldowns(allUnits[2], allUnits[1], dt);
    ProgressAuras(allUnits.allies, allUnits.enemies,dt)
end

function love.keypressed(key, scanCode, isRepeat)
    if scene == "fight" then
        PlayerInput:FIGHT_keyCheck(key, scanCode, player, allUnits, frames);
    end
end