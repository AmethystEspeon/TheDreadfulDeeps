local function MixinSingle(target, source)
    for k, v in pairs(source) do
        target[k] = v;
    end
end

function CreateObjectAndInit(...)
    local obj = {};
    for i = 1, select("#", ...) do
        MixinSingle(obj, select(i, ...));
    end
    for i=1, select("#", ...) do
        if select(i, ...).init then
            select(i, ...).init(obj);
        end
    end
    return obj;
end

return CreateObjectAndInit