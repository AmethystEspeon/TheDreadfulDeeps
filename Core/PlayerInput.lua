local Board = require("Core.Board");
local Reward = require("Core.Reward")

local PlayerInput = {};

function PlayerInput:fightGetMouseover(enemies, allies)
    local x, y = love.mouse.getPosition();
    for i, enemy in ipairs(enemies) do
        if x > enemy.boardPosition.x and x < enemy.boardPosition.x + enemy.boardPosition.w and y > enemy.boardPosition.y and y < enemy.boardPosition.y + enemy.boardPosition.h then
            return enemy;
        end
    end
    for i, ally in ipairs(allies) do
        if x > ally.boardPosition.x and x < ally.boardPosition.x + ally.boardPosition.w and y > ally.boardPosition.y and y < ally.boardPosition.y + ally.boardPosition.h then
            return ally;
        end
    end
end

function PlayerInput:rewardGetMouseover(rewards)
    local x, y = love.mouse.getPosition();
    for i, reward in ipairs(rewards) do
        if x > reward.buttonPos.x and x < reward.buttonPos.x + reward.buttonPos.w and y > reward.buttonPos.y and y < reward.buttonPos.y + reward.buttonPos.h then
            return reward;
        end
    end
end

function PlayerInput:fightSceneKeyCheck(key, scanCode, playerUnit)
    local mouseoverUnit = PlayerInput:fightGetMouseover(Board.enemies, Board.allies);
    if key == "q" or key == "Q" then
        playerUnit:castSpellInSlot(mouseoverUnit, 1);
    elseif key == "w" or key == "W" then
        playerUnit:castSpellInSlot(mouseoverUnit, 2);
    elseif key == "e" or key == "E" then
        playerUnit:castSpellInSlot(mouseoverUnit, 3);
    elseif key == "r" or key == "R" then
        playerUnit:castSpellInSlot(mouseoverUnit, 4);
    end
end

return PlayerInput;