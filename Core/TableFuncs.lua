local Table = {};


function Table:addTable(new, old)
    for i,v in pairs(old) do
        table.insert(new, v);
    end
end

return Table;