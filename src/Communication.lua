---@type IRT
local _, IRT = ...;

---@class Communication
IRT.Communication ={
    channel = "",
    init = false,
}

function IRT.Communication:init()
    if self.init then return; end
    self.init = true;

    
end