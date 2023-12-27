local _, IRT = ...;
IRT.GuildMOTD = IRT.GuildMOTD or {};
local GuildMOTD = IRT.GuildMOTD;

-- Ace UI
IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");

-- Variables
local GuildMOTDFrame = nil;
local isCombat = false;

function GuildMOTD:build(MOTD)
    if(not IRT.Settings:get("guildmotd")) then return end;
    local guildName, _, _, _ = GetGuildInfo("player");

    IRT.GuildMOTDWindow = IRT.GuildMOTDWindow or IRT.AceGUI:Create("Window");
    IRT.GuildMOTDWindow:SetTitle(string.format("%s MOTD", guildName));
    IRT.GuildMOTDWindow:SetLayout("Flow");
    IRT.GuildMOTDWindow:SetWidth(400);
    IRT.GuildMOTDWindow:SetHeight(100);
    IRT.GuildMOTDWindow:EnableResize(false);
    IRT.GuildMOTDWindow:SetCallback("OnClose", function(widget) IRT.GuildMOTDWindow:Hide() end);
    GuildMOTDWindow = IRT.GuildMOTDWindow;

    -- MOTD Text
    GuildMOTDWindow.MOTDText = IRT.MOTDText or IRT.AceGUI:Create("Label");
    GuildMOTDWindow.MOTDText:SetFullWidth(true);
    GuildMOTDWindow.MOTDText:SetFontObject(GameFontHighlightLarge);
    GuildMOTDWindow.MOTDText:SetColor(1, 1, 1);
    GuildMOTDWindow.MOTDText:SetText(MOTD);
    GuildMOTDWindow.MOTDText:SetJustifyH("CENTER");
    GuildMOTDWindow.MOTDText:SetJustifyV("CENTER");
    GuildMOTDWindow.MOTDText:SetPoint("CENTER", GuildMOTDWindow.widget, "CENTER", 0, -40);
    GuildMOTDWindow:AddChild(GuildMOTDWindow.MOTDText);
end

function GuildMOTD:Toggle(MOTD)
    local menu = IRT.GuildMOTDWindow or GuildMOTD:build(MOTD);
    if (not menu) then return; end

    menu.MOTDText:SetText(MOTD);
    menu:Show();
end

local function OnUpdateHandler(self, elapsed)
    if( not IsInGuild() and GuildMOTDFrame ) then
        GuildMOTDFrame:SetScript("OnUpdate", nil);
        return;
    end

    if(isCombat) then return end;

    local MOTD = GetGuildRosterMOTD();
    if (MOTD ~= "" and GuildMOTDFrame) then
        GuildMOTD:Toggle(MOTD);
        GuildMOTDFrame:SetScript("OnUpdate", nil);
    end
end
GuildMOTDFrame = CreateFrame("Frame");
GuildMOTDFrame:SetScript("OnUpdate", OnUpdateHandler);

-- Check if player is in combat on load.
local PLayerInfoFrame = CreateFrame("Frame");
PLayerInfoFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
PLayerInfoFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
PLayerInfoFrame:SetScript("OnEvent", function(self, event, ...)
    if (event == "PLAYER_REGEN_ENABLED") then
        PLayerInfoFrame:UnregisterEvent("PLAYER_REGEN_ENABLED");
        isCombat = false;
    elseif (event == "PLAYER_REGEN_DISABLED") then
        PLayerInfoFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
        isCombat = true;
    end
end)