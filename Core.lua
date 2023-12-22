---@class Core
local addonName, IRT = ...;
_IRT.Ironside = IRT;

print("Core.lua");

-- Metadata
local GetAddOnMetadata = C_Addons and C_AddOns.GetAddOnMetadata;

-- Variables
IRT.name = addonName;
IRT.version = GetAddOnMetadata(IRT.name, "Version");
IRT.initialized = false;
IRT.clientUIinterface = 0;
IRT.clientVersion = 0;
IRT.EF = nil;
IRT.Ace = LibStub("AceAddon-3.0"):NewAddon(IRT, IRT.name, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");

---Start the addon
---
---@return void
function IRT:init(_, _, addonName)
    if IRT.initialized or addonName ~= IRT.name then return; end

    -- Initialize
    IRT.initialized = true;
    IRT.clientUIinterface = select(4, GetBuildInfo());
    IRT.clientVersion = select(1, GetBuildInfo());

    -- Load Modules
end

IRT.Ace:RegisterChatCommand("irt", "SlashCommand", function(...)
    IRT.Commands:_sendCommand(...);
end);

IRT.Ace:RegisterChatCommand("ironside", "SlashCommand", function(...)
    IRT.Commands:_sendCommand(...);
end);

-- Addon Loaded Event
IRT.EF = CreateFrame("Frame", "IronsideEventFrame");
IRT.EF:RegisterEvent("ADDON_LOADED");
IRT.EF:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        IRT:init(...);
    end
end);