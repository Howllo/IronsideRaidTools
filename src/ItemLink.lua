---@type IRT
local _, IRT = ...;
IRT.ItemLink = {};

---@param itemID number
---
---@return string
function IRT.ItemLink:getItemLinkFromItemID(itemID)
    return select(2, GetItemInfo(itemID));
end

---@param itemLink string
---
---@return number
function IRT.ItemLink.getItemIDFromItemLink(itemLink)
    local itemID = nil;
    if itemLink then
        itemID = tonumber(string.match(itemLink, "item:(%d+)"));
    end
    return itemID or 0;
end