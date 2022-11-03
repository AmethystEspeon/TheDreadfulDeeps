local Board = require("board");

local BookWidth = love.graphics.getWidth()*0.8;
local BookHeight = love.graphics.getHeight()*0.8;
local BookX = (love.graphics.getWidth()-BookWidth)*0.5;
local BookY = (love.graphics.getHeight()-BookHeight)*0.5;

local SpellsPerPage = 8;
local iconSize = 0.15; --Scale of icons. Same is used for drawing on spellbar.

local currentlyHeldSpell = nil;

local SpellBook = {
    Spells = Board:getPlayer().Spells,
    Page = 1;
};

function SpellBook:getMaxPages()
    return math.ceil(#self.Spells/SpellsPerPage);
end

function SpellBook:nextPage()
    if self.Page >= self:getMaxPages() then
        return;
    end
    self.Page = self.Page + 1;
end

function SpellBook:prevPage()
    if self.Page <= 1 then
        return;
    end
    self.Page = self.Page - 1;
end

local function drawFullRectangle()
    love.graphics.setColor(love.math.colorFromBytes(207,185,151));
    love.graphics.rectangle("fill",BookX,BookY,BookWidth,BookHeight);
end

local function drawSpellInBook(i)
    love.graphics.push();
    local spellNumber = (SpellBook.Page-1)*10+i;
    local spell = SpellBook.Spells[spellNumber];
    if not spell then
        print("ERROR: No spell in spellbook #" .. tostring(spellNumber));
        return;
    end
    --IMAGE--
    local imageWidth = spell.image:getWidth()
    local imageHeight = spell.image:getHeight()
    local gap = (BookHeight/5-imageHeight)/2;
    local partitionWidth = BookWidth/2;
    local partitionHeight = BookHeight/5;
    local side = 0 --left
    if i > 4 then
        side = 1; --right
    end
    local imageY = BookY+(i-1)%4*partitionHeight+gap;
    local imageX = BookX+side*partitionWidth+gap;
    spell.drawCooldown(imageX,imageY,iconSize);
    spell.bookPosition = {x = imageX, y = imageY, w = imageWidth*iconSize, h = imageHeight*iconSize};

    --TEXT--
    local textWidth = BookWidth/2-gap-imageWidth-gap-gap;
    local textX = imageX+imageWidth+gap;
    local textY = imageY+imageHeight/2;
    
    love.graphics.printf(spell.name, textX, textY, textWidth, "left");
    
    love.graphics.pop();
end

function SpellBook:draw()
    love.graphics.push();
    drawFullRectangle();
    for i=1,8 do
        if (self.Page-1)*10+i > #self.Spells then
            break;
        end
        drawSpellInBook(i);
    end
end

function SpellBook:drag(spell)
    if not spell then
        currentlyHeldSpell = nil;
        return;
    end
    currentlyHeldSpell = spell;
    love.graphics.push();
    local imageWidth = spell.image:getWidth()
    local imageHeight = spell.image:getHeight()
    local mouseX, mouseY = love.mouse.getPosition();

    spell.drawCooldown(mouseX-imageWidth/2,mouseY-imageHeight/2,iconSize);
    love.graphics.pop();
end

function SpellBook:drop(spell)
    if not currentlyHeldSpell then
        return;
    end

    --Need to make a function to say where each spell is on the spellbar.
end