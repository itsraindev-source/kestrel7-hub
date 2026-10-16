local Config = {
    Farm = {
        Enabled = false,
        Quest = "Auto",
        Method = "Melee",
        FastAttack = true,
        BringMobs = true,
        MaxLevel = 3000,
    },
    Magnet = {
        AutoEvent = false,
        AutoFarmTokens = false,
        AutoGacha = false,
        FastRoute = "FirstSea",
        TeleportToEvent = true,
        TokenThreshold = 500,
    },
    Combat = {
        Aura = false,
        AuraRange = 30,
        AimLock = false,
        MagnetStage = 1,
    },
    Fruit = {
        Sniper = false,
        Notify = true,
        MagnetAlert = true,
    },
    ESP = {
        Players = false,
        Fruits = false,
        Chests = false,
        MagnetMobs = false,
        MagnetScrap = false,
    },
    Raid = {
        Auto = false,
        Chip = "Flame",
    },
    Misc = {
        AntiAFK = true,
        HopOnDeath = false,
        AutoStats = false,
        AutoRedeemCodes = false,
    },
}

return Config
