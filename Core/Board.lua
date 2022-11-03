local Create = require("Core.Create");

local AliveBackgroundColor = {1,1,1}
local DeadBackgroundColor = {0.6,0.6,0.6}

local Board = {
    allies = {},
    enemies = {},
    AllyBarWidth = 150,
    AllyBarHeight = 60,
    EnemyBarWidth = 150,
    EnemyBarHeight = 60,
};

---------------------
--CREATORS/REMOVERS--
---------------------
function Board:addAlly(ally)
    table.insert(self.allies, ally);
end

function Board:addEnemy(enemy)
    table.insert(self.enemies, enemy);
end

function Board:removeAlly(ally)
    for i, v in ipairs(self.allies) do
        if v == ally then
            table.remove(self.allies, i);
            return;
        end
    end
end

function Board:removeEnemy(enemy)
    for i, v in ipairs(self.enemies) do
        if v == enemy then
            table.remove(self.enemies, i);
            return;
        end
    end
end

-----------
--GETTERS--
-----------
function Board:getLowestHealthAliveAlly()
    local aliveAllies = {};
    for i, v in ipairs(self.allies) do
        if not v:isDead() then
            table.insert(aliveAllies, v);
        end
    end
    local lowestHealthAlly = nil;
    local lowestHealth = math.huge;
    for i, v in ipairs(aliveAllies) do
        if lowestHealth > v:getHealth() then
            lowestHealthAlly = v;
            lowestHealth = v:getHealth();
        end
    end
    return lowestHealthAlly;
end

function Board:getLowestHealthAliveEnemy()
    local aliveEnemies = {};
    for i, v in ipairs(self.enemies) do
        if not v:isDead() then
            table.insert(aliveEnemies, v);
        end
    end
    local lowestHealthEnemy = nil;
    local lowestHealth = math.huge;
    for i, v in ipairs(aliveEnemies) do
        if lowestHealth > v:getHealth() then
            lowestHealthEnemy = v;
            lowestHealth = v:getHealth();
        end
    end
    return lowestHealthEnemy;
end

function Board:getLowestHealthShieldAliveAlly()
    local aliveAllies = {};
    for i, v in ipairs(self.allies) do
        if not v:isDead() then
            table.insert(aliveAllies, v);
        end
    end
    local lowestHealthShieldAlly = nil;
    local lowestHealthShield = math.huge;
    for i, v in ipairs(aliveAllies) do
        if lowestHealthShield > v:getShields() + v:getHealth() then
            lowestHealthShieldAlly = v;
            lowestHealthShield = v:getShields() + v:getHealth();
        end
    end
    return lowestHealthShieldAlly
end

function Board:getTankPreferredTarget()
    for i, v in ipairs(self.allies) do
        if v.isTank and not v:isDead() then
            return v;
        end
    end
    return Board:getRandomAliveAlly();
end

function Board:getRandomAliveAlly()
    local aliveAllies = {};
    for i, v in ipairs(self.allies) do
        if not v:isDead() then
            table.insert(aliveAllies, v);
        end
    end

    return aliveAllies[math.random(#aliveAllies)];
end

function Board:getRandomAliveEnemy()
    local aliveEnemies = {};
    for i, v in ipairs(self.enemies) do
        if not v:isDead() then
            table.insert(aliveEnemies, v);
        end
    end

    return aliveEnemies[math.random(#aliveEnemies)];
end

function Board:getPlayer()
    for i, v in ipairs(self.allies) do
        if v.isHealer then
            return v;
        end
    end
end

function Board:getNumberAliveEnemies()
    local aliveCount = 0;
    for i, v in ipairs(self.enemies) do
         if not v:isDead() then
            aliveCount = aliveCount + 1;
         end
    end
    return aliveCount;
end

function Board:getNumberAliveAllies()
    local aliveCount = 0;
    for i, v in ipairs(self.allies) do
         if not v:isDead() then
            aliveCount = aliveCount + 1;
         end
    end
    return aliveCount;
end
----------------------
--BOARDWIDE FUNTIONS--
----------------------
function Board:useAttacks(dt)
    for i, v in ipairs(self.allies) do
        if not v:isDead() and v.attack then
            v:attack(dt);
        end
    end
    for i, v in ipairs(self.enemies) do
        if not v:isDead() and v.attack then
            v:attack(dt);
        end
    end
end

function Board:useAbilities(dt)
    for i, v in ipairs(self.allies) do
        if v.useAbility then
            v:useAbility(dt);
        end
    end
    for i, v in ipairs(self.enemies) do
        if v.useAbility then
            v:useAbility(dt);
        end
    end
end

function Board:useManaGain(dt)
    for i, v in ipairs(self.allies) do
        if v.manaPerSecond then
            v:gainManaPerSecond(dt);
        end
    end
    for i, v in ipairs(self.enemies) do
        if v.manaPerSecond then
            v:gainManaPerSecond(dt);
        end
    end
end

function Board:tickAllCooldowns(dt)
    for i,v in ipairs(self.allies) do
        for j, w in ipairs(v.spells) do
            w:tickPressed(dt);
            w:tickCooldown(dt);
        end
    end
    for i,v in ipairs(self.enemies) do
        for j, w in ipairs(v.spells) do
            w:tickPressed(dt);
            w:tickCooldown(dt);
        end
    end
end

local function useAurasTickSingle(unit, dt)
    for i, v in ipairs(unit.buffs) do
        if v.tick then
            v:tick(dt);
        end
    end
    for i,v in ipairs(unit.debuffs) do
        if v.tick then
            v:tick(dt);
        end
    end
end

function Board:useAurasTick(dt)
    for i,v in ipairs(self.allies) do
        useAurasTickSingle(v, dt);
    end
    for i,v in ipairs(self.enemies) do
        useAurasTickSingle(v, dt);
    end
end

function Board:reapBuffs()
    for i, v in ipairs(self.allies) do
        for j , w in ipairs(v.buffs) do
            if w.expired then
                if w.onExpire then
                    w:onExpire();
                end
                table.remove(v.buffs, j);
            end
        end
    end
    for i, v in ipairs(self.enemies) do
        for j , w in ipairs(v.buffs) do
            if w.expired then
                if w.onExpire then
                    w:onExpire();
                end
                table.remove(v.buffs, j);
            end
        end
    end
end

function Board:healAfterFight(percentage)
    for i,v in ipairs(self.allies) do
        if v:isDead() then
            v.dead = false;
        end
        v:addHealth(v:getMaxHealth() * percentage);
    end
end

 --TODO: Is this necessary? would self = {} work?
function Board:resetEnemyBoard()
    for k,v in pairs(self.enemies) do
        self.enemies[k] = nil;
    end
end

function Board:resetAllyBoard()
    for k,v in pairs(self.allies) do
        self.allies[k] = nil;
    end
end

function Board:reset()
    self:resetEnemyBoard();
    self:resetAllyBoard();
end
-----------------
--BAR FUNCTIONS--
-----------------
local function drawBar(unit, centerX, centerY, barWidth, barHeight)
    --------------
    --Background--
    --------------
    if unit:isDead() then
        love.graphics.setColor(DeadBackgroundColor[1], DeadBackgroundColor[2], DeadBackgroundColor[3]);
    else
        love.graphics.setColor(AliveBackgroundColor[1], AliveBackgroundColor[2], AliveBackgroundColor[3]);
    end
    --health--
    love.graphics.rectangle("fill", centerX-1, centerY-1, barWidth+2, barHeight+2);
    --Mana--
    if unit.mana then
        love.graphics.rectangle("fill", centerX-1, centerY+barHeight-1, barWidth+2, barHeight/4+2);
    end
    --------------
    --Foreground--
    --------------
    --health--
    if unit.isAlly then
        local green = 1 * (unit:getHealth()/unit:getMaxHealth());
        local red = 1 - green;
        love.graphics.setColor(red, green, 0);
    else
        love.graphics.setColor(1,0,0);
    end
    love.graphics.rectangle("fill", centerX, centerY, barWidth * (unit:getHealth()/unit:getMaxHealth()), barHeight);
    --Mana--
    if unit.mana then
        love.graphics.setColor(0,0,1);
        love.graphics.rectangle("fill", centerX, centerY+barHeight, barWidth * (unit.mana/unit.maxMana), barHeight/4);
    end
end

function Board:drawAllies(centerX, centerY, scale)
    love.graphics.push();
    love.graphics.scale(scale);
    local scaledX = centerX/scale;
    local scaledY = centerY/scale;
    local count = 1;
    for i, v in ipairs(self.allies) do
        if v.isTank then
            drawBar(v, scaledX-(2*self.AllyBarWidth), scaledY, self.AllyBarWidth, self.AllyBarHeight);
            v.boardPosition = {x = centerX-(2*self.AllyBarWidth*scale), y = centerY, w = self.AllyBarWidth*scale, h = self.AllyBarHeight*scale};
        end
        if v.isHealer then
            drawBar(v, scaledX-(1*self.AllyBarWidth), scaledY, self.AllyBarWidth, self.AllyBarHeight);
            v.boardPosition = {x = centerX-(1*self.AllyBarWidth*scale), y = centerY, w = self.AllyBarWidth*scale, h = self.AllyBarHeight*scale};
        end
        if v.isDPS then
            drawBar(v, scaledX+((count-1)*self.AllyBarWidth), scaledY, self.AllyBarWidth, self.AllyBarHeight);
            v.boardPosition = {x = centerX+((count-1)*self.AllyBarWidth*scale), y = centerY, w = self.AllyBarWidth*scale, h = self.AllyBarHeight*scale};
            count = count + 1;
        end
    end
    love.graphics.pop();
end

function Board:drawEnemies(centerX, centerY, scale)
    love.graphics.push();
    love.graphics.scale(scale);
    local scaledX = centerX/scale;
    local scaledY = centerY/scale;
    for i, v in ipairs(self.enemies) do
        drawBar(v, scaledX, scaledY+((i-1)*(self.EnemyBarHeight+self.EnemyBarHeight/4)), self.EnemyBarWidth, self.EnemyBarHeight);
        v.boardPosition = {x = centerX, y = centerY+((i-1)*self.EnemyBarHeight*scale), w = self.EnemyBarWidth*scale, h = self.EnemyBarHeight*scale};
    end
    love.graphics.pop();
end

function Board:drawSpells(firstX, centerY, scale)
    local player = self:getPlayer()
    for i, k in ipairs(player.activeSpellList) do
        assert(k.activeSlot)
        k:drawCooldown(firstX+((k.activeSlot-1)*k.image:getWidth()*scale), centerY, scale);
    end
end

return Board;