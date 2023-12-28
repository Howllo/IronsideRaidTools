---@type IRT
local _, IRT = ...;

---@type IRTMasterLoot
IRTMasterLoot = IRT.Award;

IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");
IRT.ScrollingTable = IRT.ScrollingTable or LibStub("ScrollingTable");

---@class IRTMasterLoot
IRT.IRTMasterLoot = {
    defaultIcon = "Interface/Icons/INV_Misc_QuestionMark";
    defaultText = "Type an item ID and hit enter or\ndrag and drop an item to the bar below!";
    hasSelectedLoot = false;
    lastRow = nil;
    data = {};
    openNormally = false;
    MasterLootFrame = nil,
    icon = nil,
    textBox = nil,
    awardButton = nil,
    bidOnItemButton = nil,
    passButton = nil,
    Table = nil,
    itemBeingBiddedOn = nil,
    itemHighestBidder = nil,
    highestBidderBid = nil,
    isCurrentlyBidding = false,
    hasUserUnselectDuringLock = false;
};

function IRTMasterLoot:build()
    if (self.MasterLootFrame) then
        return;
    end

    self.MasterLootFrame = IRT.MasterLootFrame or IRT.AceGUI:Create("Window");
    self.MasterLootFrame:SetTitle(string.format("%s Award", IRT.spaceName));
    self.MasterLootFrame:SetLayout("Flow");
    self.MasterLootFrame:SetWidth(350);
    self.MasterLootFrame:SetHeight(500);
    self.MasterLootFrame:EnableResize(false);
    self.MasterLootFrame:SetCallback("OnClose", function(widget) self.MasterLootFrame:Hide(); LootFrame:Hide() end);

    --[[ 


        Create the first frame for the icon and other information.


    ]]
    local FirstFrame = IRT.AceGUI:Create("SimpleGroup");
    FirstFrame:SetLayout("Flow");
    FirstFrame:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    FirstFrame:SetHeight(64);
    self.MasterLootFrame:AddChild(FirstFrame);

    -- Spacer for the icon.
    local spacer1 = IRT.AceGUI:Create("Label");
    spacer1:SetWidth( (FirstFrame.frame:GetWidth() / 2) - 35);
    spacer1:SetHeight(30);
    spacer1.frame:Hide()
    FirstFrame:AddChild(spacer1);

    --[[ 
        Add default icon for not having anything in the current slot.
    ]]
    self.icon = IRT.AceGUI:Create("Icon");
    self.icon:SetImage(IRT.IRTMasterLoot.defaultIcon);
    self.icon:SetImageSize(64, 64);
    self.icon:SetWidth(64);
    self.icon:SetHeight(64);
    self.icon:SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(IRT.IRTMasterLoot.defaultText);
        GameTooltip:Show();
    end);
    self.icon :SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
    FirstFrame:AddChild(self.icon);
    self.icon.frame:SetPoint("LEFT", FirstFrame.frame, "LEFT", 50, 50)
    
    --[[ 
        Create the second frame for the icon and other information.
    ]]
    local spacerFrame1 = IRT.AceGUI:Create("SimpleGroup");
    spacerFrame1:SetLayout("Flow");
    spacerFrame1:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    spacerFrame1:SetHeight(30);
    self.MasterLootFrame:AddChild(spacerFrame1);

    --[[ 
        Create the second frame for the icon and other information.
    ]]
    local SecondFrame = IRT.AceGUI:Create("SimpleGroup");
    SecondFrame:SetLayout("Flow");
    SecondFrame:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    SecondFrame:SetHeight(32);
    self.MasterLootFrame:AddChild(SecondFrame);

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
    self.textBox = IRT.AceGUI:Create("EditBox");
    self.textBox:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    self.textBox:SetHeight(30);
    self.textBox:SetCallback("OnReceiveDrag",
    function(widget, event, text) 
        self:onItemDragEditBox( widget, event, GetCursorInfo(), self.icon, "ITEM_DRAG" )
    end);
    self.textBox:SetCallback("OnEnterPressed",
    function(widget, event, text) 
        self:onItemDragEditBox( widget, event, text, self.icon, "ITEM_ID" )
    end);
    SecondFrame:AddChild(self.textBox);
    
    --[[ 


        Create the third frame for the icon and other information.


    ]]
    local ThirdFrame = IRT.AceGUI:Create("SimpleGroup");
    ThirdFrame:SetLayout("Flow");
    ThirdFrame:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    ThirdFrame:SetHeight(64);
    self.MasterLootFrame:AddChild(ThirdFrame);

    if not IRT.inteface.partyMembers then
        IRT.Interface:UpdatePartyMembers();
        print("Updating party members")
    end

    --[[
        Who is the top bidder
    ]]
    IRTMasterLoot.topBidder = IRT.AceGUI:Create("Dropdown");
    IRTMasterLoot.topBidder:SetWidth(100);
    IRTMasterLoot.topBidder:SetHeight(30);
    IRTMasterLoot.topBidder:SetList(IRT.Interface.partyMembers);
    ThirdFrame:AddChild(IRTMasterLoot.topBidder);

    --[[
        Start bid button
    ]]
    IRTMasterLoot.startBidButton = IRT.AceGUI:Create("Button");
    IRTMasterLoot.startBidButton:SetText("Start");
    IRTMasterLoot.startBidButton:SetWidth(75);
    IRTMasterLoot.startBidButton:SetHeight(20);
    ThirdFrame:AddChild(IRTMasterLoot.startBidButton);

    --[[
        Stop Bid button
    ]]
    IRTMasterLoot.stopBidButton = IRT.AceGUI:Create("Button");
    IRTMasterLoot.stopBidButton:SetText("Stop");
    IRTMasterLoot.stopBidButton:SetWidth(75);
    IRTMasterLoot.stopBidButton:SetHeight(20);
    ThirdFrame:AddChild(IRTMasterLoot.stopBidButton);
    IRTMasterLoot.stopBidButton:SetDisabled(true);

    --[[ 


        Create the fourth frame for the icon and other information.


    ]]
    local FourthFrame = IRT.AceGUI:Create("SimpleGroup");
    FourthFrame:SetLayout("Flow");
    FourthFrame:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    FourthFrame:SetHeight(100);
    self.MasterLootFrame:AddChild(FourthFrame);

    -- Spacer for the buttons.
    local spacer3 = IRT.AceGUI:Create("Label");
    spacer3:SetFullWidth(true);
    spacer3:SetHeight(30);
    spacer3.frame:Hide()
    FourthFrame:AddChild(spacer3);

    -- Spacer for the buttons.
    local spacer4 = IRT.AceGUI:Create("Label");
    spacer4:SetWidth(15);
    spacer4:SetHeight(30);
    spacer4.frame:Hide()
    FourthFrame:AddChild(spacer4);

    --[[ 
        Create the button to award the item.
    ]]
    self.awardButton = IRT.AceGUI:Create("Button");
    self.awardButton:SetText("Award");
    self.awardButton:SetWidth(100);
    self.awardButton:SetHeight(30);
    self.awardButton:SetCallback("OnClick", function(widget)
        self:awardItem();
    end);
    FourthFrame:AddChild(self.awardButton);

    --[[ 
        Check if the player is the master looter, if not disable award button.
    ]]
    local player = UnitName("player");
    local lootMethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod();
    if(lootMethod == "master") then
        local masterLooter = GetRaidRosterInfo(masterlooterRaidID);
        if(masterLooter ~= player) then
            self.awardButton:SetDisabled(true);
        end
    end

    --[[ 
        Create the button to bids the item.
    ]]
    self.bidOnItemButton = IRT.AceGUI:Create("Button");
    self.bidOnItemButton:SetText("Roll");
    self.bidOnItemButton:SetWidth(100);
    self.bidOnItemButton:SetHeight(30);
    self.bidOnItemButton:SetCallback("OnClick", function(widget)
        self:bidOnItem();
    end);
    FourthFrame:AddChild(self.bidOnItemButton);

    --[[ 
        Create the button to passes on the item.
    ]]
    self.passButton = IRT.AceGUI:Create("Button");
    self.passButton:SetText("Pass");
    self.passButton:SetWidth(100);
    self.passButton:SetHeight(30);
    self.passButton:SetCallback("OnClick", function(widget)
        self:passItem();
    end);
    FourthFrame:AddChild(self.passButton);

    --[[


        FifthFrame Frame for the scrollable frame.

        
    ]]
    local FifthFrame = IRT.AceGUI:Create("SimpleGroup");
    FifthFrame:SetLayout("Flow");
    FifthFrame:SetWidth(self.MasterLootFrame.frame:GetWidth() - 20);
    FifthFrame:SetHeight(200);
    self.MasterLootFrame:AddChild(FifthFrame);

    --[[ 
        Create the scrollable frame for the items.
    ]]
    self:createScrollableFrame(FifthFrame);
end

--- Item that is currently being bidded on and the player that is currently the highest bidder.
---
---@param item string
---@param nameOfHighestBidder string
function IRTMasterLoot:ItemBiddingOn(item, nameOfHighestBidder, bidOrRoll)
    IFT.IRTMasterLoot.itemBeingBiddedOn = item;
    IFT.IRTMasterLoot.itemHighestBidder = nameOfHighestBidder;
    IFT.IRTMasterLoot.highestBidderBid = bidOrRoll;
end

--- Set the start and stop button scripts.
---
---@return void
function IRTMasterLoot:SetStartStopButtonScripts()
    if(self.Table) then
        IRTMasterLoot.startBidButton:SetCallback("OnClick", function(widget)
            if(not IRT.IRTMasterLoot.itemBeingBiddedOn) then return; end
            --IRT.AwardRolling:StartRolling(IRT.IRTMasterLoot.itemBeingBiddedOn);
            IRTMasterLoot.startBidButton:SetDisabled(true);
            IRTMasterLoot.stopBidButton:SetDisabled(false);
            self.isCurrentlyBidding = true;
        end);
        IRTMasterLoot.stopBidButton:SetCallback("OnClick", function(widget)
            --IRT.AwardRolling:StopRolling();
            IRTMasterLoot.stopBidButton:SetDisabled(true);
            IRTMasterLoot.startBidButton:SetDisabled(false);
            self.isCurrentlyBidding = false;
        end);
    else
        IRTMasterLoot.startBidButton:SetDisabled(true);
        IRTMasterLoot.stopBidButton:SetDisabled(true);
    end
end

--- Award Item to player
---
---@param itemID number
---@return void
function IRTMasterLoot:awardItem()
    if(IRT.IRTMasterLoot.itemBeingBiddedOn) then
        IRT.AwardPopup:Toggle()
    end
end

--- Bid on the current item that is being bidded on.
---
---@return void
function IRTMasterLoot:bidOnItem()
    print("IRTMasterLoot:bidOnItem()");
end

--- Passed on the current item that is being bidded on.
---
---@return void
function IRTMasterLoot:passItem()
    print("IRTMasterLoot:passItem()");
end

--- Clear all items information from the frame.
---
---@return void
function IRTMasterLoot:Clear()
    self.textBox:SetText("");
    self.icon:SetImage(IRT.IRTMasterLoot.defaultIcon);
    self.icon :SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(IRT.IRTMasterLoot.defaultText);
        GameTooltip:Show();
    end);
    self.icon :SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
end

--- Toggle the Master Loot Frame
---
---@return void
function IRTMasterLoot:Toggle()
    local menu = self.MasterLootFrame or self:build();
    if (menu) then
        if (menu:IsShown() and IRT.IRTMasterLoot.openNormally) then
            menu:Hide();
        else
            menu:Show();
            self:updateAwardTable();
        end
    end
end

--- Set the information from the item that was dragged or had item id.
---
---@param icon number
---@param itemLink any
function IRTMasterLoot:setInformation(itemLink, icon)
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

---Check if an item is an item link.
---@param text any
---@return boolean
local function IsItemLink(text)
    if(not text) then return false; end

    local linkType = string.match(text, "|H([^:]+)")
    return linkType == "item"
end

--- Displays the item that was dragged, had item id, or clicked on in drop item.
---
---@param text string
---@param icon number
---@return void
function IRTMasterLoot:onItemDragEditBox(widget, event, text, icon, type)
    if(type ~= "ITEM_SELECTED") then
        IRT.IRTMasterLoot.hasSelectedLoot = false;
        self.Table:ClearSelection();
    end

    -- Check if the text is a valid item link and not a number.
    if (IsItemLink(text) and not tonumber(text)) then
        local cursorType, itemID, itemLink = GetCursorInfo();
        if (cursorType == "item") then
            self:setInformation(itemLink, icon);
            ClearCursor();
        else 
            self:setInformation(text, icon);
        end
        return;
    end

    -- Check if the text is a valid item link or number else clear.
    if (not IsItemLink(text) and not tonumber(text)) then
        self:Clear();
        return;
    end
    
    -- Assume that it's a number and get the item link from the item id.
    local itemLink = IRT.ItemLink:getItemLinkFromItemID(text);
    if(itemLink) then
        self:setInformation(itemLink, icon);
    end
end

--- Creates the table for item to be displayed.
---
---@param Frame any
---@return void
function IRTMasterLoot:createScrollableFrame(Frame)
    local columns = {
        {
            name = "Drop Item",
            width = Frame.frame:GetWidth() - 50,
            height = 10,
            align = "LEFT",
            color = {
                r = 0,
                g = 0,
                b = 0,
                a = 1.0
            },
            colorargs = nil,
            sort = "asc",

        },
    }
    self.Table = IRT.ScrollingTable:CreateST(columns, 5, 20, nil, Frame.frame);
    local dropTable = self.Table;
    self.Table.frame:SetPoint("TOP", Frame.frame, "TOP", 2, -30);
    self.Table:EnableSelection(true);
    self.Table:SetData({});

    self.Table:RegisterEvents({
        ["OnClick"] = function(_, _, data, row, _, realrow)
            -- Prevent error from happening when unselected item.
            if self.hasUserUnselectDuringLock then
                self.hasUserUnselectDuringLock = false
                return
            end


            if(self.lastRow ~= realrow and not self.isCurrentlyBidding) then
                -- Prevent error from happening when the table sort is changed.
                if( not data[realrow]
                    or not data[realrow].itemLink
                    or not data[realrow].cols
                    or type(data) ~= "table") then
                    return;
                end

                self.hasSelectedLoot = true;
                local itemLink = data[realrow].itemLink;
                IRT.IRTMasterLoot.itemBeingBiddedOn = itemLink;
                self:onItemDragEditBox(nil, nil, itemLink, self.icon, "ITEM_SELECTED");
                self.lastRow = realrow;
            elseif(self.lastRow == realrow and not self.isCurrentlyBidding) then
                self:Clear();
                self.hasSelectedLoot = false;
                self.lastRow = nil;
                IRT.IRTMasterLoot.itemBeingBiddedOn = nil;
                if (self.hasUserUnselectDuringLock) then
                    self.hasUserUnselectDuringLock = false
                    dropTable.ClearSelection()
                end 
             -- Preventing the user from bugging out the UI due to limitation of ScrollingTable.
            elseif (self.isCurrentlyBidding) then 
                if(self.hasUserUnselectDuringLock) then
                    self.hasUserUnselectDuringLock = false;
                else 
                    self.hasUserUnselectDuringLock = true;
                end
            end
        end,
    });

    --[[ 
        Add items to the scrollframe.
    ]]
    self:updateAwardTable();

    --[[ 
        Set the start and stop button scripts.
    ]]
    IRTMasterLoot:SetStartStopButtonScripts();
end

--- Update Award Table
---
---@return void
function IRTMasterLoot:updateAwardTable()
        --[[ 
        Add items to the scrollframe.
    ]]
    self.data = {}
    for i = 1, GetNumLootItems() do
        local link = GetLootSlotLink(i)
        local lootIcon, lootName, lootQuantity, currencyID, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
        if(lootQuality >= 2) then
            local r,g,b,a = IRT.Interface:HexToRGBA(IRT.Data.Constants.Item_Quality[lootQuality].color, 1.0)
            table.insert(self.data, 1, {
                cols = {
                    {
                        value = string.format("|T%s:0|t %s", lootIcon, lootName),
                        args = nil,
                        color = {
                            r = r,
                            g = g,
                            b = b,
                            a = a,
                        }
                    },
                },
                itemLink = link,
            })
        end
    end
    self.Table:SetData(self.data);
end

--- Create Event to handle tooltip
local LootingCorpse = CreateFrame("Frame");
LootingCorpse:RegisterEvent("LOOT_OPENED");
LootingCorpse:RegisterEvent("LOOT_CLOSED");
LootingCorpse:SetScript("OnEvent", function(self, event)
    if (event == "LOOT_OPENED") then
        --[[
            Add Tooltips for the player when looting
        ]]
        if(GetLootThreshold() >= 1 and IsInRaid()) then
        end
        IRTMasterLoot:Toggle();
        IRTMasterLoot.openNormally = true;
    end

    if (event == "LOOT_CLOSED") then
        if (IRTMasterLoot.MasterLootFrame) then
            IRTMasterLoot.MasterLootFrame:Hide();
            IRTMasterLoot:Clear();
            IRTMasterLoot.hasSelectedLoot = false;
            IRTMasterLoot.lastRow = nil;
            IRTMasterLoot.Table:ClearSelection();
        end
        IRTMasterLoot.openNormally = false;
    end
end)