local function debugPrint(...)
    print(...)
end

--TODO: Make healthbar change based on health%

--HEALTHBAR SIZES
local WIDTH = 150
local HEIGHT = 75


local enemies = {}
local player = {basehealth = 300, baseatk = 10}

function drawLevel()
    love.graphics.clear()
    clearEnemies()
    drawEnemy(1)
    drawPlayer()
    love.graphics.present()
end

function clearEnemies()
    enemies = {}
    return enemies or nil
end

function drawEnemy(numEnemy)
    local x = 50
    local y = ((numEnemy-1)*(HEIGHT+1))
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", x, y, WIDTH, HEIGHT)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line", x, y, WIDTH+1, HEIGHT+1)
    createEnemy(numEnemy)
    local healthText = createEnemyHealthText(numEnemy)
    local font = love.graphics.getFont()
    love.graphics.setColor(0,0,0)
    love.graphics.printf(healthText, font, x, y+30, 150, "center")
end

function createEnemy(numEnemy)
    local enemy = {}
    enemy.basehealth = 100
    enemy.baseatk = 10
    table.insert(enemies, enemy)
    return enemies[numEnemy] or nil
end

function createEnemyHealthText(numEnemy)
    local healthText = enemies[numEnemy].basehealth
    return healthText or nil
end

function drawPlayer()
    local x = 0
    local y = 300
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", x, y, WIDTH, HEIGHT)
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line", x, y, WIDTH+1, HEIGHT+1)
    local healthText = createPlayerHealthText()
    local font = love.graphics.getFont()
    love.graphics.setColor(0,0,0)
    love.graphics.printf(healthText, font, x, y+30, 150, "center")
end

function createPlayerHealthText()
    local healthText = player.basehealth
    return healthText or nil
end

function love.draw()
    drawLevel()
end