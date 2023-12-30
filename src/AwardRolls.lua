---@type IRT
local _, IRT = ...;

IRT.Data.Constants = IRT.Data.Constants or {};

---@class AwardRoll
IRT.AwardRoll = {
    initialized = false,
    currentRollTimer = nil,
    itemBeingBiddedOn = nil,
    highestRoll = 0,
    highestRollerName = nil,
    Rolling = false,
    usingDKP = false,
    startTime = nil,
    endTime = nil,
    timerFrame = nil,
    lastPrintTime = 0,
    capturedRolls = {}
}

---@type AwardRoll
AwardRoll = IRT.AwardRoll;

--- Start the timer for the 
function AwardRoll:StartUpdateEvent()
    self.timerFrame = self.timerFrame or CreateFrame("Frame");
    self.timerFrame:SetScript("OnUpdate", function(self, ...)
        local time = GetTime();
        local timeLeft = math.floor(IRT.AwardRoll.endTime - time);

        if timeLeft <= 0 then
            IRT.AwardRoll:TimeRanOut()
            return;
        end
    
        if timeLeft <= 5  and time - IRT.AwardRoll.lastPrintTime >= 1 then
            IRT.AwardRoll:AnnounceCountdown(timeLeft);
            IRT.AwardRoll.lastPrintTime = time;
        end
    end)
end

local function StopUpdateEvent()
    AwardRoll.timerFrame:SetScript("OnUpdate", nil);
end

function AwardRoll:StartRolling(item, timer)
    if not item or not timer or not tonumber(timer) then return; end
    if self.Rolling then return; end

    -- Set timer
    self.startTime = GetTime();
    self.endTime = self.startTime + tonumber(timer);
    self.Rolling = true;

    -- Send message to chat channel
    SendChatMessage(string.format("%s %s",
        IRT.Data.Constants.defaultRollMessage(item, timer),
        IRT.IRTAward.noteMessageToSend:GetText() or ""),
        IRT.Data.Constants.defaultRollMessageChannel
    );

    self.itemBeingBiddedOn = item;

    -- Send message
    --IRT:SendCommMessage("IRT_AWARDROLL", "START", "RAID");

    -- Start the Timer
    self:StartUpdateEvent();
end

function AwardRoll:StopRolling()
    if not self.Rolling then return; end
    
    self.Rolling = false;
    StopUpdateEvent();

    -- Send message to chat channel
    SendChatMessage(string.format("Bid manually stopped on item %s.",
        AwardRoll.itemBeingBiddedOn),
        IRT.Data.Constants.defaultRollMessageChannel
    );

    self.itemBeingBiddedOn = nil;

    -- Send message
    --IRT:SendCommMessage("IRT_AWARDROLL", "STOP", "RAID");

    -- Reset Award UI
    if(not IRT.IRTAward.isRollTab) then
        IRT.IRTAward.LootTable.frame:Show();
    end
end

function AwardRoll:TimeRanOut()
    if not self.Rolling then return; end

    self.Rolling = false;
    StopUpdateEvent();

    -- Send message to chat channel
    SendChatMessage(IRT.Data.Constants.defaultRollEndBidMessage(self.itemBeingBiddedOn),
        IRT.Data.Constants.defaultRollMessageChannel
    );

    self.itemBeingBiddedOn = nil;

    -- Reset Award UI
    if(not IRT.IRTAward.isRollTab) then
        IRT.IRTAward.LootTable.frame:Show();
    end

    IRT.IRTAward.startBidButton:SetDisabled(false);
    IRT.IRTAward.stopBidButton:SetDisabled(true);
end

function AwardRoll:ResetIRTAwardUI()

end

function AwardRoll:AnnounceCountdown(time)
    if not self.Rolling then return; end

    SendChatMessage(IRT.Data.Constants.defaultRollCountDownMessage(self.itemBeingBiddedOn, time),
        IRT.Data.Constants.defaultRollEndingMessageChannel
    );
end

function AwardRoll:init()
    if (self.initialized) then return end;

    self.initialized = true;
    self.currentRollTimer = IRT.Data.Constants.defaultRollTimer;
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(self, event, arg1, arg2)
    if (event == "CHAT_MSG_SYSTEM") then
        local playerName, rollResults, minRoll, maxRoll = string.match(arg1, "^([^%s]+) rolls (%d+) %((%d+)-(%d+)%)$")

        tinsert(AwardRoll.capturedRolls, {playerName, rollResults, minRoll, maxRoll})

        if playerName and rollResults and minRoll and maxRoll then
            if (tonumber(rollResults) > AwardRoll.highestRoll) then
                IRT.AwardRoll.highestRoll = tonumber(rollResults);
                IRT.AwardRoll.highestRollerName = playerName;
            end
        end
    end
end)