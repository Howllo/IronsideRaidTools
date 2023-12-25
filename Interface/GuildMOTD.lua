local _, IRT = ...;
IRT.GuildMOTD = IRT.GuildMOTD or {};
local GuildMOTD = IRT.GuildMOTD;

-- Ace UI
IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");

-- Variables
local isPlayerInCombat = false
local isWaitingForCombat = false

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
    GuildMOTDWindow.MOTDText:SetPoint("CENTER", GuildMOTDWindow.widget, "CENTER", 0, 0);
    GuildMOTDWindow:AddChild(GuildMOTDWindow.MOTDText);
end

function GuildMOTD:Toggle(MOTD)
    local menu = IRT.GuildMOTDWindow or GuildMOTD:build(MOTD);
    if (not menu) then return; end

    if (not menu:IsShown()) then
        menu.MOTDText:SetText(MOTD);
        menu:Show();
        print("Menu is shown!")
    elseif (menu:IsShown()) then
        menu:Hide();
        print("Menu is hide!")
    end
end

local PlayerLoadInfo = CreateFrame("Frame");
PlayerLoadInfo:RegisterEvent("GUILD_MOTD");
PlayerLoadInfo:RegisterEvent("GUILD_ROSTER_UPDATE");
PlayerLoadInfo:RegisterEvent("PLAYER_REGEN_DISABLED");
PlayerLoadInfo:RegisterEvent("PLAYER_REGEN_ENABLED");

--- Remove Events
---@return void
local function RemoveEvents()
    if PlayerLoadInfo:IsEventRegistered("GUILD_MOTD") then
        PlayerLoadInfo:UnregisterEvent("GUILD_MOTD")
    end

    if PlayerLoadInfo:IsEventRegistered("GUILD_ROSTER_UPDATE") then
        PlayerLoadInfo:UnregisterEvent("GUILD_ROSTER_UPDATE")
    end

    if PlayerLoadInfo:IsEventRegistered("PLAYER_REGEN_DISABLED") then
        PlayerLoadInfo:UnregisterEvent("PLAYER_REGEN_DISABLED")
    end

    if PlayerLoadInfo:IsEventRegistered("PLAYER_REGEN_ENABLED") then
        PlayerLoadInfo:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end
end


PlayerLoadInfo:SetScript("OnEvent", function(self, event, arg1, ...)
    if( not IsInGuild() ) then
        RemoveEvents();
        return;
    end

    -- Check if player is in combat
    if (event == "PLAYER_REGEN_DISABLED") then
        isPlayerInCombat = true;
        isWaitingForCombat = true;
    elseif(event == "PLAYER_REGEN_ENABLED") then
        isPlayerInCombat = false;

        if(isWaitingForCombat) then
            isWaitingForCombat = false;
            GuildMOTD:Toggle(GetGuildRosterMOTD());
            RemoveEvents();
        end
    end

    if ((event == "GUILD_MOTD" or event == "GUILD_ROSTER_UPDATE") and not isPlayerInCombat) then
        local MOTD = arg1 or GetGuildRosterMOTD()
        if (MOTD == "" or string.len(MOTD) == 0 or MOTD == nil) then
            return;
        else
            GuildMOTD:Toggle(MOTD);
            RemoveEvents();
            return;
        end

        -- Unregister GUILD_ROSTER_UPDATE
        PlayerLoadInfo:UnregisterEvent("GUILD_ROSTER_UPDATE");
    end
end)