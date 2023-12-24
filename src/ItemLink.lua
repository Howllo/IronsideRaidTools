---@type IRT
local _, IRT = ...;
IRT.ItemLink = {};

---@param itemID number
---@param chat string
---
---@return string
function IRT.ItemLink:createItem(itemID, chat)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        itemEquipLoc, itemIcon, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID,
        isCraftingReagent = GetItemInfo(itemID);
    local _itemLink = nil;

    if itemName then
        _itemLink = string.format("%s|Hitem:%d:0:0:0:0:0:0:0:0|h[%s]|h|r",
            IRT.Data.Constants.Item_Quality[itemRarity].color,
            itemID,
            itemName
        );
    else
        print("Item information not available.");
    end

    return itemLink;
end

---@param itemLink string
---
---@return number
function IRT.ItemLink.getItemIDFromItemLink(itemLink)
    local itemID = nil;
    if itemLink then
        itemID = tonumber(string.match(itemLink, "item:(%d+)"));
    end
    return itemID;
end