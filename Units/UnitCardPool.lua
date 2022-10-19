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
        print(unit.name);
        local function putUnitInTable()
            if unit.isHealer then
                return;
            end
            if unit.isAlly then
                self.Ally[unit.name] = {Cards = 1, Unit = unit, inBattle = false};
                self.Ally.Cards = self.Ally.Cards + 1;
            end
            if unit.isEnemy then
                self.Enemy[unit.name] = {Cards = 1, Unit = unit, inBattle = false};
                self.Enemy.Cards = self.Enemy.Cards + 1;
            end
        end
        putUnitInTable();
    end
end

return UnitCardPool;