return function(Util, Config)
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    -- Mob Aura
    RunService.Heartbeat:Connect(function()
        if not Config.Combat.Aura then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local list = Util.getAllEnemies()
        local nearest, nearestDist = nil, Config.Combat.AuraRange
        for _, m in ipairs(list) do
            local mhrp = m:FindFirstChild("HumanoidRootPart")
            if mhrp then
                local d = Util.dist(hrp, mhrp)
                if d < nearestDist then
                    nearest, nearestDist = m, d
                end
            end
        end

        if nearest then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end
    end)

    -- Fast Attack: independent from Aura
    task.spawn(function()
        while task.wait(0.08) do
            if not Config.Farm.FastAttack then continue end
            if not Config.Farm.Enabled and not Config.Combat.Aura then continue end
            local char = LP.Character
            if not char then continue end
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end
    end)

    -- Aim Lock
    RunService.RenderStepped:Connect(function()
        if not Config.Combat.AimLock then return end
        local cam = workspace.CurrentCamera
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local nearest, nearestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local phrp = p.Character:FindFirstChild("HumanoidRootPart")
                local phum = p.Character:FindFirstChildOfClass("Humanoid")
                if phrp and phum and phum.Health > 0 then
                    local d = Util.dist(hrp, phrp)
                    if d < nearestDist then
                        nearest, nearestDist = p, d
                    end
                end
            end
        end
        if nearest then
            local phrp = nearest.Character.HumanoidRootPart
            cam.CFrame = CFrame.new(cam.CFrame.Position, phrp.Position)
        end
    end)

    -- Magnet fruit stage tracker
    task.spawn(function()
        while task.wait(1) do
            if not Util.hasMagnetFruit() then continue end
            local char = LP.Character
            if not char then continue end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end
            local scrapCount = 0
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name:find("Scrap") then
                    if Util.dist(hrp, obj) < 80 then
                        scrapCount = scrapCount + 1
                    end
                end
            end
            if scrapCount >= 16 then
                Config.Combat.MagnetStage = 3
            elseif scrapCount >= 6 then
                Config.Combat.MagnetStage = 2
            else
                Config.Combat.MagnetStage = 1
            end
        end
    end)
end
