---@type IRT
local _, IRT = ...;

IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");
AceGUI = IRT.AceGUI;

IRT.DKPLogger = {};
local DKPLogger = IRT.DKPLogger;

function DKPLogger:openMenu()
    local menu = DKPLog or DKPLogger:CreateMenu();
    if (menu) then
        menu:SetShown(not menu:IsShown());
    end
end

--- Create the DKP small factor frame.
function DKPLogger:CreateMenu()
    --[[
        Create the DKP Log Frame
    ]]
    DKPLogger.DKPLog = CreateFrame("Frame", "DKPLog", UIParent, "PortraitFrameTemplate")

    local DKPLog = DKPLogger.DKPLog

    DKPLog:SetSize(350, 575)
    DKPLog:SetPoint("CENTER", UIParent, "CENTER")
    DKPLog:EnableMouse(true)
    DKPLog:RegisterForDrag("LeftButton")
    DKPLog:SetClampedToScreen(true)
    DKPLog:SetMovable(true)
    DKPLog:SetFrameLevel(0)

    --[[
        Create the title bar for dragging.
    ]]
    local titleBar = CreateFrame("Frame", "TitleBar", DKPLog);
    titleBar:SetSize(DKPLog:GetWidth(), 30);
    titleBar:SetPoint("TOPLEFT", DKPLog, "TOPLEFT", -10, 3.5);
    titleBar:EnableMouse(true);
    titleBar:SetMovable(true);
    titleBar:RegisterForDrag("LeftButton");
    titleBar:SetScript("OnDragStart", function(self) DKPLog:StartMoving(); end);
    titleBar:SetScript("OnDragStop", function(self) DKPLog:StopMovingOrSizing(); end);
    titleBar:SetFrameLevel(1);

    --[[
        Create black background
    ]]
    Background = CreateFrame("Frame", nil, DKPLog, "BackdropTemplate")
    Background:SetSize(DKPLog:GetWidth() + 2, DKPLog:GetHeight() - 67)
    Background:SetPoint("CENTER", DKPLog, "CENTER", -0.7, -34)
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

    --[[
        Create title for the frame and set the text.
    ]]
    titleBar.title = titleBar:CreateFontString(nil, "OVERLAY")
    titleBar.title:SetFontObject("GameFontNormalMed1")
    titleBar.title:SetPoint("CENTER", titleBar, "CENTER", 23, 0)
    titleBar.title:SetText("Ironside DKP System")

    --[[
        Temp Button.
        TODO: Delete this button.
    ]]
    DKPLog.button = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.button:SetPoint("CENTER", DKPLog, "CENTER", 0, -260)
    DKPLog.button:SetSize(140, 40)
    DKPLog.button:SetText("Reload")
    DKPLog.button:SetFrameLevel(2)
    DKPLog.button:SetScript("OnClick", function()
        ReloadUI();
    end)

    --[[
        Create the portrait icon for the menu.
    ]]
    local iconFrame = CreateFrame("Frame", nil, DKPLog)
    iconFrame:SetSize(57, 57)
    iconFrame:SetPoint("TOPLEFT", DKPLog, "TOPLEFT", -4, 6)

    --[[
        Create the icon texture within the icon frame.
    ]]
    local iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
    iconTexture:SetAllPoints(iconFrame)
    iconTexture:SetTexture("Interface\\AddOns\\IronsideRaidTools\\Assets\\Icons\\IronsideTempIcon.blp")

    DKPLog.portrait = iconTexture
    DKPLog.portrait:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")

    --[[
        Create Raid Log Button
    ]]
    DKPLog.RaidLog = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.RaidLog:SetPoint("TOP", DKPLog, "TOP", -50, -28)
    DKPLog.RaidLog:SetSize(100, 35)
    DKPLog.RaidLog:SetText("Raid Log")
    DKPLog.RaidLog:SetFrameLevel(2)
    DKPLog.RaidLog:SetScript("OnClick", function()
        IRT.DKPManager:openRaidLog();
    end)

    --[[
        Create Roster Button
    ]]
    DKPLog.Roster = CreateFrame("Button", nil, DKPLog, "GameMenuButtonTemplate")
    DKPLog.Roster:SetPoint("TOP", DKPLog, "TOP", 95, -28)
    DKPLog.Roster:SetSize(100, 35)
    DKPLog.Roster:SetText("Roster")
    DKPLog.Roster:SetFrameLevel(2)
    DKPLog.Roster:SetScript("OnClick", function()
        IRT.DKPManager:openRoster();
    end)

    --[[
        String Frame for the DKP Log
    ]]
    DKPLogger.DKPLogInFront = CreateFrame("Frame", nil, DKPLog, "BackdropTemplate")
    DKPLogInFront = DKPLogger.DKPLogInFront
    DKPLogInFront:SetSize(DKPLog:GetWidth(), DKPLog:GetHeight())
    DKPLogInFront:SetPoint("CENTER", DKPLog, "CENTER", 0, 0)
    DKPLogInFront:SetFrameLevel(2)

    --[[
        Session UI
    ]]


    --[[
        Title to Session 
    ]]
    DKPLogInFront.SessionTitle = DKPLogInFront:CreateFontString(nil, "OVERLAY")
    DKPLogInFront.SessionTitle:SetFontObject("GameFontHighlight")
    DKPLogInFront.SessionTitle:SetPoint("CENTER", DKPLogInFront, "CENTER", 0, 202)
    DKPLogInFront.SessionTitle:SetText("Session")
    DKPLogInFront.SessionTitle:SetTextColor(1, 1, 1, 1)

    --[[
        Start Session Button
    ]]
    DKPLogInFront.StartSession = CreateFrame("Button", nil, DKPLogInFront, "GameMenuButtonTemplate")
    DKPLogInFront.StartSession:SetPoint("CENTER", DKPLogInFront, "CENTER", -80, 165)
    DKPLogInFront.StartSession:SetSize(150, 35)
    DKPLogInFront.StartSession:SetText("Start Raid Session")
    DKPLogInFront.StartSession:SetFrameLevel(2)
    DKPLogInFront.StartSession:Disable()
    DKPLogInFront.StartSession:SetScript("OnClick", function()
        print("StartSession")
    end)

    --[[
        End Session Button
    ]]
    DKPLogInFront.EndSession = CreateFrame("Button", nil, DKPLogInFront, "GameMenuButtonTemplate")
    DKPLogInFront.EndSession:SetPoint("CENTER", DKPLogInFront, "CENTER", 80, 165)
    DKPLogInFront.EndSession:SetSize(150, 35)
    DKPLogInFront.EndSession:SetText("End Raid Session")
    DKPLogInFront.EndSession:SetFrameLevel(2)
    DKPLogInFront.EndSession:Disable()
    DKPLogInFront.EndSession:SetScript("OnClick", function()
        print("EndSession")
    end)

    --[[
        End Session Button
    ]]
    DKPLogInFront.SessionTime = DKPLogInFront:CreateFontString(nil, "OVERLAY")
    DKPLogInFront.SessionTime:SetFontObject("GameFontHighlight")
    DKPLogInFront.SessionTime:SetPoint("CENTER", DKPLogInFront, "CENTER", 0, 125)
    DKPLogInFront.SessionTime:SetText("You are not current in a raid.")
    DKPLogInFront.SessionTime:SetTextColor(1.0, 0.7, 0.0, 1)

    --[[
        Test Image
    ]]
    DKPLogInFront.Divider1 = DKPLogInFront:CreateTexture(nil, "ARTWORK")
    DKPLogInFront.Divider1:SetSize(titleBar:GetWidth() + 85, 15)
    DKPLogInFront.Divider1:SetPoint("CENTER", DKPLogInFront, "CENTER", 43,  100)
    DKPLogInFront.Divider1:SetTexture("Interface\\MailFrame\\MailPopup-Divider")

    --[[
        DKP Control Title
    ]]
    DKPLogInFront.ControlTitle = DKPLogInFront:CreateFontString(nil, "OVERLAY")
    DKPLogInFront.ControlTitle:SetFontObject("GameFontHighlight")
    DKPLogInFront.ControlTitle:SetPoint("CENTER", DKPLogInFront, "CENTER", 0, 85)
    DKPLogInFront.ControlTitle:SetText("DKP Control")
    DKPLogInFront.ControlTitle:SetTextColor(1, 1, 1, 1)

    -- Show
    DKPLog:Show();
    titleBar:Show();
end

function IRT:close()
    if (not DKPLogger.Window) then
        return
    end

    DKPLogger.Window:Hide();
end

local PlayerInRaid = CreateFrame("Frame");
PlayerInRaid:RegisterEvent("GROUP_JOINED")
PlayerInRaid:RegisterEvent("GROUP_LEFT")
PlayerInRaid:RegisterEvent("GROUP_ROSTER_UPDATE")
PlayerInRaid:RegisterEvent("PLAYER_ENTERING_WORLD")
PlayerInRaid:SetScript("OnEvent", function()
    if(DKPLogger.DKPLog and IsInRaid()) then
        DKPLogInFront.SessionTime:SetText("Currently no sessions running.")
        DKPLogInFront.StartSession:Enable()
        DKPLogInFront.EndSession:Enable()
    else
        if(DKPLogger.DKPLog) then
            DKPLogInFront.SessionTime:SetText("You are not current in a raid.")
            DKPLogInFront.StartSession:Disable()
            DKPLogInFront.EndSession:Disable()
        end
    end
end)