local UnitList = require("Units.UnitList");
local UnitIdentifierList = require("Units.UnitIdentifierList");
local Board = require("Core.Board");
local UnitCardPool = {};

function UnitCardPool:init()
    self.Ally = {
        Cards = 0;
    };

    self.Enemy = {
        Cards = 0;
    };
    for k,v in pairs(UnitList) do
        local unit = v();
        local function putUnitInTable()
            if unit.isHealer then
                return;
            end
            if unit.isAlly then
                self.Ally[unit.name] = {Cards = 1, Unit = unit, inBattleCount = 0};
                self.Ally.Cards = self.Ally.Cards + 1;
            end
            if unit.isEnemy then
                self.Enemy[unit.name] = {Cards = 1, Unit = unit, inBattleCount = 0};
                self.Enemy.Cards = self.Enemy.Cards + 1;
            end
        end
        putUnitInTable();
    end
end

function UnitCardPool:resetEnemyPool()
    for k,v in pairs(self.Enemy) do
        if type(v) == "table" then
            v.inBattleCount = 0;
        end
    end
end

return UnitCardPool;