---@type IRT
local _, IRT = ...;

---@class Comamands
IRT.Commands = IRT.Commands or {
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
        dkp = "dk",
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
};

--- Call a command and return the result.
---
function Commands:call(msg)
    return Commands:callCommand(msg);
end

function Commands:_sendCommand(msg)
    IRT.Ace:Print(msg);
end