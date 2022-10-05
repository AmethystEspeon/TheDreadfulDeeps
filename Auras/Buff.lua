local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));

local Buff = {};

function CreateBuff()
    return Create(Aura,Buff);
end

return {CreateBuff, Buff};