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
local enemies = {{baseHealth = 300, baseAtk = 10, maxHealth = 300, currentHealth = 300},{baseHealth = 300, baseAtk = 10, maxHealth = 300, currentHealth = 300}}
local allies = {}
local player = {baseHealth = 300, baseAtk = 10, baseMana = 100, maxHealth = 300, currentHealth = 300, maxMana= 100, currentMana = 100}
local playerBars = {health = {}, mana = {}}

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
    local green = 1 * (player.currentHealth/player.maxHealth)
    local red = 1 - green
    love.graphics.setColor(red, green, 0)
    love.graphics.rectangle("fill", CENTERX, love.graphics.getHeight()*(2/3), WIDTH*player.currentHealth/player.maxHealth, HEIGHT)

    --Mana Bar--
    love.graphics.setColor(0,0,225)
    love.graphics.rectangle("fill", CENTERX,love.graphics.getHeight()*(2/3)+HEIGHT+2, WIDTH*player.currentMana/player.maxMana, HEIGHT/4)
end

local function drawEnemyBar(i)
    local enemy = enemies[i]
    ----Background----
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", STARTINGENEMYBARX-1,STARTINGENEMYBARY+i*(HEIGHT/2+6)-1, WIDTH+2, HEIGHT/2+2)

    ----Bar----
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", STARTINGENEMYBARX, STARTINGENEMYBARY+i*(HEIGHT/2+6), WIDTH*enemy.currentHealth/enemy.maxHealth, HEIGHT/2)
end


function love.draw()
    if scene == "fight" then
        drawPlayerBars()
        for i = 1, #enemies do
            drawEnemyBar(i)
        end

        --[[for i = 1, #allies do
            drawAllyBars(i)
        end]]
    end
end

