---@class Core
local appName, IRT = ...;
_IRT.Ironside = IRT;

local GetAddOnMetadata = C_Addons and C_AddOns.GetAddOnMetadata;

IRT.name = appName;
IRT.version = GetAddOnMetadata(IRT.name, "Version");
IRT.Ace = LibStub("AceAddon-3.0"):NewAddon(IRT, appName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");

-- Start of Slash Commands
SLASH_IRT1 = "/irt"
SlashCmdList["IRT"] = function(msg)
    if msg == "help" then
        print("Ironside Raid Tools v1.0.0 by Eureka@Crusader-Strike.")
        print("/irt help - Displays this message.")
        print("/irt version - Displays the current version of IRT.")
        print("/irt debug - Toggles debug mode. (Does nothing at the moment.)")
        print("/irt - Opens the menu.")
    elseif msg == "version" then
        print("Ironside Raid Tools: v1.0.0")
    elseif msg == "debug" then
        if IRT_DEBUG == true then
            IRT_DEBUG = false
            print("Debug mode disabled.")
        else
            IRT_DEBUG = true
            print("Debug mode enabled.")
        end
    else
        if UIConfig:IsShown() then
            UIConfig:Hide()
        else
            UIConfig:Show()
        end
    end
end