---@type IRT
local _, IRT = ...;

IRT.Award = {};



function IRT.Award:createMenu()
    local AwardMenu = CreateFrame("Frame", "IRT_AwardMenu", UIParent, "UIDropDownMenuTemplate");
    AwardMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    AwardMenu:SetSize(200, 40);
    AwardMenu:SetFrameStrata("DIALOG");
    AwardMenu:SetToplevel(true);
end