---@type IRT
local _, IRT = ...;

IRT.Interface = {
    initialized = false,
    partyMembers = {},
}
local Interface = IRT.Interface;

---Converts a hex color to RGB.
---@param hex any
---@return integer
---@return integer
---@return integer
function Interface:HexToRGB(hex)
    if (not hex and string.len(hex) < 6) then print("Returning") return 0, 0, 0; end

    hex = hex:gsub("#", "");
    hex = hex:gsub("0x", "");
    hex = hex:gsub("|cff", "");
    local r = tonumber("0x" .. hex:sub(1,2)) / 255
    local g = tonumber("0x" .. hex:sub(3,4)) / 255
    local b = tonumber("0x" .. hex:sub(5,6)) / 255
    return r, g, b
end

---Converts a hex color with a alpha to RGBA.
---@param hex any
---@param a integer
---@return integer
---@return integer
---@return integer
---@return integer
function Interface:HexToRGBA(hex, a)
    if (not hex and hex < 6) then print("Returning") return 0, 0, 0; end

    hex = hex:gsub("#", "");
    hex = hex:gsub("0x", "");
    hex = hex:gsub("|cff", "");
    local r = tonumber("0x" .. hex:sub(1,2)) / 255
    local g = tonumber("0x" .. hex:sub(3,4)) / 255
    local b = tonumber("0x" .. hex:sub(5,6)) / 255
    return r, g, b, a
end

function Interface:UpdatePartyMembers()
    local partyMembers = {};
    for i = 1, GetNumGroupMembers() do
        local player = select(1, GetRaidRosterInfo(i));
        tinsert(partyMembers, player);
    end
    self.partyMembers = partyMembers;
end

function Interface:init()
    if self.initialized then return; end

    self.initialized = true;

    -- Get Party Members
    Interface:UpdatePartyMembers();
end

-- On Party
OnPartyChange = CreateFrame("Frame");
OnPartyChange:RegisterEvent("GROUP_ROSTER_UPDATE");
OnPartyChange:RegisterEvent("GROUP_JOINED");
OnPartyChange:RegisterEvent("GROUP_LEFT");
OnPartyChange:RegisterEvent("PLAYER_ENTERING_WORLD");
OnPartyChange:SetScript("OnEvent", function()
    if (IsInRaid() or IsInGroup()) then
        Interface:UpdatePartyMembers();
    else
        Interface.partyMembers = {{select(1, UnitName("player"))}};
    end
end)