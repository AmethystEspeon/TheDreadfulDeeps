local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));

local Enemy = {};

function Enemy:init()
    self.isEnemy = true;
end

function CreateEnemy()
    return Create(Unit, Enemy);
end

return {CreateEnemy, Enemy};