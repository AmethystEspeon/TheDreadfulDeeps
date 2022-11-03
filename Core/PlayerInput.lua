local Board = require("Core.Board");
local Reward = require("Core.Reward")
local Table = require("Core.TableFuncs");

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

function PlayerInput:rewardMousePressed(x,y)
    local allButtons = Reward:getRewardButtons();
    if not allButtons then
        return;
    end
    for i,v in ipairs(allButtons) do
        v:onPress(x,y);
    end
end

function PlayerInput:rewardMouseReleased(x,y)
    local reward;
    local allButtons = Reward:getRewardButtons();
    if not allButtons then
        return;
    end
    for i,v in ipairs(allButtons) do
        reward = v:onRelease(x,y);
        if reward then
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
    elseif key == "t" or key == "T" then
        playerUnit:castSpellInSlot(mouseoverUnit, 5);
    elseif key == "y" or key == "Y" then
        playerUnit:castSpellInSlot(mouseoverUnit, 6);
    end
end

return PlayerInput;