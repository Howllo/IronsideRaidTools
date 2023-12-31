---@type IRT
local _, IRT = ...;

---@class Data
IRT.Data = IRT.Data or {}
IRT.Data.Constants = IRT.Data.Constants or {}

---@class Constants
IRT.Data.Constants = {
    Item_Slot = {
        INVTYPE_AMMO = { 0 },
        INVTYPE_HEAD = { 1 },
        INVTYPE_NECK = { 2 },
        INVTYPE_SHOULDER = { 3 },
        INVTYPE_BODY = { 4 },
        INVTYPE_CHEST = { 5 },
        INVTYPE_ROBE = { 5 },
        INVTYPE_WAIST = { 6 },
        INVTYPE_LEGS = { 7 },
        INVTYPE_FEET = { 8 },
        INVTYPE_WRIST = { 9 },
        INVTYPE_HAND = { 10 },
        INVTYPE_FINGER = { 11, 12 },
        INVTYPE_TRINKET = { 13, 14 },
        INVTYPE_CLOAK = { 15 },
        INVTYPE_WEAPON = { 16, 17 },
        INVTYPE_SHIELD = { 17 },
        INVTYPE_2HWEAPON = { 16 },
        INVTYPE_WEAPONMAINHAND = { 16 },
        INVTYPE_WEAPONOFFHAND = { 17 },
        INVTYPE_HOLDABLE = { 17 },
        INVTYPE_RANGED = { 16 },
        INVTYPE_THROWN = { 16 },
        INVTYPE_RANGEDRIGHT = { 16 },
        INVTYPE_RELIC = { 16 },
        INVTYPE_TABARD = { 19 },
        INVTYPE_BAG = { 20, 21, 22, 23 },
        INVTYPE_QUIVER = { 20, 21, 22, 23 }
    },

    --[[
        Also used for loot threshold.
    ]]
    Item_Quality = {
        [0] = {
            name = "Poor",
            color = "|cff9d9d9d"
        },
        [1] = {
            name = "Common",
            color = "|cffffffff"
        },
        [2] = {
            name = "Uncommon",
            color = "|cff1eff00"
        },
        [3] = {
            name = "Rare",
            color = "|cff0070dd"
        },
        [4] = {
            name = "Epic",
            color = "|cffa335ee"
        },
        [5] = {
            name = "Legendary",
            color = "|cffff8000"
        },
        [6] = {
            name = "Artifact",
            color = "|cffe6cc80"
        },
        [7] = {
            name = "Heirloom",
            color = "|cff00ccff"
        },
        [8] = {
            name = "WoW Token",
            color = "|cffffd100"
        }
    },

    AddonName = "Ironside",

    GroupLootAction = {
        PASS = 0,
        NEED = 1,
        GREED = 2,
    },

    Classes = {
        WARRIOR = 1,
        PALADIN = 2,
        HUNTER = 3,
        ROGUE = 4,
        PRIEST = 5,
        SHAMAN = 7,
        MAGE = 8,
        WARLOCK = 9,
    },

    mainThemeColor = "00CCFF",
    disableTextColor = "5F5F5F",

    --[[
        Used for the roll message.
    ]]
    defaultRollTimer = 30,
    defaultRollMessageChannel = "RAID_WARNING",
    defaultRollEndingMessageChannel = "RAID",
    defaultRollType = "roll", -- Yeah this is not a constant, but it easier to track here. TODO: Change this to DB.
    defaultRollRoll = "roll",
    defaultRollBid = "bid",
    defaultPreMessage = "{star} Ironside:",

    defaultRollEndBidMessage = function(itemLink) 
        return  string.format("%s %s on %s has ended.",
                IRT.Data.Constants.defaultPreMessage,
                IRT.Data.Constants.defaultRollType,
                itemLink)
     end,

    defaultRollCountDownMessage = function(itemLink, time)
        return  string.format("%s %s on %s will end in %s seconds.", 
                IRT.Data.Constants.defaultPreMessage,
                IRT.Data.Constants.defaultRollType,
                itemLink,
                tostring(time))
     end,

    defaultRollMessage = function(itemLink, time)
        return string.format("%s Starting %s on %s. You have %s seconds to bid.",
        IRT.Data.Constants.defaultPreMessage,
        IRT.Data.Constants.defaultRollType, itemLink,
        time)
    end,

    defaultRollNoteMessage = "/roll 100 for MS, 99 for OS.",
};