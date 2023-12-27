---@type IRT
local _, IRT = ...;

IRT.Interface = IRT.Interface or {};
local Interface = IRT.Interface;

function Interface:HexToRGB(hex)
    if (not hex) then return 0, 0, 0; end

    hex = hex:gsub("#", "");
    hex = hex:gsub("0x", "");
    hex = hexgsub("|cff", "");
    print(hex)
    return tonumber("0x"..hex:sub(1, 2)) / 255, tonumber("0x"..hex:sub(3, 4)) / 255, tonumber("0x"..hex:sub(5, 6)) / 255;
end