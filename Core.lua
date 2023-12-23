---@class Core
local addonName, IRT = ...;

-- Metadata
local GetAddOnMetadata = C_Addons and C_Addon.GetAddOnMetadata or GetAddOnMetadata;

-- Variables
IRT.name = addonName
IRT.version = GetAddOnMetadata(IRT.name, "Version");
IRT.initialized = false;
IRT.clientUIinterface = 0;
IRT.clientVersion = 0;
IRT.EF = nil;

-- Ace
IRT.Ace = LibStub("AceAddon-3.0"):NewAddon(IRT, IRT.name, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

---Start the addon
function IRT:init()
    if self.initialized then return; end

    -- Initialize
    self.initialized = true;
    self.clientUIinterface = select(4, GetBuildInfo());
    self.clientVersion = select(1, GetBuildInfo());

    -- Welcome Message
    if(self.Settings:get("startMessage")) then
        print(string.format("|cFF%sIronside Raid Tools v%s|r by Eureka@CrusaderStrike. Type |cFF%s/irt|r or |cFF%s/ironside|r to start!",
        self.Data.Constants.mainThemeColor,
        self.version,
        self.Data.Constants.mainThemeColor,
        self.Data.Constants.mainThemeColor
    ))
    end
    
    -- Load Modules
end

IRT.Ace:RegisterChatCommand("irt", function(...)
    IRT.Command:_sendCommand(...);
end);

IRT.Ace:RegisterChatCommand("ironside", function(...)
    IRT.Command:_sendCommand(...);
end);

-- Addon Loaded Event
IRT.EF = CreateFrame("FRAME", "IronsideEventFrame");
IRT.EF:RegisterEvent("ADDON_LOADED");
IRT.EF:SetScript("OnEvent", function(_, event, addon)
    if event == "ADDON_LOADED" and addon == addonName then
        IRT:init();
    end
end);