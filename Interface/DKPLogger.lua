---@type IRT
local _, IRT = ...;

IRT.DKPLogger = {};
local DKPLogger = IRT.DKPLogger;
local DKPLog;

function DKPLogger:Toggle()
    local menu = DKPLog or DKPLogger:CreateMenu();
    menu:SetShown(not menu:IsShown());
end

function DKPLogger:CreateMenu()
    -- Create Main Frame
    DKPLog = CreateFrame("Frame", "DKPLog", UIParent, "EtherealFrameTemplate")
    DKPLog:SetSize(350, 460)
    DKPLog:SetPoint("CENTER", UIParent, "CENTER")
    DKPLog:SetMovable(true)
    DKPLog:EnableMouse(true)
    DKPLog:RegisterForDrag("LeftButton")
    DKPLog:SetScript("OnDragStart", DKPLog.StartMoving)
    DKPLog:SetScript("OnDragStop", DKPLog.StopMovingOrSizing)
    DKPLog:SetClampedToScreen(true)

    -- Create Title
    DKPLog.title = DKPLog:CreateFontString(nil, "OVERLAY")
    DKPLog.title:SetFontObject("GameFontHighlightLarge")
    DKPLog.title:SetPoint("LEFT", DKPLog.TitleBg, "LEFT", 120, 0)
    DKPLog.title:SetText("Ironside Raid Tools (v%s)", IRT.version)

    -- Create Button
    DKPLog.button = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.button:SetPoint("CENTER", DKPLog, "CENTER", 0, -200)
    DKPLog.button:SetSize(140, 40)
    DKPLog.button:SetText("Raid Tools")
end

function DKPLogger:GetMenu()
    return DKPLog;
end