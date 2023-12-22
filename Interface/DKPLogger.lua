---@type IRT
local _, IRT = ...;

-- Create Main Frame
local UIConfig = CreateFrame("Frame", "Ironside_Raid_Tool", UIParent, "EtherealFrameTemplate")
UIConfig:SetSize(350, 460)
UIConfig:SetPoint("CENTER", UIParent, "CENTER")
UIConfig:SetMovable(true)
UIConfig:EnableMouse(true)
UIConfig:RegisterForDrag("LeftButton")
UIConfig:SetScript("OnDragStart", UIConfig.StartMoving)
UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing)
UIConfig:SetClampedToScreen(true)

-- Create Title
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY")
UIConfig.title:SetFontObject("GameFontHighlightLarge")
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 120, 0)
UIConfig.title:SetText("Ironside Raid Tool v" .. C_AddOns.GetAddOnMetadata("IronsideRaidTools", "Version"))

-- Create Button
UIConfig.button = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate")
UIConfig.button:SetPoint("CENTER", UIConfig, "CENTER", 0, -200)
UIConfig.button:SetSize(140, 40)
UIConfig.button:SetText("Raid Tools")

-- Hide Ironside Raid Tool on startup
UIConfig:Hide()