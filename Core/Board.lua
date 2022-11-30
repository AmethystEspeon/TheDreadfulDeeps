local Create = require("Core.Create");
local UIList = require("UI.UIList");

local initialized = false;

local AliveBackgroundColor = {1,1,1}
local DeadBackgroundColor = {0.6,0.6,0.6}

local Board = {
    allies = {},
    allyFrames = {},
    enemies = {},
    enemyFrames = {},
    AllyBarWidth = 150,
    AllyBarHeight = 60,
    EnemyBarWidth = 150,
    EnemyBarHeight = 60,
};

local separation = 10;
local XAlliesStart = love.graphics.getWidth()/2-2.5*Board.AllyBarWidth-2*separation;
local YAlliesStart = love.graphics.getHeight()*2/3;

local function createEnemyFrameSingle(enemy)
    local enemyFrameSettings = {}
    local enemyFrame = UIList.UnitFrame(enemyFrameSettings);
end
---------------------
--CREATORS/REMOVERS--
---------------------
function Board:init()
    if initialized then
        return;
    end
    self:createAllyFrames();
    self:createSpellBar();
    initialized = true;
end

function Board:createAllyFrames()
    local tankFrameSettings = {
        x = XAlliesStart,
        y = YAlliesStart,
        w = self.AllyBarWidth,
        h = self.AllyBarHeight,
        name = "Tank UnitFrame",
    }
    local tankFrame = UIList.UnitFrame(tankFrameSettings);
    local healerFrameSettings = {
        parent = tankFrame,
        w = self.AllyBarWidth,
        h = self.AllyBarHeight,
        offsetX = separation+self.AllyBarWidth,
        name = "Healer UnitFrame"
    }
    local healerFrame = UIList.UnitFrame(healerFrameSettings);
    local dps1FrameSettings = {
        parent = healerFrame,
        w = self.AllyBarWidth,
        h = self.AllyBarHeight,
        offsetX = separation+self.AllyBarWidth,
        name = "DPS1 UnitFrame"
    }
    local dps1Frame = UIList.UnitFrame(dps1FrameSettings);
    local dps2FrameSettings = {
        parent = dps1Frame,
        w = self.AllyBarWidth,
        h = self.AllyBarHeight,
        offsetX = separation+self.AllyBarWidth,
        name = "DPS2 UnitFrame"
    }
    local dps2Frame = UIList.UnitFrame(dps2FrameSettings);
    local dps3FrameSettings = {
        parent = dps2Frame,
        w = self.AllyBarWidth,
        h = self.AllyBarHeight,
        offsetX = separation+self.AllyBarWidth,
        name = "DPS3 UnitFrame"
    }
    local dps3Frame = UIList.UnitFrame(dps3FrameSettings);
    self.allyFrames = {tank = tankFrame, healer = healerFrame, dps1 = dps1Frame, dps2 = dps2Frame, dps3 = dps3Frame};
end

function Board:createEnemyFrames()
end

function Board:createSpellBar()
    local spellBarSettings = {
        scale = 0.15,
        separation = 0.1,
        name = "Main Spellbar",
        x = love.graphics:getWidth()*0.05,
        y = love.graphics:getHeight()*0.85,
    }
    self.spellBar = UIList.SpellBar(spellBarSettings);
end

function Board:addAlly(ally)
    if not initialized then
        self:init();
    end
    table.insert(self.allies, ally);
    --print(self.allyFrames.healer.unit.name)
    if ally.isTank and not self.allyFrames.tank:hasUnit() then
        self.allyFrames.tank:setUnit(ally);
        print("Tank Added")
        return;
    elseif ally.isHealer and not self.allyFrames.healer:hasUnit() then
        self.allyFrames.healer:setUnit(ally);
        print("Healer Added")
        return;
    else --if ally.isDPS then
        if not self.allyFrames.dps1:hasUnit() then
            self.allyFrames.dps1:setUnit(ally);
            print("DPS1 Added")
            return;
        elseif not self.allyFrames.dps2:hasUnit() then
            self.allyFrames.dps2:setUnit(ally);
            print("DPS2 Added")
            return;
        elseif not self.allyFrames.dps3:hasUnit() then
            self.allyFrames.dps3:setUnit(ally);
            print("DPS3 Added")
            return;
        end
    end
end

function Board:addEnemy(enemy)
    table.insert(self.enemies, enemy);
end

function Board:removeAlly(ally)
    for i, v in ipairs(self.allies) do
        if v == ally then
            table.remove(self.allies, i);
            break;
        end
    end
    for i, v in ipairs(self.allyFrames) do
        if v.unit == ally then
            v:setUnit(nil);
            break;
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

function Board:switchAlly(ally, newAlly)
    for i, v in ipairs(self.allies) do
        if v == ally then
            self.allies[i] = newAlly;
            break;
        end
    end
    for i, v in ipairs(self.allyFrames) do
        if v.unit == ally then
            v:setUnit(newAlly);
            break;
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

function Board:reapAuras()
    for i, v in ipairs(self.allies) do
        for j , w in ipairs(v.buffs) do
            if w.expired then
                if w.onExpire then
                    w:onExpire();
                end
                table.remove(v.buffs, j);
            end
        end
        for j, w in ipairs(v.debuffs) do
            if w.expired then
                if w.onExpire then
                    w:onExpire();
                end
                table.remove(v.debuffs, j);
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
        for j, w in ipairs(v.debuffs) do
            if w.expired then
                if w.onExpire then
                    w:onExpire();
                end
                table.remove(v.debuffs, j);
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
    for k,v in pairs(self.enemyFrames) do
        v:deleteFrame();
    end
    self.enemies = {};
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
    --[[love.graphics.push();
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
    love.graphics.pop();--]]
    for i, frame in pairs(self.allyFrames) do
        frame:draw();
    end
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

function Board:drawSpells()
    self.spellBar:drawAllCooldowns();
end

return Board;