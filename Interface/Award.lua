---@type IRT
local _, IRT = ...;

IRT.AceGUI = IRT.AceGUI or LibStub("AceGUI-3.0");
IRT.ScrollingTable = IRT.ScrollingTable or LibStub("ScrollingTable");

---@class IRTAward
IRT.IRTAward = {
    defaultIcon = "Interface/Icons/INV_Misc_QuestionMark";
    defaultText = "Type an item ID and hit enter or\ndrag and drop an item to the bar below!";
    hasSelectedLoot = false,
    lastRow = nil,
    data = {},
    bidData = {},
    openNormally = false,
    AwardLootFrame = nil,
    icon = nil,
    textBox = nil,
    awardButton = nil,
    bidOnItemButton = nil,
    passButton = nil,
    LootTable = {},
    BidTable = {},
    itemBeingBiddedOn = nil,
    itemHighestBidder = nil,
    highestBidderBid = nil,
    isCurrentlyBidding = false,
    isRollTab = false,
};

---@type IRTAward
IRTAward = IRT.IRTAward;

function IRTAward:build()
    if (self.AwardLootFrame) then
        return;
    end

    self.AwardLootFrame = IRT.AwardLootFrame or IRT.AceGUI:Create("Window");
    self.AwardLootFrame:SetTitle(string.format("%s Award", IRT.spaceName));
    self.AwardLootFrame:SetLayout("Flow");
    self.AwardLootFrame:SetWidth(350);
    self.AwardLootFrame:SetHeight(560);
    self.AwardLootFrame:EnableResize(false);
    self.AwardLootFrame:SetCallback("OnClose",
        function(widget)
            self.AwardLootFrame:Hide();
        end
    );

    --[[ 


        Create the first frame for the icon and other information.


    ]]
    local FirstFrame = IRT.AceGUI:Create("SimpleGroup");
    FirstFrame:SetLayout("Flow");
    FirstFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    FirstFrame:SetHeight(64);
    self.AwardLootFrame:AddChild(FirstFrame);

    -- Spacer for the icon.
    local spacer1 = IRT.AceGUI:Create("Label");
    spacer1:SetWidth( (FirstFrame.frame:GetWidth() / 2) - 30);
    spacer1:SetHeight(30);
    spacer1.frame:Hide()
    FirstFrame:AddChild(spacer1);

    --[[ 
        Add default icon for not having anything in the current slot.
    ]]
    self.icon = IRT.AceGUI:Create("Icon");
    self.icon:SetImage(IRT.IRTAward.defaultIcon);
    self.icon:SetImageSize(64, 64);
    self.icon:SetWidth(64);
    self.icon:SetHeight(64);
    self.icon:SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(IRT.IRTAward.defaultText);
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
    spacerFrame1:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    spacerFrame1:SetHeight(10);
    self.AwardLootFrame:AddChild(spacerFrame1);

    --[[ 


        Create the second frame for the item id and drag and drop.


    ]]
    local SecondFrame = IRT.AceGUI:Create("SimpleGroup");
    SecondFrame:SetLayout("Flow");
    SecondFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    SecondFrame:SetHeight(32);
    self.AwardLootFrame:AddChild(SecondFrame);

    --[[
        Spacer for the ItemID/Drag.
    ]]
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
    self.textBox:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    self.textBox:SetHeight(30);
    self.textBox:SetCallback("OnReceiveDrag",
    function(widget, event, text) 
        self:onItemDragEditBox( widget, event, GetCursorInfo(), self.icon, "ITEM_DRAG" )
    end);
    self.textBox:SetCallback("OnEnterPressed",
    function(widget, event, text) 
        self:onItemDragEditBox( widget, event, text, self.icon, "ITEM_ID" )
    end);
    self.textBox:DisableButton(true);
    SecondFrame:AddChild(self.textBox);
    
    --[[


        Create the third frame for the note information and timers.


    ]]
    local ThirdFrame = IRT.AceGUI:Create("SimpleGroup");
    ThirdFrame:SetLayout("Flow");
    ThirdFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    ThirdFrame:SetHeight(32);
    self.AwardLootFrame:AddChild(ThirdFrame);

    --[[
        Note label 
    ]]
    local noteLabel = IRT.AceGUI:Create("Label");
    noteLabel:SetText("Note: ");
    noteLabel:SetWidth(30);
    noteLabel:SetHeight(10);
    ThirdFrame:AddChild(noteLabel);

    --[[
        Message to be send out in raid warning.
    ]]
    IRTAward.noteMessageToSend = IRT.AceGUI:Create("EditBox");
    IRTAward.noteMessageToSend:SetWidth(self.AwardLootFrame.frame:GetWidth() - 55);
    IRTAward.noteMessageToSend:SetHeight(30);
    IRTAward.noteMessageToSend:DisableButton(true);
    IRTAward.noteMessageToSend:SetText(IRT.Data.Constants.defaultRollNoteMessage);
    ThirdFrame:AddChild(IRTAward.noteMessageToSend);

    --[[
        Spacer
    ]]
    local spacer2_4 = IRT.AceGUI:Create("Label");
    spacer2_4:SetWidth(30)
    spacer2_4:SetHeight(10);
    spacer2_4:SetText(" ")
    ThirdFrame:AddChild(spacer2_4);


    --[[
        Timer Label
    ]]
    local timerLabel = IRT.AceGUI:Create("Label");
    timerLabel:SetText("Timer:");
    timerLabel:SetWidth(45);
    timerLabel:SetHeight(10);
    ThirdFrame:AddChild(timerLabel);

    --[[
        Timer Editbox
    ]]
    IRTAward.timer = IRT.AceGUI:Create("EditBox");
    IRTAward.timer:SetWidth(50);
    IRTAward.timer:SetHeight(30);
    IRTAward.timer:DisableButton(true);
    IRTAward.timer:SetText(IRT.Data.Constants.defaultRollTimer);
    ThirdFrame:AddChild(IRTAward.timer);

    --[[
        Spacer
    ]]
    local spacer2_3 = IRT.AceGUI:Create("Label");
    spacer2_3:SetWidth(20)
    spacer2_3:SetHeight(10);
    spacer2_3:SetText(" ")
    ThirdFrame:AddChild(spacer2_3);

    --[[
        Start bid button
    ]]
    IRTAward.startBidButton = IRT.AceGUI:Create("Button");
    IRTAward.startBidButton:SetText("Start");
    IRTAward.startBidButton:SetWidth(75);
    IRTAward.startBidButton:SetHeight(20);
    ThirdFrame:AddChild(IRTAward.startBidButton);

    --[[
        Stop Bid button
    ]]
    IRTAward.stopBidButton = IRT.AceGUI:Create("Button");
    IRTAward.stopBidButton:SetText("Stop");
    IRTAward.stopBidButton:SetWidth(75);
    IRTAward.stopBidButton:SetHeight(20);
    ThirdFrame:AddChild(IRTAward.stopBidButton);
    IRTAward.stopBidButton:SetDisabled(true);

    --[[
        Spacer frame
    ]]
    local spacerFrame2 = IRT.AceGUI:Create("SimpleGroup");
    spacerFrame2:SetLayout("Flow");
    spacerFrame2:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    spacerFrame2:SetHeight(5);
    self.AwardLootFrame:AddChild(spacerFrame2);

    --[[ 


        Create the fourth frame for the award and buttons.


    ]]
    local FourthFrame = IRT.AceGUI:Create("SimpleGroup");
    FourthFrame:SetLayout("Flow");
    FourthFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    FourthFrame:SetHeight(64);
    self.AwardLootFrame:AddChild(FourthFrame);

    --[[
        Make sure that the party members was updated.
    ]]
    if not IRT.Interface.partyMembers then
        IRT.Interface:UpdatePartyMembers();
    end

    -- Spacer
    local spacer2_1 = IRT.AceGUI:Create("Label");
    spacer2_1:SetWidth(10)
    spacer2_1:SetHeight(10);
    spacer2_1:SetText(" ")
    FourthFrame:AddChild(spacer2_1);

    --[[ 
        Create the label for the party members.
    ]]
    local partyMembersWinnerLabel = IRT.AceGUI:Create("Label");
    partyMembersWinnerLabel:SetText("Winner: ");
    partyMembersWinnerLabel:SetWidth(55);
    partyMembersWinnerLabel:SetHeight(10);
    FourthFrame:AddChild(partyMembersWinnerLabel);
    partyMembersWinnerLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

    --[[
        Who is the top bidder.
    ]]
    IRTAward.topBidder = IRT.AceGUI:Create("Dropdown");
    IRTAward.topBidder:SetWidth(125);
    IRTAward.topBidder:SetHeight(30);
    IRTAward.topBidder:SetList(IRT.Interface.partyMembers);
    FourthFrame:AddChild(IRTAward.topBidder);
    IRTAward.topBidder:SetValue(1);

    -- Spacer
    local spacer2_2 = IRT.AceGUI:Create("Label");
    spacer2_2:SetWidth(20)
    spacer2_2:SetHeight(10);
    spacer2_2:SetText(" ")
    FourthFrame:AddChild(spacer2_2);

    --[[ 
        Create the label for the cost amount
    ]]
    local partyMembersWinnerLabel = IRT.AceGUI:Create("Label");
    partyMembersWinnerLabel:SetText("Amount: ");
    partyMembersWinnerLabel:SetWidth(55);
    partyMembersWinnerLabel:SetHeight(10);
    FourthFrame:AddChild(partyMembersWinnerLabel);
    partyMembersWinnerLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")

    --[[
        How much the top bidder bid.
    ]]
    IRTAward.BidAmount = IRT.AceGUI:Create("EditBox");
    IRTAward.BidAmount:SetWidth(50);
    IRTAward.BidAmount:SetHeight(30);
    IRTAward.BidAmount:SetText("0000");
    FourthFrame:AddChild(IRTAward.BidAmount);
    IRTAward.BidAmount:SetDisabled(true);

    --[[ 


        Create the FifthFrame frame for the icon and other information.


    ]]
    local FifthFrame = IRT.AceGUI:Create("SimpleGroup");
    FifthFrame:SetLayout("Flow");
    FifthFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    FifthFrame:SetHeight(100);
    self.AwardLootFrame:AddChild(FifthFrame);

    -- Spacer for the buttons.
    local spacer3 = IRT.AceGUI:Create("Label");
    spacer3:SetFullWidth(true);
    spacer3:SetHeight(30);
    spacer3.frame:Hide()
    FifthFrame:AddChild(spacer3);

    -- Spacer for the buttons.
    local spacer4 = IRT.AceGUI:Create("Label");
    spacer4:SetWidth(15);
    spacer4:SetHeight(30);
    spacer4.frame:Hide()
    FifthFrame:AddChild(spacer4);

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
    FifthFrame:AddChild(self.awardButton);

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
    FifthFrame:AddChild(self.bidOnItemButton);

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
    FifthFrame:AddChild(self.passButton);

    --[[


        SixthFrame Frame for the scrollable frame.

        
    ]]
    local SixthFrame = IRT.AceGUI:Create("SimpleGroup");
    SixthFrame:SetLayout("Flow");
    SixthFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    SixthFrame:SetHeight(180);
    self.AwardLootFrame:AddChild(SixthFrame);

    --[[
        Tab Frame
    ]]
    local tabFrame = IRT.AceGUI:Create("TabGroup");
    tabFrame:SetLayout("Flow");
    tabFrame:SetTabs({{text = "Items(s)", value = "item"}, {text = "Roll(s)", value = "Roll"}});
    tabFrame:SetCallback("OnGroupSelected", function(widget, event, value)
        if(value == "item") then
            self.LootTable.frame:Show();
            self.BidTable.frame:Hide();
            self.isRollTab = false;
        else
            self.LootTable.frame:Hide();
            self.BidTable.frame:Show();
            self.isRollTab = true;
        end
    end);
    tabFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    SixthFrame:AddChild(tabFrame);

    --[[
        Scroll Frame Holder
    ]]
    local scrollFrameHolder = IRT.AceGUI:Create("SimpleGroup");
    scrollFrameHolder:SetLayout("Flow");
    scrollFrameHolder:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    scrollFrameHolder:SetHeight(140);
    tabFrame:AddChild(scrollFrameHolder);

    --[[ 
        Create the scrollable frame for the items.
    ]]
    self:createScrollableLoot(scrollFrameHolder);

    --[[ 
        Create the scrollable frame for the bids.
    ]]
    self:createScrollableBidTable(scrollFrameHolder);

    --[[
        Final Frame
    ]]
    local FinalFrame = IRT.AceGUI:Create("SimpleGroup");
    FinalFrame:SetLayout("Flow");
    FinalFrame:SetWidth(self.AwardLootFrame.frame:GetWidth() - 20);
    FinalFrame:SetHeight(30);
    self.AwardLootFrame:AddChild(FinalFrame);

    --[[
        Toggle button for DKP.
    ]]
    IRTAward.dkpCheckBox = IRT.AceGUI:Create("CheckBox");
    IRTAward.dkpCheckBox:SetLabel("Use DKP system.");
    IRTAward.dkpCheckBox:SetWidth(200);
    IRTAward.dkpCheckBox:SetCallback("OnValueChanged", function(widget, event, value)
        if(value) then
            IRT.AwardRoll.usingDKP = true;
            IRT.Data.Constants.defaultRollType = "bid";
        else
            IRT.AwardRoll.uusingDKP = false;
            IRT.Data.Constants.defaultRollType = "roll";
        end
    end);
    FinalFrame:AddChild(IRTAward.dkpCheckBox);

    -- Set Tab to item.
    tabFrame:SelectTab("item");
end

--- Item that is currently being bidded on and the player that is currently the highest bidder.
---
---@param item string
---@param nameOfHighestBidder string
function IRTAward:ItemBiddingOn(item, nameOfHighestBidder, bidOrRoll)
    IFT.IRTAward.itemBeingBiddedOn = item;
    IFT.IRTAward.itemHighestBidder = nameOfHighestBidder;
    IFT.IRTAward.highestBidderBid = bidOrRoll;
end

--- Set the start and stop button scripts.
---
---@return void
function IRTAward:SetStartStopButtonScripts()
    if(self.LootTable) then
        IRTAward.startBidButton:SetCallback("OnClick", function(widget)
            if(not IRT.IRTAward.itemBeingBiddedOn) then return; end
            IRT.AwardRoll:StartRolling(IRT.IRTAward.itemBeingBiddedOn, IRTAward.timer:GetText());
            IRTAward.startBidButton:SetDisabled(true);
            IRTAward.stopBidButton:SetDisabled(false);
            IRTAward.LootTable:Hide();
            self.isCurrentlyBidding = true;
        end);
        IRTAward.stopBidButton:SetCallback("OnClick", function(widget)
            IRT.AwardRoll:StopRolling();
            IRTAward.stopBidButton:SetDisabled(true);
            IRTAward.startBidButton:SetDisabled(false);
            if(not self.isRollTab) then
                IRTAward.LootTable:Show();
            end
            self.isCurrentlyBidding = false;
        end);
    else
        IRTAward.startBidButton:SetDisabled(true);
        IRTAward.stopBidButton:SetDisabled(true);
    end
end

--- Award Item to player
---
---@param itemID number
---@return void
function IRTAward:awardItem()
    if(IRT.IRTAward.itemBeingBiddedOn) then
        IRT.AwardPopup:Toggle()
    end
end

--- Bid on the current item that is being bidded on.
---
---@return void
function IRTAward:bidOnItem()
    print("IRTAward:bidOnItem()");
end

--- Passed on the current item that is being bidded on.
---
---@return void
function IRTAward:passItem()
    print("IRTAward:passItem()");
end

--- Clear all items information from the frame.
---
---@return void
function IRTAward:Clear()
    self.textBox:SetText("");
    self.icon:SetImage(IRT.IRTAward.defaultIcon);

    self.icon :SetCallback("OnEnter", function(widget)
        GameTooltip:SetOwner(widget.frame, "ANCHOR_RIGHT");
        GameTooltip:SetText(IRT.IRTAward.defaultText);
        GameTooltip:Show();
    end);

    self.icon :SetCallback("OnLeave", function(widget)
        GameTooltip:Hide();
    end);
end

--- Toggle the Master Loot Frame
---
---@return void
function IRTAward:Toggle()
    local menu = self.AwardLootFrame or self:build();
    if (menu) then
        if (menu:IsShown() and IRT.IRTAward.openNormally) then
            menu:Hide();
        else
            menu:Show();
            self:updateLootTable();
        end
    end
end

--- Set the information from the item that was dragged or had item id.
---
---@param icon number
---@param itemLink any
function IRTAward:setInformation(itemLink, icon)
    local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemLink)
    IRTAward.textBox:SetText(itemName);
    IRTAward.textBox:ClearFocus();

    IRT.IRTAward.itemBeingBiddedOn = itemLink;

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
function IRTAward:onItemDragEditBox(widget, event, text, icon, type)
    if(type ~= "ITEM_SELECTED") then
        IRT.IRTAward.hasSelectedLoot = false;
        self.LootTable:ClearSelection();
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
function IRTAward:createScrollableLoot(Frame)
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

    self.LootTable = IRT.ScrollingTable:CreateST(columns, 5, 20, nil, Frame.frame);
    self.LootTable.frame:SetPoint("TOP", Frame.frame, "TOP", 2, -30);
    self.LootTable:EnableSelection(true);
    self.LootTable:SetData({});

    self.LootTable:RegisterEvents({
        ["OnClick"] = function(_, _, data, row, _, realrow)
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
                self:onItemDragEditBox(nil, nil, itemLink, self.icon, "ITEM_SELECTED");
                self.lastRow = realrow;
            elseif(self.lastRow == realrow and not self.isCurrentlyBidding) then
                self:Clear();
                self.hasSelectedLoot = false;
                self.lastRow = nil;
                IRT.IRTAward.itemBeingBiddedOn = nil;
            end
        end,
    });

    --[[ 
        Add items to the scrollframe.
    ]]
    self:updateLootTable();

    --[[ 
        Set the start and stop button scripts.
    ]]
    IRTAward:SetStartStopButtonScripts();
end

--- Update loot table with items that are in the loot window.
---
---@return void
function IRTAward:updateLootTable()
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
    self.LootTable:SetData(self.data);
end

--- Creates the table for item to be displayed.
---
---@param Frame any
---@return void
function IRTAward:createScrollableBidTable(Frame)
    local columns = {
        {
            name = "Names                        Amount                +1",
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

    self.BidTable = IRT.ScrollingTable:CreateST(columns, 5, 20, nil, Frame.frame);
    self.BidTable.frame:SetPoint("TOP", Frame.frame, "TOP", 2, -30);
    self.BidTable:EnableSelection(true);
    self.BidTable:SetData({});

    self.BidTable:RegisterEvents({
        ["OnClick"] = function(_, _, data, row, _, realrow)
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
                self:onItemDragEditBox(nil, nil, itemLink, self.icon, "ITEM_SELECTED");
                self.lastRow = realrow;
            elseif(self.lastRow == realrow and not self.isCurrentlyBidding) then
                self.hasSelectedLoot = false;
                self.lastRow = nil;
                IRT.IRTAward.itemBeingBiddedOn = nil;
            end
        end,
    });
end

--- Update loot table with items that are in the roll window.
---
---@return void
function IRTAward:updateLootTable(data)
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
    self.LootTable:SetData(self.data);
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
        IRTAward:Toggle();
        IRTAward.openNormally = true;
    end

    if (event == "LOOT_CLOSED") then
        if (IRTAward.AwardLootFrame) then
            IRTAward.AwardLootFrame:Hide();
            IRTAward:Clear();
            IRTAward.hasSelectedLoot = false;
            IRTAward.lastRow = nil;
            IRTAward.LootTable:ClearSelection();
        end
        IRTAward.openNormally = false;
    end
end)