local Board = require("Core.Board");
local UnitCardPool = require("Units.UnitCardPool")
local UnitList = require("Units.UnitList");

EnemyDirector = {};
local tokens = 0;
local minimumTokens = 0;

-------------------
--LOCAL FUNCTIONS--
-------------------
local function placeUnit(unitTable, insertTable, currentTokens)
    if unitTable.Unit.cost > currentTokens then
        return;
    end
    if unitTable.Unit.cost < minimumTokens then
        return;
    end
    if unitTable.inBattleCount > 0 and not unitTable.Unit.duplicatesAllowed then
        return;
    end
    if unitTable.Unit.duplicatesAllowed and unitTable.inBattleCount >= unitTable.Unit.duplicatesAllowed then
        return;
    end
    table.insert(insertTable, unitTable);
end

local function removeSpaces(str)
    local normalizedString = str:gsub("%s+", "")
    return string.gsub(normalizedString, "&s+", "")
end
----------------

function EnemyDirector:init()
    self:setTokens(65);
end

function EnemyDirector:generateEnemy(currentTokens)
    local possibleEnemies = {};
    for k,v in pairs(UnitCardPool.Enemy) do
        if type(v) == "table" then
            placeUnit(v, possibleEnemies, currentTokens);
            --print("Placed unit: " .. v.Unit.name);
        end
    end
    if #possibleEnemies == 0 then
        return nil;
    end
    local randomIndex = math.random(#possibleEnemies);
    possibleEnemies[randomIndex].inBattleCount = possibleEnemies[randomIndex].inBattleCount + 1;
    --print(possibleEnemies[randomIndex].inBattleCount)
    local enemy = possibleEnemies[randomIndex].Unit;
    return enemy;
end

--------------------
----TOKENS STUFF----
--------------------
function EnemyDirector:addMinimumTokens(newTokens)
    minimumTokens = math.ceil(minimumTokens + newTokens);
end

function EnemyDirector:minusMinimumTokens(newTokens)
    minimumTokens = math.ceil(minimumTokens - newTokens);
end

function EnemyDirector:resetMinimumTokens()
    minimumTokens = 0;
end

function EnemyDirector:getMinimumTokens()
    return minimumTokens;
end

function EnemyDirector:setMinimumTokens(newTokens)
    minimumTokens = newTokens;
end

function EnemyDirector:addTokens(newTokens)
    tokens = math.ceil(tokens + newTokens);
end

function EnemyDirector:minusTokens(newTokens)
    tokens = math.ceil(tokens - newTokens);
end

function EnemyDirector:resetTokens()
    tokens = 0;
end

function EnemyDirector:getTokens()
    return tokens;
end

function EnemyDirector:setTokens(newTokens)
    tokens = newTokens;
end

--------------------
----ENEMY STUFF----
--------------------
function EnemyDirector:fillBoard()
    print("Filling Board with " .. self:getTokens() .. " tokens");
    local currentTokens = tokens;
    local tokensLeft = true;
    while tokensLeft do
        local enemy = self:generateEnemy(currentTokens);
        if enemy == nil then
            tokensLeft = false;
        else
            print("Putting Unit on Board: " .. removeSpaces(enemy.name));
            local unit = UnitList[removeSpaces(enemy.name)]();
            Board:addEnemy(unit);
            currentTokens = currentTokens - unit.cost;
        end
        --print("Current Tokens: " .. currentTokens);
    end
    Board:createEnemyFrames();
end

return EnemyDirector