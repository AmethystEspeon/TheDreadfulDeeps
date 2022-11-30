local Board = require("Core.Board");
local Reward = require("Core.Reward");
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
        if x > enemy.boardPosition.x and x < enemy.boardPosition.x + enemy.boardPosition.w and y > enemy.boardPosition.y and y < enemy.boardPosition.y + enemy.boardPosition.h then
            return enemy;
        end
    end
    for i, ally in pairs(allies) do
        if x > ally.x and x < ally.x + ally.w and y > ally.y and y < ally.y + ally.h then
            return ally.unit;
        end
    end
end

function PlayerInput:fightSceneKeyCheck(key, scanCode)
    local mouseoverUnit = PlayerInput:fightGetMouseover(Board.enemies, Board.allyFrames);
    if key == "q" or key == "Q" then
        Board.spellBar:castSpellInSlot(1, mouseoverUnit);
    elseif key == "w" or key == "W" then
        Board.spellBar:castSpellInSlot(2, mouseoverUnit);
    elseif key == "e" or key == "E" then
        Board.spellBar:castSpellInSlot(3, mouseoverUnit);
    elseif key == "r" or key == "R" then
        Board.spellBar:castSpellInSlot(4, mouseoverUnit);
    elseif key == "t" or key == "T" then
        Board.spellBar:castSpellInSlot(5, mouseoverUnit);
    elseif key == "y" or key == "Y" then
        Board.spellBar:castSpellInSlot(6, mouseoverUnit);
    end
end

----------------
--REWARD SCENE--
----------------
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