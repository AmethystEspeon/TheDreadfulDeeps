local Spells = require("Spells")

local function debugPrint(...)
    print(...)
end

local PlayerInput = {};

function PlayerInput:getMouseover()
    local x, y = love.mouse.getPosition()
    for i, frame in ipairs(EnemyFrames) do
        if x > frame.x and x < frame.x + frame.w and y > frame.y and y < frame.y + frame.h then
            return "enemy", i
        end
    end
    for i, frame in ipairs(AllyFrames) do
        if x > frame.x and x < frame.x + frame.w and y > frame.y and y < frame.y + frame.h then
            return "ally", i
        end
    end
end



function PlayerInput:FIGHT_keyCheck(key, scanCode, player, allUnits)
    debugPrint(allUnits.allies[1].health)
    local mouseoverTeam, mouseoverIndex = PlayerInput:getMouseover()
    if key == "q" or key == "Q" then
        Spells:CAST(Spells:GET_SPELLSLOT(1), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "w" or key == "W" then
        Spells:CAST(Spells:GET_SPELLSLOT(2), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "e" or key == "E" then
        Spells:CAST(Spells:GET_SPELLSLOT(3), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "r" or key == "R" then
        Spells:CAST(Spells:GET_SPELLSLOT(4), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    end
end

return PlayerInput