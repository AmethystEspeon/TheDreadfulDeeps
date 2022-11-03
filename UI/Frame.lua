local Create = require("Core.Create");

Frame = {};

function Frame:init()
    self.x = self.x or 0;
    self.y = self.y or 0;
    self.w = self.w or 0;
    self.h = self.h or 0;
    self.offsetX = self.offsetX or 0;
    self.offsetY = self.offsetY or 0;
    self.children = {};
end

function Frame:addChild(frame)
    table.insert(self.children, frame);
end

function Frame:removeChild(frame)
    for i, child in ipairs(self.children) do
        if child == frame then
            table.remove(self.children, i);
            return;
        end
    end
end

function Frame:getParent()
    return self.parent;
end

function Frame:getChildren()
    return self.children;
end

function Frame:applyFrameSettings(settings)
    self.x = settings.x or self.x;
    self.y = settings.y or self.y;
    self.w = settings.w or self.w;
    self.h = settings.h or self.h;
    self.offsetX = settings.offsetX or self.offsetX;
    self.offsetY = settings.offsetY or self.offsetY;
    self.parent = settings.parent;
    if self.parent then
        self.parent:addChild(self);
        self.x = self.parent.x + self.offsetX;
        self.y = self.parent.y + self.offsetY;
    end
end

function Frame:updatePosition()
    if self.parent then
        self.x = self.parent.x + self.offsetX;
        self.y = self.parent.y + self.offsetY;
    end
    if self.updatePositionAddon then
        self:updatePositionAddon();
    end
    for _, child in ipairs(self.children) do
        child:updatePosition();
    end
end

function Frame:translate(x, y)
    if self.parent then
        self.offsetX = self.offsetX + x;
        self.offsetY = self.offsetY + y;
    else
        self.x = self.x + x;
        self.y = self.y + y;
    end
    self:updatePosition();
    for _, child in ipairs(self.children) do
        child:updatePosition();
    end
end

function Frame:drawAll()
    if self.draw and not self.hide then
        self:draw();
    end
    for _, child in ipairs(self.children) do
        child:drawAll();
    end
end

function Frame:drawAllChildren()
    for _, child in ipairs(self.children) do
        child:drawAll();
    end
end

function Frame:resize(w, h)
    self.w = w;
    self.h = h;
    for _, child in ipairs(self.children) do
        child:updatePosition();
    end
end

function Frame:setOffset(offX, offY)
    self.offsetX = offX;
    self.offsetY = offY;
    for _, child in ipairs(self.children) do
        child:updatePosition();
    end
end

function Frame:setParent(parent)
    if self.parent then
        self.parent:removeChild(self);
    end
    self.parent = parent;
    self.parent:addChild(self);
    self:updatePosition();
end

function Frame:deleteFrame()
    if self.parent then
        self.parent:removeChild(self);
    end
    for _, child in ipairs(self.children) do
        child:deleteFrame()
    end
    self.children = {};
end

function Frame:deleteChildren()
    for _, child in ipairs(self.children) do
        child:deleteFrame()
    end
    self.children = {};
end

function CreateFrame(settings)
    local newFrame = Create(Frame);
    newFrame:applyFrameSettings(settings);
    return newFrame;
end

return {CreateFrame, Frame};