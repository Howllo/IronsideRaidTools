---@type IRT
local _, IRT = ...;

IRT.AwardRolling = IRT.AwardRolling or {};

-- Shorting the name
AwardRolling = IRT.AwardRolling;

-- Variables
IRT.AwardRolling.Rolling = false;
IRT.AwardRolling.RollingItem = nil;

function IRT.AwardRolling:StartRolling(item)
    if not item then return; end
    if self.Rolling then return; end

    self.Rolling = true;
    self.RollingItem = item;

    -- Send message
    IRT:SendCommMessage("IRT_AWARDROLL", "START", "RAID");

    -- Start rolling
    self:StartRollingFrame();
end

function IRT.AwardRolling:StopRolling()
    if not self.Rolling then return; end

    self.Rolling = false;
    self.RollingItem = nil;

    -- Send message
    IRT:SendCommMessage("IRT_AWARDROLL", "STOP", "RAID");

    -- Stop rolling
    self:StopRollingFrame();
end