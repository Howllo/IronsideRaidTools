---@type IRT
local _, IRT = ...;

IRT.Settings = {};

function IRT.Settings:get(str)
    return IRT.Data.DefaultState[str];
end

function IRT.Settings:set(str, val)
    IRT.Data.DefaultState[str] = val;
end