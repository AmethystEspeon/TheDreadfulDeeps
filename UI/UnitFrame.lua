local Create = require("Core.Create");
local _, Frame = unpack(require("UI.Frame"));
local HealthFrame = unpack(require("UI.HealthFrame"));
local ManaFrame = unpack(require("UI.ManaFrame"));
local TextFrame = unpack(require("UI.TextFrame"));

local UnitFrame = {};

function UnitFrame:init()
    self.name = "UnitFrame";
    self.hide = true;
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
        w = self.healthFrame.w*0.8,
        offsetX = self.healthFrame.w*0.5,
        offsetY = self.healthFrame.h*0.1,
        text = self.unit.name,
        scale = 0.5,
        align = "center",
        parent = self.healthFrame,
    };
    self.nameFrame = TextFrame(nameSettings);
end

function UnitFrame:updatePositionAddon()
    self.healthFrame:resize(self.w, self.h);
    self.manaFrame:resize(self.healthFrame.w, self.healthFrame.h/4);
    self.manaFrame:setOffset(0, self.healthFrame.h)
end

function UnitFrame:setUnit(unit)
    self.unit = unit;
    self.healthFrame:setUnit(unit);
    self.manaFrame:setUnit(unit);
end

function UnitFrame:draw()
    self.drawAllChildren();
end

function CreateUnitFrame(settings)
    local newFrame = Create(Frame, UnitFrame);
    newFrame:applyUnitSettings(settings);
    return newFrame;
end

return {CreateUnitFrame, UnitFrame};