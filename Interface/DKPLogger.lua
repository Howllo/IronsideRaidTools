---@type IRT
local _, IRT = ...;

IRT.DKPLogger = {};
local DKPLogger = IRT.DKPLogger;
local DKPLog;

function DKPLogger:openMenu()
    local menu = DKPLog or DKPLogger:CreateMenu();
    if (menu) then
        menu:SetShown(not menu:IsShown());
    end
end

local function AddIconToPortrait(DKPLog)
    local iconFrame = CreateFrame("Frame", nil, DKPLog)
    iconFrame:SetSize(57, 57)
    iconFrame:SetPoint("TOPLEFT", DKPLog, "TOPLEFT", -4, 6)

    -- Create the icon texture within the icon frame
    local iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
    iconTexture:SetAllPoints(iconFrame)
    iconTexture:SetTexture("Interface\\AddOns\\IronsideRaidTools\\Assets\\Icons\\IronsideTempIcon.blp")

    DKPLog.portrait = iconTexture
    DKPLog.portrait:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
end


--- Add Buttons to the DKP Log
---
---@param DKPLog any
local function AddButtons(DKPLog)
    -- Raid Log Button
    DKPLog.RaidLogButton = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.RaidLogButton:SetPoint("TOP", DKPLog, "TOP", -50, -35)
    DKPLog.RaidLogButton:SetSize(100, 30)
    DKPLog.RaidLogButton:SetText("Raid Log")
    DKPLog.RaidLogButton:SetFrameLevel(2)
    
    -- Create Roster Button
    DKPLog.RaidLogButton = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.RaidLogButton:SetPoint("TOP", DKPLog, "TOP", 90, -35)
    DKPLog.RaidLogButton:SetSize(100, 30)
    DKPLog.RaidLogButton:SetText("Roster")
    DKPLog.RaidLogButton:SetFrameLevel(2)
end

--- Create the DKP small factor frame.
function DKPLogger:CreateMenu()
    -- Create Main Frame
    DKPLog = CreateFrame("Frame", "DKPLog", UIParent, "PortraitFrameTemplate")
    DKPLog:SetSize(350, 460)
    DKPLog:SetPoint("CENTER", UIParent, "CENTER")
    DKPLog:EnableMouse(true)
    DKPLog:RegisterForDrag("LeftButton")
    DKPLog:SetClampedToScreen(true)
    DKPLog:SetMovable(true)
    DKPLog:SetFrameLevel(0)

    -- Title Bar
    local titleBar = CreateFrame("Frame", "TitleBar", DKPLog);
    titleBar:SetSize(DKPLog:GetWidth(), 30);
    titleBar:SetPoint("TOPLEFT", DKPLog, "TOPLEFT", -10, 3.5);
    titleBar:EnableMouse(true);
    titleBar:SetMovable(true);
    titleBar:RegisterForDrag("LeftButton");
    titleBar:SetScript("OnDragStart", function(self) DKPLog:StartMoving(); end);
    titleBar:SetScript("OnDragStop", function(self) DKPLog:StopMovingOrSizing(); end);
    titleBar:SetFrameLevel(1);

    -- Background
    Background = CreateFrame("Frame", nil, DKPLog, "BackdropTemplate")
    Background:SetSize(DKPLog:GetWidth() + 2, DKPLog:GetHeight() - 74)
    Background:SetPoint("CENTER", DKPLog, "CENTER", -0.7, -38)
    Background:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    Background:SetBackdropColor(0, 0, 0, 1)
    Background:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    Background:SetFrameLevel(1)

    -- Create Title
    titleBar.title = titleBar:CreateFontString(nil, "OVERLAY")
    titleBar.title:SetFontObject("GameFontNormalMed1")
    titleBar.title:SetPoint("CENTER", titleBar, "CENTER", 25, 0)
    titleBar.title:SetText("Ironside DKP System")

    -- Create Button
    DKPLog.button = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.button:SetPoint("CENTER", DKPLog, "CENTER", 0, -200)
    DKPLog.button:SetSize(140, 40)
    DKPLog.button:SetText("Reload")
    DKPLog.button:SetFrameLevel(2)
    DKPLog.button:SetScript("OnClick", function()
        ReloadUI();
    end)

    -- Create Icon
    AddIconToPortrait(DKPLog);

    -- Create Buttons
    AddButtons(DKPLog);

    -- Show
    DKPLog:Show();
    titleBar:Show();
end

function DKPLogger:GetMenu()
    return DKPLog;
end