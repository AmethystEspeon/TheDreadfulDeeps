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

function Table:contains(tableToCheck, valueToCheck, checkViaName, useipairs)
    if checkViaName then
        if useipairs then
            for i,v in ipairs(tableToCheck) do
                if v.name == valueToCheck.name then
                    print("Found " .. v.name)
                    return true;
                end
            end
        else
            for i,v in pairs(tableToCheck) do
                if v.name == valueToCheck.name then
                    print("Found " .. v.name)
                    return true;
                end
            end
        end
    else
        if useipairs then
            for i,v in ipairs(tableToCheck) do
                if v == valueToCheck then
                    print("Found " .. v.name)
                    return true;
                end
            end
        else
            for i,v in pairs(tableToCheck) do
                if v == valueToCheck then
                    print("Found " .. v.name)
                    return true;
                end
            end
        end
    end
    return false;
end

return Table;