local Create = require("Core.Create");
local Table = require("Core.TableFuncs")
local _, Frame = unpack(require("UI.Frame"));
local TextFrame = unpack(require("UI.TextFrame"));
local TextureFrame = unpack(require("UI.TextureFrame"));
local BackgroundFrame = unpack(require("UI.BackgroundFrame"));
local ButtonFrame = unpack(require("UI.ButtonFrame"));

local RewardFrame = {};

function RewardFrame:init()
    self.name = "RewardFrame";
    self.hide = true;
end

function RewardFrame:applyRewardSettings(settings)
    self:applyFrameSettings(settings);
    self.name = settings.name or self.name;
    assert(settings.reward, "RewardFrame " .. self.name .. " has no reward!");
    
    --REQUIRED SETTINGS--
    self.reward = settings.reward;
    ---------------------

    --Creating the background
    local backgroundSettings = {
        name = self.name .. " Background",
        w = self.w,
        h = self.h,
        backgroundColor = settings.backgroundColor or {.8125,.7266,.5938},
        parent = self,
     };
    self.backgroundFrame = BackgroundFrame(backgroundSettings);
    local titleSettings = {
        scale = 1.25,
        name = self.name .. " Title",
        w = self.w,
        text = self.reward.name,
        parent = self,
        align = "center",
        offsetY = 12.5,
    };
    self.titleFrame = TextFrame(titleSettings);
    local textureSettings = {
        name = self.name .. " Spell Icon",
        scale = 0.3,
        texture = self.reward.image,
        parent = self.titleFrame,
        offsetY = 25,
        offsetX = self.w/2-self.reward.image:getWidth()*0.3/2,
    };
    self.textureFrame = TextureFrame(textureSettings);
    local descSettings = {
        name = self.name .. " Description",
        w = self.w*0.8, --To give space on each side
        text = self.reward.description,
        parent = self.textureFrame,
        offsetY = self.textureFrame.h+10,
        --For offsetX, we first take it back to the startX of the frame, then change
        offsetX = -self.textureFrame.offsetX+self.w*0.1,
        align = "center",
    };
    self.descFrame = TextFrame(descSettings);
    local buttonSettings = {
        name = self.name .. " Button",
        w = self.w*0.4,
        h = 50,
        parent = self,
        offsetY = self.h*0.8,
        offsetX = self.w/2 - self.w*0.2,
        backgroundColor = settings.buttonColor or {0.8828, 0.7773, 0.6016},
        text = "Choose",
    };
    self.buttonFrame = ButtonFrame(buttonSettings);
    if settings.buttonPressedColor then
        self.buttonFrame:setOnPress(function(_, x, y)
            if self.buttonFrame:mouseHoveringButton(x,y) then
                self.buttonFrame.backgroundFrame:setColor(settings.buttonPressedColor)
            end
        end);
        self.buttonFrame:setOnRelease(function(_, x, y)
            self.buttonFrame.backgroundFrame:setColor(buttonSettings.backgroundColor)
            if self.buttonFrame:mouseHoveringButton(x, y) then
                print("Reward: " .. self.reward.name)
                return self.reward;
            end
        end);
    else
        self.buttonFrame:setOnRelease(function(_, x, y)
            if self.buttonFrame:mouseHoveringButton(x, y) then
                print("Reward: " .. self.reward.name)
                return self.reward;
            end
        end);
    end;
end

function RewardFrame:draw()
    self:drawAllChildren();
end

function RewardFrame:getButton()
    return self.buttonFrame;
end

function RewardFrame:getAllButtons()
    local allButtons = {};
    table.insert(allButtons, self.buttonFrame);
    for i, v in ipairs(self.children) do
        if v.buttonFrame then
            Table:addTable(allButtons,v:getAllButtons());
        end
    end
    return allButtons;
end

function RewardFrame:getAllRewards()
    local allRewards = {};
    table.insert(allRewards, self.reward);
    for i, v in ipairs(self.children) do
        if v.reward then
            Table:addTable(allRewards,v:getAllRewards());
        end
    end
    return allRewards;
end

function CreateRewardFrame(settings)
    local newFrame = Create(Frame, RewardFrame);
    newFrame:applyRewardSettings(settings);
    return newFrame;
end

return {CreateRewardFrame, RewardFrame};