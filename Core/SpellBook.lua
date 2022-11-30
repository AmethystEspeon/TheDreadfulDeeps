local Board = require("Core.Board");
local UIList = require("UI.UIList");
local SceneList = require("Core.SceneList");
local EnemyDirector = require("Directors.EnemyDirector");

local BookWidth = love.graphics.getWidth()*0.8;
local BookHeight = love.graphics.getHeight()*0.8;
local BookX = (love.graphics.getWidth()-BookWidth)*0.5;
local BookY = (love.graphics.getHeight()-BookHeight)*0.1;

local ButtonPressColor = {0.4922,0.3906,0.2773, 1};
local ButtonNonPressColor = {0.8828, 0.7773, 0.6016, 1};

local SpellsPerPage = 8;
local iconSize = 0.15; --Scale of icons. Same is used for drawing on spellbar.
local gap = (BookHeight/5-512*iconSize)/2;

local currentlyDraggedSpell = nil;

local SpellBook = {};

function SpellBook:init()
    self.name = "SpellBook"
    self.Spells = Board:getPlayer().spells;
    self.Page = 1;
    self:createBackground();
    self:createSpellFrames();
    self:createTextFrames();
    self:createDragFrames();
    self:createPageButtons();
    self:createExitButton();
    self:setSpellsInSpellBook()
end

--------------------
--SCENE MANAGEMENT--
--------------------
function SpellBook:setNextScene(nextScene, createEnemies)
    self.nextScene = nextScene;
    self.createEnemies = createEnemies;
end

function SpellBook:gotoNextScene()
    if self.resetEnemies then
        Board:resetEnemyBoard();
        EnemyDirector:fillBoard();
    end
    if self.nextScene then
        SceneList.currentScene = self.nextScene;
    end
end


------------------
--FRAME CREATION--
------------------
function SpellBook:createBackground()
    local backgroundSettings = {
        name = "SpellBookBackground",
        x = BookX,
        y = BookY,
        w = BookWidth,
        h = BookHeight,
        backgroundColor = {.8125,.7266,.5938,1}
    };
    self.background = UIList.BackgroundFrame(backgroundSettings);
end

function SpellBook:createSpellFrames()
    self.spellFrames = {};
    local HalfOfSpells = SpellsPerPage/2;
    for i = 1, SpellsPerPage do
        local offsetX = gap;
        if i > HalfOfSpells then
            offsetX = offsetX + BookWidth/2;
        end
        local offsetY = (i-1)%HalfOfSpells*(BookHeight/HalfOfSpells)+gap;
        local spellSettings = {
            name = "SpellBook SpellFrame " .. i,
            parent = self.background,
            offsetX = offsetX,
            offsetY = offsetY,
            scale = iconSize,
            w = 512*iconSize,
            h = 512*iconSize,
        };
        self.spellFrames[i] = UIList.SpellFrame(spellSettings);
    end
end

function SpellBook:createTextFrames()
    for i = 1, SpellsPerPage do
        local parent = self.spellFrames[i];
        local textSettings = {
            name = "SpellText " .. i,
            parent = parent,
            offsetX = parent.w + gap,
            w = BookWidth/2-gap*2 - parent.w,
        };
        self.spellFrames[i].textFrame = UIList.TextFrame(textSettings);
    end
end

function SpellBook:createDragFrames()
    local dragSettings = {
        name = "DragFrame",
        scale = iconSize,
        offsetX = -(512*iconSize)/2,
        offsetY = -(512*iconSize)/2,
    };
    self.dragFrame = UIList.SpellFrame(dragSettings);
end

local function createNextButton()
    local buttonSettings = {
        parent = SpellBook.background,
        name = "SpellBook: Next Button",
        w = SpellBook.background.w*0.2,
        h = SpellBook.background.w*0.05,
        text = "Next Page",
        offsetX = SpellBook.background.w*0.7,
        offsetY = SpellBook.background.h*0.9,
        align = "right",
        backgroundColor = ButtonNonPressColor,
    }
    SpellBook.nextButton = UIList.ButtonFrame(buttonSettings)
    SpellBook.nextButton:setOnPress(function(_, x, y)
        if SpellBook.nextButton:mouseHoveringFrame(x, y) then
            SpellBook.nextButton.backgroundFrame:setColor(ButtonPressColor);
            SpellBook.nextButton.pressed = true;
        end
    end);
    SpellBook.nextButton:setOnRelease(function(_, x, y)
        SpellBook.nextButton.backgroundFrame:setColor(ButtonNonPressColor);
        if SpellBook.nextButton:mouseHoveringFrame(x, y) then
            if SpellBook.nextButton.pressed then
                SpellBook:nextPage();
            end
            SpellBook.nextButton.pressed = false;
        end
    end);
end

local function createPreviousButton()
    local buttonSettings = {
        parent = SpellBook.background,
        name = "SpellBook: Next Button",
        w = SpellBook.background.w*0.2,
        h = SpellBook.background.w*0.05,
        text = "Previous",
        offsetX = SpellBook.background.w*0.1,
        offsetY = SpellBook.background.h*0.9,
        align = "left",
        backgroundColor = ButtonNonPressColor,
    }
    SpellBook.previousButton = UIList.ButtonFrame(buttonSettings)
    SpellBook.previousButton:setOnPress(function(_, x, y)
        if SpellBook.previousButton:mouseHoveringFrame(x, y) then
            SpellBook.previousButton.backgroundFrame:setColor(ButtonPressColor);
            SpellBook.previousButton.pressed = true;
        end
    end);
    SpellBook.previousButton:setOnRelease(function(_, x, y)
        SpellBook.previousButton.backgroundFrame:setColor(ButtonNonPressColor);
        if SpellBook.previousButton:mouseHoveringFrame(x, y) then
            if SpellBook.previousButton.pressed then
                SpellBook:prevPage();
            end
            SpellBook.previousButton.pressed = false;
        end
    end);
end

function SpellBook:createExitButton()
    local buttonSettings = {
        parent = self.background,
        name = "SpellBook: Exit Button",
        w = SpellBook.background.w*0.05,
        h = SpellBook.background.w*0.05,
        text = "X",
        offsetX = SpellBook.background.w*0.95,
        offsetY = SpellBook.background.h*0.05,
        align = "right",
        backgroundColor = ButtonNonPressColor,
    }
    SpellBook.exitButton = UIList.ButtonFrame(buttonSettings)
    SpellBook.exitButton:setOnPress(function(_, x, y)
        if SpellBook.exitButton:mouseHoveringFrame(x, y) then
            SpellBook.exitButton.backgroundFrame:setColor(ButtonPressColor);
            SpellBook.exitButton.pressed = true;
        end
    end);
    SpellBook.exitButton:setOnRelease(function(_, x, y)
        SpellBook.exitButton.backgroundFrame:setColor(ButtonNonPressColor);
        if SpellBook.exitButton:mouseHoveringFrame(x, y) then
            if SpellBook.exitButton.pressed then
                SpellBook:gotoNextScene();
            end
            SpellBook.exitButton.pressed = false;
        end
    end);
end

function SpellBook:createPageButtons()
    createNextButton()
    createPreviousButton()
end

function SpellBook:setSpellsInSpellBook()
    if not SpellBook.Spells then
        return;
    end
    for i = 1, SpellsPerPage do
        if i+SpellsPerPage*(SpellBook.Page-1) > #SpellBook.Spells then
            break;
        end
        local spellNumber = (SpellBook.Page-1)*SpellsPerPage+i;
        local spell = SpellBook.Spells[spellNumber];
        assert(spell, "SpellBook:drawSpellInBook: No spell in slot " .. spellNumber);

        SpellBook.spellFrames[i]:setSpell(spell);
        SpellBook.spellFrames[i].textFrame:setText(spell.name);
    end
end

------------------
--PAGE FUNCTIONS--
------------------
function SpellBook:getMaxPages()
    return math.ceil(#self.Spells/SpellsPerPage);
end

function SpellBook:nextPage()
    if self.Page >= self:getMaxPages() then
        return;
    end
    self.Page = self.Page + 1;
    self:setSpellsInSpellBook();
end

function SpellBook:prevPage()
    if self.Page <= 1 then
        return;
    end
    self.Page = self.Page - 1;
    self:setSpellsInSpellBook();
end

------------------
--DRAW FUNCTIONS--
------------------
function SpellBook:draw()
    self.background:draw();
    self.nextButton:draw();
    self.previousButton:draw();
    self.exitButton:draw();
    for i = 1, SpellsPerPage do
        if self.spellFrames[i].spell then
            self.spellFrames[i]:drawTexture();
            self.spellFrames[i]:drawAllChildren();
        end
    end
    if self.dragFrame.spell then
        local x, y = love.mouse.getPosition();
        self.dragFrame.x = x;
        self.dragFrame.y = y;
        self.dragFrame:updatePosition();
        local movementX = math.abs(x - self.dragFrame.initialX);
        local movementY = math.abs(y - self.dragFrame.initialY);
        if movementX > 512*iconSize/2 or movementY > 512*iconSize/2 then
            self.dragFrame.moved = true;
        end
        if self.dragFrame.moved then
            self.dragFrame:drawTexture();
        end
    end
end

function SpellBook:setDraggedSpell(spellFrame)
    if not spellFrame then
        self.dragFrame:setSpell(nil);
        self.dragFrame.moved = false;
        return;
    end
    if spellFrame.spell then
        self.dragFrame.initialX = spellFrame.x + spellFrame.w/2;
        self.dragFrame.initialY = spellFrame.y + spellFrame.w/2;
        self.dragFrame:setSpell(spellFrame.spell);
        self.dragFrame.moved = false;
    end
end

function SpellBook:getFrameHovering(x, y)
    for i = 1, SpellsPerPage do
        if self.spellFrames[i].spell then
            if self.spellFrames[i]:mouseHoveringFrame(x, y) then
                return self.spellFrames[i];
            end
        end
    end
    return nil;
end

return SpellBook;