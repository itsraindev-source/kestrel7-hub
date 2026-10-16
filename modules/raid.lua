return function(Util, Config)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local CHIP_MAP = {
        Flame   = "Flame",
        Ice     = "Ice",
        Quake   = "Quake",
        Light   = "Light",
        Dark    = "Dark",
        Spider  = "Spider",
        Rumble  = "Rumble",
        Magma   = "Magma",
        Buddha  = "Buddha",
        Love    = "Love",
        Phoenix = "Phoenix",
        Dough   = "Dough",
        Magnet  = "Magnet",
    }

    local function startRaid()
        local remotes = Util.Remotes
        local raidRemote = remotes["RaidSystem"]
            or remotes["CommF_"]
            or remotes["RaidKick"]
        if not raidRemote then return false end

        local chip = CHIP_MAP[Config.Raid.Chip] or "Flame"
        local ok = pcall(function()
            raidRemote:InvokeServer("Raids", chip)
        end)
        return ok
    end

    local function inRaid()
        local rs = workspace:FindFirstChild("Raid")
        if rs then return true end
        local island = workspace:FindFirstChild("RaidIsland")
        if island then return true end
        return false
    end

    -- Auto-start raid loop
    task.spawn(function()
        while task.wait(3) do
            if not Config.Raid.Auto then continue end
            if inRaid() then continue end
            local ok = startRaid()
            if ok then
                Util.notify("Raid", "Started: " .. Config.Raid.Chip)
                task.wait(5)
            end
        end
    end)

    -- In-raid auto clear: collect chips, activate next wave
    task.spawn(function()
        while task.wait(2) do
            if not Config.Raid.Auto then continue end
            if not inRaid() then continue end

            local remotes = Util.Remotes
            local raidRemote = remotes["RaidSystem"] or remotes["CommF_"]

            if raidRemote then
                pcall(function()
                    raidRemote:InvokeServer("Raid", "NextWave")
                end)
            end

            -- Auto pickup dropped chips
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Tool") and obj.Name:find("Chip") then
                    local handle = obj:FindFirstChild("Handle")
                    if handle then
                        Util.tweenTo(handle.Position + Vector3.new(0, 3, 0), 0.3)
                        task.wait(0.2)
                        pcall(function()
                            firetouchinterest(Util.hrp(), handle, 0)
                            firetouchinterest(Util.hrp(), handle, 1)
                        end)
                    end
                end
            end
        end
    end)
end
