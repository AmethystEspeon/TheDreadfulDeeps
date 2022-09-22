local function debugPrint(...)
    print(...)
end

--TODO: Make healthbar change based on health%

--HEALTHBAR SIZES
local WIDTH = 150
local HEIGHT = 75

scene = "fight"
local enemies = {}
local allies = {}
local player = {baseHealth = 300, baseAtk = 10, maxHealth = 300, currentHealth = 300, currentAtk = 10}
local playerBars = {health = {}, mana = {}}

function love.load()
    createPlayerBars()
end

function createPlayerBars()
    love.graphics.setColor(255,255,255)
    playerBars.health.background = love.graphics.rectangle("fill", love.graphics.getWidth()*0.43,love.graphics.getHeight()*(2/3), WIDTH+1, HEIGHT+1)
    playerBars.mana.background = love.graphics.rectangle("fill", love.graphics.getWidth()*0.43,love.graphics.getHeight()*(2/3)+HEIGHT+2, WIDTH+1, HEIGHT/4+1)
end

function love.draw()
    if scene == "fight" then
        --love.graphics.draw(playerBars.health.background)
        --love.graphics.draw(playerBars.mana.background)
        drawPlayerBars()--[[
        for i = 1, #enemies do
            drawEnemyBars(i)
        end

        for i = 1, #allies do
            drawAllyBars(i)
        end]]
    end
end

function drawPlayerBars()
    local green = 1 * (player.currentHealth/player.maxHealth)
    local red = 1 - green
    love.graphics.setColor(red, green, 0)
    playerBars.health.healthBar = love.graphics.rectangle("fill", love.graphics.getWidth()*0.43,love.graphics.getHeight()*(2/3), WIDTH*player.currentHealth/player.maxHealth, HEIGHT)
    if player.currentHealth > 0 then
        player.currentHealth = player.currentHealth - 1
    elseif player.currentHealth <= 0 then
        player.currentHealth = player.maxHealth
    end

    debugPrint("Green: " .. green .. "\nRed: " .. red)
end