local Board = require("Core.Board");
local RewardDirector = require("Directors.RewardDirector");
local SpellBook = require("Core.SpellBook");
local TableFuncs = require("Core.TableFuncs");
local PlayerInput = {
    draggedFrom = nil,
};

---------------
--FIGHT SCENE--
---------------
function PlayerInput:fightGetMouseover(enemies, allies)
    local x, y = love.mouse.getPosition();
    for i, enemy in ipairs(enemies) do
        if x > enemy.x and x < enemy.x + enemy.w and y > enemy.y and y < enemy.y + enemy.h then
            return enemy.unit;
        end
    end
    for i, ally in pairs(allies) do
        if x > ally.x and x < ally.x + ally.w and y > ally.y and y < ally.y + ally.h then
            return ally.unit;
        end
    end
end

function PlayerInput:fightSceneKeyCheck(key, scanCode)
    local mouseoverUnit = PlayerInput:fightGetMouseover(Board.enemyFrames, Board.allyFrames);
    if mouseoverUnit then print(mouseoverUnit.name)end
    if key == "q" or key == "Q" then
        Board.spellBar:castSpellInSlot(1, mouseoverUnit);
    elseif key == "w" or key == "W" then
        Board.spellBar:castSpellInSlot(2, mouseoverUnit);
    elseif key == "e" or key == "E" then
        Board.spellBar:castSpellInSlot(3, mouseoverUnit);
    elseif key == "r" or key == "R" then
        Board.spellBar:castSpellInSlot(4, mouseoverUnit);
    elseif key == "a" or key == "A" then
        Board.spellBar:castSpellInSlot(5, mouseoverUnit);
    elseif key == "s" or key == "S" then
        Board.spellBar:castSpellInSlot(6, mouseoverUnit);
    elseif key == "d" or key == "D" then
        Board.spellBar:castSpellInSlot(7, mouseoverUnit);
    elseif key == "f" or key == "F" then
        Board.spellBar:castSpellInSlot(8, mouseoverUnit);
    elseif key == "z" or key == "Z" then
        Board.spellBar:castSpellInSlot(9, mouseoverUnit);
    end
end

----------------
--REWARD SCENE--
----------------
function PlayerInput:rewardMousePressed(x,y)
    local allButtons = RewardDirector:getRewardButtons();
    if not allButtons then
        return;
    end
    for i,v in ipairs(allButtons) do
        v:onPress(x,y);
    end
end

function PlayerInput:rewardMouseReleased(x,y)
    local reward;
    local allButtons = RewardDirector:getRewardButtons();
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

-------------------
--SPELLBOOK SCENE--
-------------------
local function spellBookSpellMousePressed(x, y, spellBar)
    local spellBookHover = SpellBook:getFrameHovering(x,y);
    local spellBarHover = spellBar:getFrameHovering(x,y);
    if spellBookHover then
        print(spellBookHover.name)
        PlayerInput.draggedFrom = SpellBook
        SpellBook:setDraggedSpell(spellBookHover);
        return;
    end
    if spellBarHover then
        print(spellBarHover.name)
        PlayerInput.draggedFrom = spellBarHover
        SpellBook:setDraggedSpell(spellBarHover);
        return;
    end
    SpellBook:setDraggedSpell(nil);
    PlayerInput.draggedFrom = nil;
end

local function spellBookSpellMouseReleased(x, y, spellBar)
    if not SpellBook.dragFrame.spell or not PlayerInput.draggedFrom then
        SpellBook:setDraggedSpell(nil);
        return;
    end
    local spellBookHover = SpellBook:getFrameHovering(x,y);
    local spellBarHover = spellBar:getFrameHovering(x,y);
    if PlayerInput.draggedFrom == SpellBook then
        if not spellBookHover and not spellBarHover then
            print("None")
            SpellBook:setDraggedSpell(nil);
            PlayerInput.draggedFrom = nil;
            return;
        end
        if spellBookHover then
            SpellBook:setDraggedSpell(nil);
            PlayerInput.draggedFrom = nil;
            return;
        end
        if spellBarHover then
            spellBarHover:setSpell(SpellBook.dragFrame.spell);
            SpellBook:setDraggedSpell(nil);
            PlayerInput.draggedFrom = nil;
            return;
        end
    end
    if PlayerInput.draggedFrom:getParent() == spellBar then
        if not spellBookHover and not spellBarHover then
            PlayerInput.draggedFrom:setSpell(nil);
            SpellBook:setDraggedSpell(nil);
            return;
        end
        if spellBookHover then
            SpellBook:setDraggedSpell(nil);
            return;
        end
        if spellBarHover then
            local tempSpell = spellBarHover.spell;
            spellBarHover:setSpell(PlayerInput.draggedFrom.spell);
            PlayerInput.draggedFrom:setSpell(tempSpell);
            SpellBook:setDraggedSpell(nil);
            return;
        end
    end
end

local function spellBookPageMousePressed(x, y)
    for i, v in pairs(SpellBook.background.children) do
        local isTable = TableFuncs:checkIfTable(v);
        if isTable then
            if v.onPress then
                v:onPress(x,y);
            end
        end
    end
end

local function spellBookPageMouseReleased(x, y)
    for i, v in pairs(SpellBook.background.children) do
        local isTable = TableFuncs:checkIfTable(v);
        if isTable then
            if v.onRelease then
                v:onRelease(x,y);
            end
        end
    end
end

function PlayerInput:spellBookMousePressed(x, y, spellBar)
    spellBookSpellMousePressed(x, y, spellBar);
    spellBookPageMousePressed(x, y);
end

function PlayerInput:spellBookMouseReleased(x, y, spellBar)
    spellBookSpellMouseReleased(x, y, spellBar);
    spellBookPageMouseReleased(x, y);
end





return PlayerInput;