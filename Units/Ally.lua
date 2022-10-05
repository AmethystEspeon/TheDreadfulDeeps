local Create = require("Core.Create");
local _, Unit = unpack(require("Units.Unit"));

local Ally = {};

function Ally:init()
    self.isAlly = true;
    self.manaPerSecond = 1;
    self.manaTickRate = 0.1;
    self.timeSinceLastMana = 0;
end

function CreateAlly()
    return Create(Unit, Ally);
end

return {CreateAlly, Ally};