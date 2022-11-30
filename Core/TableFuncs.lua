local Table = {};


function Table:addTable(new, old)
    for i,v in pairs(old) do
        table.insert(new, v);
    end
end

function Table:checkIfTable(valueToCheck)
    if type(valueToCheck) == "table" then
        return true;
    end
    return false;
end

return Table;