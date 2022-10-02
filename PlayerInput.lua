local Spells = require("Spells")

local function debugPrint(...)
    print(...)
end

local PlayerInput = {};

function PlayerInput:getMouseover(enemyFrames, allyFrames)
    local x, y = love.mouse.getPosition()
    for i, frame in ipairs(enemyFrames) do
        if x > frame.x and x < frame.x + frame.w and y > frame.y and y < frame.y + frame.h then
            --debugPrint("Mouseover team enemy")
            return "enemy", i
        end
    end
    for i, frame in ipairs(allyFrames) do
        if x > frame.x and x < frame.x + frame.w and y > frame.y and y < frame.y + frame.h then
            --debugPrint("Mouseover team ally")
            return "ally", i
        end
    end
end



function PlayerInput:FIGHT_keyCheck(key, scanCode, player, allUnits, frames)
    local mouseoverTeam, mouseoverIndex = PlayerInput:getMouseover(frames[1], frames[2])
    if key == "q" or key == "Q" then
        Spells:CAST(Spells:getSpellSlotByNumber(1), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "w" or key == "W" then
        Spells:CAST(Spells:getSpellSlotByNumber(2), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "e" or key == "E" then
        Spells:CAST(Spells:getSpellSlotByNumber(3), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    elseif key == "r" or key == "R" then
        Spells:CAST(Spells:getSpellSlotByNumber(4), player, mouseoverTeam, mouseoverIndex, allUnits.enemies, allUnits.allies)
    end
end

return PlayerInput