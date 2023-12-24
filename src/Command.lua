---@type IRT
local _, IRT = ...;

---@class Command
IRT.Command = IRT.Command or {
    CommandDisc = {
        award = "Opens a award menu to start rolling on items, set timers, and discriptions, and to see who is top roll.",
        awardhistory = "Open a menu to show the award history of each raid.",
        softreserve = "Opens a soft reserve menu to import from softres.it.",
        buffs = "Check to see who has their buffs.",
        setbuffs = "Set the buffs that are required for the raid.",
        dkp = "Opens a DKP menu that shows all the tools for the run.",
        export = "Export the current DKP for the players in the raid as a CSV.",
        import = "Import a DKP list from a CSV.",
        settings = "Open the settings menu of the addon.",
        setdisenchanter = "Set a player to be the primary disenchanter.",
        cleardisenchanter = "Clear the primary disenchanter.",
        version = "Get the addons current version.",
    },

    Shorthand = {
        -- Awards
        award = "aw",
        awardhistory = "awh",

        -- Soft Reserve
        softreserve = "sr",

        -- Raid Buffs
        buffs = "bf",
        setbuffs = "sbf",
        
        -- DKP
        dkp = "dkp",
        export = "ex",
        import = "im",

        -- Settings
        settings = "st",

        -- Disenchanter
        setdisenchanter = "sd",
        cleardisenchanter = "cd",

        -- Version
        version = "v",
    },

    Longhand = {
        -- Awards
        award = "award",
        awardhistory = "awardhistory",

        -- Soft Reserve
        softreserve = "softreserve",

        -- Raid Buffs
        buffs = "buffs",
        setbuffs = "setbuffs",
        
        -- DKP
        dkp = "dkp",
        export = "export",
        import = "import",

        -- Settings
        settings = "settings",

        -- Disenchanter
        setdisenchanter = "setdisenchanter",
        cleardisenchanter = "cleardisenchanter",

        -- Version
        version = "version",
    },

    Function_Mapping = {
        dkp = function() IRT.DKPLogger:openMenu(); end,
    }
};

--- Command
local Command = IRT.Command;

--- Call a command and return the result.
---
function Command:call(msg)
    return Command:_sendCommand(msg);
end

--- Send a command to the addon.
---
---@param msg any
---@return void
function Command:_sendCommand(msg)
    local command = string.lower(msg);

    if msg == nil or #msg == 0 then
        print("Setting Menu")
        return;
    end

    if command and msg == self.Shorthand[command] or msg == self.Longhand[command] then
        self.Function_Mapping[command]();
    end
end