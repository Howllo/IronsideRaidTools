---@type IRT
local _, IRT = ...;

IRT.Award = {};
IRTMasterLoot = IRT.Award;

-- Ace UI
IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");

-- Scrolling Table
IRT.ScrollingTable = IRT.ScrollingTable or LibStub("ScrollingTable");

-- Variables
local defaultIcon = "Interface/Icons/INV_Misc_QuestionMark";
local defaultText = "Type an item ID and hit enter or\ndrag and drop an item to the bar below!\nHitting okay may not work.";

function IRTMasterLoot:build()
    if (IRTMasterLoot.MasterLootFrame) then
        return;
    end

    IRTMasterLoot.MasterLootFrame = IRT.MasterLootFrame or IRT.AceGUI:Create("Window");
    IRTMasterLoot.MasterLootFrame:SetTitle(string.format("%s Award", IRT.spaceName));
    IRTMasterLoot.MasterLootFrame:SetLayout("Flow");
    IRTMasterLoot.MasterLootFrame:SetWidth(350);
    IRTMasterLoot.MasterLootFrame:SetHeight(400);
    IRTMasterLoot.MasterLootFrame:EnableResize(false);
    IRTMasterLoot.MasterLootFrame:SetCallback("OnClose", function(widget) IRTMasterLoot.MasterLootFrame:Hide(); LootFrame:Hide() end);

    --[[ 
        Create the first frame for the icon and other information.
    ]]
    local FirstFrame = IRT.AceGUI:Create("SimpleGroup");
    FirstFrame:SetLayout("Flow");
    FirstFrame:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    FirstFrame:SetHeight(64);
    IRTMasterLoot.MasterLootFrame:AddChild(FirstFrame);

    -- Spacer for the icon.
    local spacer1 = IRT.AceGUI:Create("Label");
    spacer1:SetWidth( (FirstFrame.frame:GetWidth() / 2) - 35);
    spacer1:SetHeight(30);
    spacer1.frame:Hide()
    FirstFrame:AddChild(spacer1);

    --[[ 
        Add default icon for not having anything in the current slot.
    ]]
    IRTMasterLoot.icon = IRT.AceGUI:Create("Icon");
    IRTMasterLoot.icon :SetImage(defaultIcon);
    IRTMasterLoot.icon :SetImageSize(64, 64);
    IRTMasterLoot.icon :SetWidth(64);
    IRTMasterLoot.icon :SetHeight(64);
    IRTMasterLoot.icon :SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(defaultText);
        GameTooltip:Show();
    end);
    IRTMasterLoot.icon :SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
    FirstFrame:AddChild(IRTMasterLoot.icon );
    IRTMasterLoot.icon.frame:SetPoint("LEFT", FirstFrame.frame, "LEFT", 50, 50)
    
    --[[ 
        Create the second frame for the icon and other information.
    ]]
    local spacerFrame1 = IRT.AceGUI:Create("SimpleGroup");
    spacerFrame1:SetLayout("Flow");
    spacerFrame1:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    spacerFrame1:SetHeight(30);
    IRTMasterLoot.MasterLootFrame:AddChild(spacerFrame1);

    --[[ 
        Create the second frame for the icon and other information.
    ]]
    local SecondFrame = IRT.AceGUI:Create("SimpleGroup");
    SecondFrame:SetLayout("Flow");
    SecondFrame:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    SecondFrame:SetHeight(32);
    IRTMasterLoot.MasterLootFrame:AddChild(SecondFrame);

    -- Spacer for the icon.
    local spacer2_0 = IRT.AceGUI:Create("Label");
    spacer2_0:SetWidth(117)
    spacer2_0:SetHeight(10);
    spacer2_0:SetText(" ")
    SecondFrame:AddChild(spacer2_0);

    local spacer2 = IRT.AceGUI:Create("Label");
    spacer2:SetWidth(100);
    spacer2:SetHeight(10);
    spacer2:SetText("Item ID/Drag")
    SecondFrame:AddChild(spacer2);
    spacer2:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

    --[[ 
        Create the edit box for drag and drop functionality and name.
    ]]
    IRTMasterLoot.textBox = IRT.AceGUI:Create("EditBox");
    IRTMasterLoot.textBox:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    IRTMasterLoot.textBox:SetHeight(30);
    IRTMasterLoot.textBox:SetCallback("OnEnterPressed", function(widget, event, text) IRTMasterLoot:onItemDragEditBox(widget, event, text, IRTMasterLoot.icon ) end);
    SecondFrame:AddChild(IRTMasterLoot.textBox);
    
    --[[ 
        Create the third frame for the icon and other information.
    ]]
    local ThirdFrame = IRT.AceGUI:Create("SimpleGroup");
    ThirdFrame:SetLayout("Flow");
    ThirdFrame:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    ThirdFrame:SetHeight(64);
    IRTMasterLoot.MasterLootFrame:AddChild(ThirdFrame);

    -- Spacer for the buttons.
    local spacer3 = IRT.AceGUI:Create("Label");
    spacer3:SetFullWidth(true);
    spacer3:SetHeight(30);
    spacer3.frame:Hide()
    ThirdFrame:AddChild(spacer3);

    -- Spacer for the buttons.
    local spacer4 = IRT.AceGUI:Create("Label");
    spacer4:SetWidth(15);
    spacer4:SetHeight(30);
    spacer4.frame:Hide()
    ThirdFrame:AddChild(spacer4);

    --[[ 
        Create the button to award the item.
    ]]
    IRTMasterLoot.awardButton = IRT.AceGUI:Create("Button");
    IRTMasterLoot.awardButton:SetText("Award");
    IRTMasterLoot.awardButton:SetWidth(100);
    IRTMasterLoot.awardButton:SetHeight(30);
    IRTMasterLoot.awardButton:SetCallback("OnClick", function(widget)
        local itemID = tonumber(IRTMasterLoot.textBox:GetText());
        if (itemID) then
            IRTMasterLoot:awardItem(itemID);
        end
    end);
    ThirdFrame:AddChild(IRTMasterLoot.awardButton);

    --[[ 
        Check if the player is the master looter, if not disable award button.
    ]]
    local player = UnitName("player");
    local lootMethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod();
    if(lootMethod == "master") then
        local masterLooter = GetRaidRosterInfo(masterlooterRaidID);
        if(masterLooter ~= player) then
            IRTMasterLoot.awardButton:SetDisabled(true);
        end
    end

    --[[ 
        Create the button to bids the item.
    ]]
    IRTMasterLoot.bidOnItem = IRT.AceGUI:Create("Button");
    IRTMasterLoot.bidOnItem:SetText("Roll");
    IRTMasterLoot.bidOnItem:SetWidth(100);
    IRTMasterLoot.bidOnItem:SetHeight(30);
    IRTMasterLoot.bidOnItem:SetCallback("OnClick", function(widget)
        IRTMasterLoot:passItem();
    end);
    ThirdFrame:AddChild(IRTMasterLoot.bidOnItem);

    --[[ 
        Create the button to passes on the item.
    ]]
    IRTMasterLoot.passButton = IRT.AceGUI:Create("Button");
    IRTMasterLoot.passButton:SetText("Pass");
    IRTMasterLoot.passButton:SetWidth(100);
    IRTMasterLoot.passButton:SetHeight(30);
    IRTMasterLoot.passButton:SetCallback("OnClick", function(widget)
        IRTMasterLoot:passItem();
    end);
    ThirdFrame:AddChild(IRTMasterLoot.passButton);

    --[[
        Fourth Frame for the scrollable frame.
    ]]
    local FourthFrame = IRT.AceGUI:Create("SimpleGroup");
    FourthFrame:SetLayout("Flow");
    FourthFrame:SetWidth(IRTMasterLoot.MasterLootFrame.frame:GetWidth() - 20);
    FourthFrame:SetHeight(200);
    IRTMasterLoot.MasterLootFrame:AddChild(FourthFrame);

    --[[ 
        Create the scrollable frame for the items.
    ]]
    IRTMasterLoot:createScrollableFrame(FourthFrame);
end

--- Bid on the current item thati s being bidded on.
---
---@return void
function IRTMasterLoot:bidOnItem()
end

--- Passed on the current item that is being bidded on.
---
---@return void
function IRTMasterLoot:passItem()
end

--- Clear all items information from the frame.
---
---@return void
function IRTMasterLoot:Clear()
    IRTMasterLoot.textBox:SetText("");
    IRTMasterLoot.icon:SetImage(defaultIcon);
    IRTMasterLoot.icon :SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(defaultText);
        GameTooltip:Show();
    end);
    IRTMasterLoot.icon :SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
end

--- Toggle the Master Loot Frame
---
---@return void
function IRTMasterLoot:Toggle()
    local menu = IRTMasterLoot.MasterLootFrame or IRTMasterLoot:build();
    if (menu) then
        if (menu:IsShown()) then
            menu:Hide();
        else
            menu:Show();
        end
    end
end

--- Set the information from the item that was dragged or had item id.
---
---@param icon number
---@param itemLink any
local function setInformation(icon, itemLink)
    local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemLink)
    IRTMasterLoot.textBox:SetText(itemName);
    IRTMasterLoot.textBox:ClearFocus();

    --[[
        Set the icon to the item dragged.
    ]]
    icon:SetImage(itemTexture);
    icon:SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetHyperlink(itemLink);
        GameTooltip:Show();
    end);

    icon:SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
end

--- Award the item to the player.
---
---@param text string
---@param icon number
---@return void
function IRTMasterLoot:onItemDragEditBox(widget, event, text, icon)
    local pattern = "|c%x+|Hitem:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+|h%[.+%]|h|r"

    -- Check if the text is a valid item link or number else clear.
    if (not string.match(text, pattern) and not tonumber(text)) then
        IRTMasterLoot:Clear();
        return;
    end
    
    -- Check if the text is a valid item link and not a number.
    if (not string.match(text, pattern) and not tonumber(text)) then
        local cursorType, itemID, itemLink = GetCursorInfo();
        setInformation(icon, itemLink);
        ClearCursor();
        return;
    end
    
    -- Assume that it's a number and get the item link from the item id.
    local itemLink = IRT.ItemLink:getItemLinkFromItemID(text);
    if(itemLink) then
        setInformation(icon, itemLink);
    end
end

--- Creates the table for item to be displayed.
---
---@param FourthFrame any
---@return void
function IRTMasterLoot:createScrollableFrame(FourthFrame)
    local columns = {
        {
            name = "Drop Item",
            width = FourthFrame.frame:GetWidth() - 50,
            align = "LEFT",
            color = {
                r = 0.5,
                g = 0.5,
                b = 1.0,
                a = 1.0
            },
            colorargs = nil,
            sort = "asc",

        },
    }
    local Table = IRT.ScrollingTable:CreateST(columns, 5, 20, nil, FourthFrame.frame);
    Table.frame:SetPoint("TOP", FourthFrame.frame, "TOP", 2, -30);
    Table:EnableSelection(true);
    Table:SetData({});

    Table:RegisterEvents({
        ["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
            if (row) then
                local itemLink = data[row].itemLink;
                if (itemLink) then
                    IRTMasterLoot:onItemDragEditBox(nil, nil, itemLink, IRTMasterLoot.icon );
                end
            end
        end,
    });

    --[[ 
        Add items to the scrollframe.
    ]]
    local data = {}
    for i = 1, GetNumLootItems() do
        local link = GetLootSlotLink(i)
        local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
        table.insert(data, {
            cols = {
                {
                    value = string.format("|T%s:0|t %s", lootIcon, lootName),
                    args = nil,
                    color = IRT.Interface:HexToRGB(IRT.Data.Constants.Item_Quality[lootQuality].color),
                },
            },
            itemLink = link,
        })
    end
    Table:SetData(data);
end

--- Create Event to handle tooltip
local LootingCorpse = CreateFrame("Frame");
LootingCorpse:RegisterEvent("LOOT_OPENED");
LootingCorpse:RegisterEvent("LOOT_CLOSED");
LootingCorpse:SetScript("OnEvent", function(self, event)
    if (event == "LOOT_OPENED") then

        print(GetLootThreshold())
        --[[
            Add Tooltips for the player when looting
        ]]
        if(GetLootThreshold() >= 1 and IsInRaid()) then
            IRTMasterLoot:Toggle();
        end
    end

    if (event == "LOOT_CLOSED") then
        if (IRTMasterLoot.MasterLootFrame) then
            IRTMasterLoot.MasterLootFrame:Hide();
        end
    end
end)