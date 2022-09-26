local Spells = require("Spells")
local Unit = require("Unit")
local PlayerInput = require("PlayerInput")


local function debugPrint(...)
    print(...)
end


--BAR SIZES--
local WIDTH = 150
local HEIGHT = 60

--POSITIONS--
local CENTERX = (love.graphics.getWidth()-WIDTH)*0.5
local CENTERY = (love.graphics.getHeight()-HEIGHT)*0.5
local STARTINGENEMYBARX = CENTERX+1.8*WIDTH
local STARTINGENEMYBARY = love.graphics.getHeight()-(9)*(HEIGHT+3)

--USED VARIABLES--
local scene = "fight"
local allUnits = {enemies = {}, allies = {}}
local playerBars = {}

local player = Unit:newUnit{
    maxHealth = 300,
    health = 300,
    maxMana = 100,
    mana = 100,
    team = "player"
}

--allies[1] is always player
table.insert(allUnits.allies, player)

--GLOBAL VARIABLES--
EnemyFrames = {}
AllyFrames = {{ x = CENTERX-1, y = love.graphics.getHeight()*(2/3)-1, w = WIDTH+2, h = HEIGHT+2}}

function love.load()
    --createPlayerBars()
end

local function drawPlayerBars()
    ----Background----
    love.graphics.setColor(255,255,255)
    --Health--
    love.graphics.rectangle("fill", CENTERX-1,love.graphics.getHeight()*(2/3)-1, WIDTH+2, HEIGHT+2)
    --Mana--
    love.graphics.rectangle("fill", CENTERX-1,love.graphics.getHeight()*(2/3)+HEIGHT+1, WIDTH+2, HEIGHT/4+2)

    ----Bars----
    --Health Bar--
    local green = 1 * (player.health/player.maxHealth)
    local red = 1 - green
    love.graphics.setColor(red, green, 0)
    love.graphics.rectangle("fill", CENTERX, love.graphics.getHeight()*(2/3), WIDTH*player.health/player.maxHealth, HEIGHT)

    --Mana Bar--
    love.graphics.setColor(0,0,225)
    love.graphics.rectangle("fill", CENTERX,love.graphics.getHeight()*(2/3)+HEIGHT+2, WIDTH*player.mana/player.maxMana, HEIGHT/4)
end

local function drawEnemyBar(i)
    local enemy = allUnits.enemies[i]
    ----Background----
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", STARTINGENEMYBARX-1,STARTINGENEMYBARY+i*(HEIGHT/2+6)-1, WIDTH+2, HEIGHT/2+2)

    ----Bar----
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", STARTINGENEMYBARX, STARTINGENEMYBARY+i*(HEIGHT/2+6), WIDTH*enemy.health/enemy.maxHealth, HEIGHT/2)
end

function love.draw()
    allUnits.allies[1]:minusHealth(1)
    if allUnits.allies[1].health <= 0 then
        allUnits.allies[1]:addHealth(30000)
    end
    if scene == "fight" then
        drawPlayerBars()
        player:addMana(0.1)
        for i = 1, #allUnits.enemies do
            drawEnemyBar(i)
        end

        --[[for i = 2, #allUnits.allies do
            drawAllyBars(i)
        end]]
    end
end

function love.keypressed(key, scanCode, isRepeat)
    if scene == "fight" then
        PlayerInput:FIGHT_keyCheck(key, scanCode, player, allUnits)
    end
end