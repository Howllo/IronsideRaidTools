---@type IRT
local _, IRT = ...;

IRT.Award = {};
IRTAward = IRT.Award;

-- Ace UI
IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");

function IRTAward:build()
   IRT.Window = IRT.Window or IRT.AceGUI:Create("Window");
end

function IRTAward:Toggle()
    local menu = IRTAward.AwardFrame or IRTAward:build();
    if LootFrame then
        LootFrame:Hide()
    end

    if (menu) then
        menu:SetShown(not menu:IsShown());
    end
end

--- Create Event to handle tooltip
local LootingCorpse = CreateFrame("Frame");
LootingCorpse:RegisterEvent("LOOT_OPENED");
LootingCorpse:RegisterEvent("LOOT_CLOSED");
LootingCorpse:SetScript("OnEvent", function()
    IRTAward:Toggle();
end)
LootingCorpse:SetScript("OnEvent", function()
    IRTAward:Toggle();
end)