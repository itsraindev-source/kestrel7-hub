return function(Util, Config)
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local VirtualUser = game:GetService("VirtualUser")

    -- Mob Aura: swing at nearest enemy in range
    RunService.Heartbeat:Connect(function()
        if not Config.Combat.Aura then return end
        local char = LP.Character
        if not char or not char:FindFirstChildOfClass("Humanoid") then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return end

        local nearest, nearestDist = nil, Config.Combat.AuraRange
        for _, m in ipairs(enemies:GetChildren()) do
            local mhrp = m:FindFirstChild("HumanoidRootPart")
            local mhum = m:FindFirstChildOfClass("Humanoid")
            if mhrp and mhum and mhum.Health > 0 then
                local d = Util.dist(hrp, mhrp)
                if d < nearestDist then
                    nearest, nearestDist = m, d
                end
            end
        end

        if nearest then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            else
                VirtualUser:Button1Down(Vector2.new(0, 0))
            end
        end
    end)

    -- Fast Attack: spam tool activate at high frequency
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

    -- Aim Lock: point camera at nearest player
    RunService.RenderStepped:Connect(function()
        if not Config.Combat.AimLock then return end
        local cam = workspace.CurrentCamera
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

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

    -- Magnet Fruit stage tracker (heuristic)
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
