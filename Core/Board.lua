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
    EnemyBarWidth = 125,
    EnemyBarHeight = 40,
};

local separation = 10;
local XAlliesStart = love.graphics.getWidth()/2-2.5*Board.AllyBarWidth-2*separation;
local YAlliesStart = love.graphics.getHeight()*2/3;
local XEnemiesStart = love.graphics.getWidth()/2-2.5*Board.EnemyBarWidth-2*separation;
local YEnemiesStart = love.graphics.getHeight()-love.graphics.getHeight()*0.9;

---------------------
--CREATORS/REMOVERS--
---------------------
function Board:init()
    if initialized then
        return;
    end
    self:createAllyFrames();
    self:createEnemyBoard();
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
    --[[
        TODO:
        DONE-Create area on board for enemy frames
        -Choose/create a way for it to center itself
        -Start creating frames left to right
    ]]

    local numRows = math.ceil(#self.enemies/5);
    for i = 1, numRows do
        local currentStart = 1+(i-1)*5;
        local currentEnd = math.min(currentStart+4, #self.enemies);
        local numFrames = currentEnd-currentStart+1;
        local startX = self.enemyBoard.w/2-self.EnemyBarWidth/2;
        startX = startX-self.EnemyBarWidth/2*(numFrames-1)-separation/2*(numFrames-1)

        for j = 1, numFrames do
            local unitToPut = self.enemies[currentStart+j-1];
            local frameSettings = {
                name = "Enemy - Row: " .. i .. " - Column: " .. j,
                parent = self.enemyBoard,
                offsetX = startX+(j-1)*(self.EnemyBarWidth+separation),
                offsetY = (i-1)*(self.EnemyBarHeight*2.5),
                w = self.EnemyBarWidth,
                h = self.EnemyBarHeight,
                unit = unitToPut,
            }
            local newFrame = UIList.UnitFrame(frameSettings);
            table.insert(self.enemyFrames, newFrame);
        end
    end

end

function Board:createEnemyBoard()
    local enemyBoardSettings = {
        x = XEnemiesStart,
        y = YEnemiesStart,
        w = 5*self.EnemyBarWidth+4*separation,
        h = 4*self.EnemyBarHeight+3*separation,
    }
    self.enemyBoard = UIList.Frame(enemyBoardSettings);
end

function Board:createSpellBar()
    local spellBarSettings = {
        scale = 0.15,
        separation = 2,
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
            table.remove(self.enemyFrames, i);
            return;
        end
    end
end

function Board:switchAlly(ally, newAlly)
    for i, v in pairs(self.allyFrames) do
        print(v.unit.name .. " vs " .. ally.name)
        if v.unit == ally then
            print("Switching " .. v.unit.name .. " to " .. newAlly.name);
            v:setUnit(newAlly);
            print("Switched to " .. v.unit.name);
            break;
        end
    end
    for i, v in ipairs(self.allies) do
        if v == ally then
            self.allies[i] = newAlly;
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

function Board:getHighestHealthAliveEnemy()
    local aliveEnemies = {};
    for i, v in ipairs(self.enemies) do
        if not v:isDead() then
            table.insert(aliveEnemies, v);
        end
    end
    local highestHealthEnemy = nil;
    local highestHealth = 0;
    for i, v in ipairs(aliveEnemies) do
        if highestHealth < v:getHealth() then
            highestHealthEnemy = v;
            highestHealth = v:getHealth();
        end
    end
    return highestHealthEnemy;
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
        if v.isHealer then
            v:addMana(v:getMaxMana() * percentage*2);
        end
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
    self.enemyBoard.children = {};
    self.enemies = {};
    self.enemyFrames = {};
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
function Board:drawAllies(centerX, centerY, scale)
    for i, frame in pairs(self.allyFrames) do
        frame:draw();
    end
end

function Board:drawEnemies(centerX, centerY, scale)
    for i, frame in pairs(self.enemyFrames) do
        frame:draw();
    end
end

function Board:drawSpells()
    self.spellBar:drawAllCooldowns();
end

return Board;