local Create = require("Core.Create");
local _, Aura = unpack(require("Auras.Aura"));

local Deuff = {};

function CreateBuff()
    return Create(Aura,Deuff);
end

return {CreateBuff, Deuff};