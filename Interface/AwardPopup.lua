---@type IRT
local _, IRT = ...;

-- Ace
local AceGUI = LibStub("AceGUI-3.0");

IRT.AwardPopup = IRT.AwardPopup or {};
AwardPopup = IRT.AwardPopup;

function AwardPopup:build(item, player)
    local width = 560;
    AwardPopup.Window = AceGUI:Create("Window");
    local window = AwardPopup.Window;
    window:SetTitle(string.format("Award Item", IRT.ShortName));
    window:SetLayout("Flow");
    window:SetWidth(width);
    window:SetHeight(100);
    window:EnableResize(false);
    window:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget);
    end);
    window.frame:SetFrameStrata("FULLSCREEN_DIALOG")

    --[[
        Holder Frame
    ]]
    local holder = AceGUI:Create("SimpleGroup");
    holder:SetFullWidth(true);
    holder:SetHeight(100);
    holder:SetLayout("Flow");
    window:AddChild(holder);

    --[[
        Create label that state the item to player.
    ]]
    local itemLabel = AceGUI:Create("Label");
    itemLabel:SetText("Are you sure you want to award this item?");
    itemLabel:SetWidth(75);
    holder:AddChild(itemLabel);
    
    --[[ 
        Second Holder Frame for buttons
    ]]
    local holder2 = AceGUI:Create("SimpleGroup");
    holder2:SetFullWidth(true);
    holder2:SetHeight(100);
    holder2:SetLayout("Flow");
    window:AddChild(holder2);

    local spacer = AceGUI:Create("Label");
    spacer:SetText(" ");
    spacer:SetWidth(width / 2 - 65);
    holder2:AddChild(spacer);

    --[[
        Award Button
    ]]
    local awardButton = AceGUI:Create("Button");
    awardButton:SetText("Confirm");
    awardButton:SetWidth(100);
    awardButton:SetCallback("OnClick", function()
        SendChatMessage(string.format("Awarding %s to %s", item:GetText(), player:GetText()), "RAID");
        SendChatMessage(string.format("/loot %s %s", item:GetText(), player:GetText()), "SAY");
        AceGUI:Release(window);
    end);
    holder2:AddChild(awardButton);
end

--- Toggle the menu on and offf.
---
---@return void
function AwardPopup:Toggle()
    local menu = AwardPopup.Window or AwardPopup:build();
    if (menu) then
        if (menu:IsShown()) then
            menu:Hide();
        else
            menu:Show();
        end
    end
end