-- Kestrel-7-Hub :: main (Update 30 target)
-- Repo: itsraindev-source/kestrel7-hub

local BASE = "https://raw.githubusercontent.com/itsraindev-source/kestrel7-hub/main/"

local Util = loadstring(game:HttpGet(BASE .. "util.lua"))()
local Config = loadstring(game:HttpGet(BASE .. "config.lua"))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Rayfield GUI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Kestrel-7 Hub | Update 30",
    LoadingTitle = "Archive online",
    LoadingSubtitle = "Sector 7G — Magnet Update",
    ConfigurationSaving = { Enabled = true, FolderName = "K7_U30", FileName = "cfg" },
})

-- ═══ MAGNET TAB ═══
local MagnetTab = Window:CreateTab("Magnet", 4483362458)

MagnetTab:CreateSection("Event Automation")

MagnetTab:CreateToggle({
    Name = "Auto Event Participation",
    CurrentValue = false,
    Flag = "MagnetAutoEvent",
    Callback = function(v) Config.Magnet.AutoEvent = v end,
})

MagnetTab:CreateToggle({
    Name = "Auto Farm Tokens",
    CurrentValue = false,
    Flag = "MagnetAutoFarm",
    Callback = function(v) Config.Magnet.AutoFarmTokens = v end,
})

MagnetTab:CreateToggle({
    Name = "Teleport to Magnet Mobs",
    CurrentValue = true,
    Flag = "MagnetTP",
    Callback = function(v) Config.Magnet.TeleportToEvent = v end,
})

MagnetTab:CreateDropdown({
    Name = "Fast Route",
    Options = {"FirstSea", "SeaOfTreats"},
    CurrentOption = {"FirstSea"},
    Flag = "MagnetRoute",
    Callback = function(o) Config.Magnet.FastRoute = o[1] end,
})

MagnetTab:CreateSection("Gacha")

MagnetTab:CreateToggle({
    Name = "Auto Gacha at Zioles",
    CurrentValue = false,
    Flag = "MagnetAutoGacha",
    Callback = function(v) Config.Magnet.AutoGacha = v end,
})

MagnetTab:CreateSlider({
    Name = "Token Threshold for Roll",
    Range = {500, 5000},
    Increment = 500,
    Suffix = "tokens",
    CurrentValue = 500,
    Flag = "MagnetThreshold",
    Callback = function(v) Config.Magnet.TokenThreshold = v end,
})

MagnetTab:CreateButton({
    Name = "Teleport to Zioles (Middletown)",
    Callback = function()
        Util.tweenTo(Vector3.new(-1000, 100, -5000), 1)
        Util.notify("Magnet", "Teleported to Gacha Dealer")
    end,
})

MagnetTab:CreateSection("Status")

local statusLabel = MagnetTab:CreateLabel("Event: Inactive | Mobs: 0 | Tokens: 0")

-- ═══ FARM TAB ═══
local FarmTab = Window:CreateTab("Farm", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Farm Level (→3000)",
    CurrentValue = false,
    Flag = "FarmEnabled",
    Callback = function(v) Config.Farm.Enabled = v end,
})

FarmTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Flag = "FastAttack",
    Callback = function(v) Config.Farm.FastAttack = v end,
})

FarmTab:CreateToggle({
    Name = "Bring Mobs",
    CurrentValue = true,
    Flag = "BringMobs",
    Callback = function(v) Config.Farm.BringMobs = v end,
})

-- ═══ COMBAT TAB ═══
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Mob Aura",
    CurrentValue = false,
    Flag = "Aura",
    Callback = function(v) Config.Combat.Aura = v end,
})

CombatTab:CreateSlider({
    Name = "Aura Range",
    Range = {5, 100},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 30,
    Flag = "AuraRange",
    Callback = function(v) Config.Combat.AuraRange = v end,
})

CombatTab:CreateToggle({
    Name = "Aim Lock",
    CurrentValue = false,
    Flag = "AimLock",
    Callback = function(v) Config.Combat.AimLock = v end,
})

-- ═══ FRUIT TAB ═══
local FruitTab = Window:CreateTab("Fruit", 4483362458)

FruitTab:CreateToggle({
    Name = "Fruit Sniper",
    CurrentValue = false,
    Flag = "Sniper",
    Callback = function(v) Config.Fruit.Sniper = v end,
})

FruitTab:CreateToggle({
    Name = "Fruit Notifier",
    CurrentValue = true,
    Flag = "FruitNotify",
    Callback = function(v) Config.Fruit.Notify = v end,
})

FruitTab:CreateToggle({
    Name = "Magnet Fruit Alert",
    CurrentValue = true,
    Flag = "MagnetAlert",
    Callback = function(v) Config.Fruit.MagnetAlert = v end,
})

-- ═══ ESP TAB ═══
local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESPPlayers",
    Callback = function(v) Config.ESP.Players = v end,
})

ESPTab:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Flag = "ESPFruits",
    Callback = function(v) Config.ESP.Fruits = v end,
})

ESPTab:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Flag = "ESPChests",
    Callback = function(v) Config.ESP.Chests = v end,
})

ESPTab:CreateToggle({
    Name = "Magnet Mob ESP",
    CurrentValue = false,
    Flag = "ESPMagnet",
    Callback = function(v) Config.ESP.MagnetMobs = v end,
})

ESPTab:CreateToggle({
    Name = "Magnet Scrap ESP",
    CurrentValue = false,
    Flag = "ESPScrap",
    Callback = function(v) Config.ESP.MagnetScrap = v end,
})

-- ═══ RAID TAB ═══
local RaidTab = Window:CreateTab("Raid", 4483362458)

RaidTab:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Flag = "AutoRaid",
    Callback = function(v) Config.Raid.Auto = v end,
})

RaidTab:CreateDropdown({
    Name = "Chip",
    Options = {"Flame","Ice","Quake","Light","Dark","Spider","Rumble","Magma","Buddha","Love","Phoenix","Dough","Magnet"},
    CurrentOption = {"Flame"},
    Flag = "RaidChip",
    Callback = function(o) Config.Raid.Chip = o[1] end,
})

-- ═══ MISC TAB ═══
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(v) Config.Misc.AntiAFK = v end,
})

MiscTab:CreateToggle({
    Name = "Server Hop on Death",
    CurrentValue = false,
    Flag = "HopDeath",
    Callback = function(v) Config.Misc.HopOnDeath = v end,
})

MiscTab:CreateToggle({
    Name = "Auto Stats",
    CurrentValue = false,
    Flag = "AutoStats",
    Callback = function(v) Config.Misc.AutoStats = v end,
})

MiscTab:CreateButton({
    Name = "Redeem Active Codes",
    Callback = function()
        Config.Misc.AutoRedeemCodes = true
        Util.notify("Codes", "Redeeming...")
    end,
})

-- ═══ MODULE DISPATCH ═══
local Magnet = loadstring(game:HttpGet(BASE .. "modules/magnet.lua"))(Util, Config)
local Farm   = loadstring(game:HttpGet(BASE .. "modules/farm.lua"))(Util, Config)
local Combat = loadstring(game:HttpGet(BASE .. "modules/combat.lua"))(Util, Config)
local Fruit  = loadstring(game:HttpGet(BASE .. "modules/fruit.lua"))(Util, Config)
local ESP    = loadstring(game:HttpGet(BASE .. "modules/esp.lua"))(Util, Config)
local Raid   = loadstring(game:HttpGet(BASE .. "modules/raid.lua"))(Util, Config)
local Misc   = loadstring(game:HttpGet(BASE .. "modules/misc.lua"))(Util, Config)

-- ═══ STATUS POLL ═══
task.spawn(function()
    while task.wait(5) do
        local active = Util.isMagnetEvent()
        local mobCount = #Util.findMagnetMobs()
        local tokens = Util.getTokenBalance()
        pcall(function()
            statusLabel:Set(
                "Event: " .. (active and "ACTIVE" or "Inactive")
                .. " | Mobs: " .. mobCount
                .. " | Tokens: " .. tostring(tokens)
            )
        end)
    end
end)

if Config.Misc.AntiAFK then Util.vu() end

Util.notify("Kestrel-7", "Update 30 hub loaded.")
