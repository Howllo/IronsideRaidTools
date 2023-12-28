---@type IRT
local _, IRT = ...;

IRT.Data.Constants = IRT.Data.Constants or {};

---@class AwardRoll
IRT.AwardRoll = {
    initialized = false,
    currentRollTimer = nil,
    itemBeingBiddedOn = nil,
    highestRoll = 0,
    highestRoller = nil,
    highestRollerName = nil,
    Rolling = false;
    usingDKP = false;
}

---@type AwardRoll
AwardRoll = IRT.AwardRoll;

function AwardRoll:StartRolling(item)
    if not item then return; end
    if self.Rolling then return; end

    -- Send message to chat channel
    SendChatMessage(string.format("%s s%",
        IRT.Data.Constants.defaultRollNoteMessage(),
        IRT.Award.noteMessageToSend),
        IRT.Data.Constants.defaultRollMessageChannel()
    );

    self.Rolling = true;
    self.RollingItem = item;

    -- Send message
    --IRT:SendCommMessage("IRT_AWARDROLL", "START", "RAID");
end

function AwardRoll:CaptureRolls()

end

function AwardRoll:StopRolling()
    if not self.Rolling then return; end

    self.Rolling = false;
    self.RollingItem = nil;

    -- Send message
    IRT:SendCommMessage("IRT_AWARDROLL", "STOP", "RAID");

    -- Stop rolling
    self:StopRollingFrame();
end

--- Set the total bid timer.
function AwardRoll:SetTimer(timer)
    if not timer then return; end
    self.currentRollTimer = timer;
end

function AwardRoll:init()
    if (self.initialized) then return end;

    self.initialized = true;
    self.currentRollTimer = IRT.Data.Constants.defaultRollTimer;
end