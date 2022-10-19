local Board = require("Core.Board");
local UnitCardPool = require("Units.UnitCardPool")
local UnitList = require("Units.UnitList");

EnemyDirector = {};

local function placeUnit(unitTable, tokens, insertTable)
    if unitTable.Unit.cost > tokens then
        return;
    end
    if unitTable.inBattle and not unitTable.Unit.duplicateAllowed then
        return;
    end
    table.insert(insertTable, unitTable.Unit);
    unitTable.inBattle = true;
end

function EnemyDirector:generateEnemies(tokens)
    local possibleEnemies = {};
    for k,v in pairs(UnitCardPool.Enemy) do
        if type(v) == table then
            placeUnit(v, tokens, possibleEnemies);
        end
    end
    local enemy = possibleEnemies[math.random(#possibleEnemies)];
    return enemy;
end