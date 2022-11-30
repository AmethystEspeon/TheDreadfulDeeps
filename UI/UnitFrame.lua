local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));
local HealthFrame = unpack(require("UI.HealthFrame"));
local ManaFrame = unpack(require("UI.ManaFrame"));
local TextFrame = unpack(require("UI.TextFrame"));

local UnitFrame = {};

function UnitFrame:init()
    self.name = "UnitFrame";
    self.hide = false;
end

function UnitFrame:applyUnitSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    self.unit = settings.unit;
    local healthSettings = {
        name = self.name .. "Health",
        w = self.w,
        h = self.h,
        unit = self.unit,
        parent = self,
    };
    self.healthFrame = HealthFrame(healthSettings);
    local manaSettings = {
        name = self.name .. "Mana",
        w = self.healthFrame.w,
        h = self.healthFrame.h/4,
        offsetX = 0,
        offsetY = self.healthFrame.h,
        unit = self.unit,
        parent = self.healthFrame,
    };
    self.manaFrame = ManaFrame(manaSettings);
    local nameSettings = {
        name = self.name .. "Name",
        w = self.manaFrame.w*0.8,
        offsetX = self.manaFrame.w*0.1,
        offsetY = self.manaFrame.h+self.manaFrame.h*0.5,
        scale = 1,
        align = "center",
        parent = self.manaFrame,
    };
    self.nameFrame = TextFrame(nameSettings);
    local healthTextSettings = {
        name = self.name .. "HealthText",
        w = self.healthFrame.w*0.8,
        offsetX = self.healthFrame.w*0.1,
        offsetY = self.healthFrame.h*0.4,
        scale = 0.75,
        align = "center",
        parent = self.healthFrame,
    };
    self.healthTextFrame = TextFrame(healthTextSettings);
end

function UnitFrame:updatePositionAddon()
    self.healthFrame:resize(self.w, self.h);
    self.manaFrame:resize(self.healthFrame.w, self.healthFrame.h/4);
    self.manaFrame:setOffset(0, self.healthFrame.h);
    self.nameFrame:setOffset(self.manaFrame.w*0.1, self.manaFrame.h+self.manaFrame*0.5);
    self.healthTextFrame:setOffset(self.healthFrame.w*0.1, self.healthFrame.h*0.4);
end

function UnitFrame:setUnit(unit)
    if not unit then
        self.unit = nil;
        self.healthFrame:setUnit(nil);
        self.manaFrame:setUnit(nil);
        self.nameFrame:setText("");
        self.healthTextFrame:setText("");
        return;
    end
    self.unit = unit;
    self.healthFrame:setUnit(self.unit);
    self.manaFrame:setUnit(self.unit);
    self.nameFrame:setText(self.unit.name);
    self.healthTextFrame:setText(tostring(self.unit.health) .. "/" .. tostring(self.unit.maxHealth));
end

function UnitFrame:hasUnit()
    if self.unit then
        return true;
    end
    return false;
end

function UnitFrame:draw()
    if not self.unit then
        return;
    end
    self.healthTextFrame:setText(tostring(self.unit.health) .. "/" .. tostring(self.unit.maxHealth));
    self:drawAllChildren();
end

function CreateUnitFrame(settings)
    local newFrame = Create(Frame, UnitFrame);
    newFrame:applyUnitSettings(settings);
    return newFrame;
end

return {CreateUnitFrame, UnitFrame};