return function(Util, Config)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local lastEventState = false

    task.spawn(function()
        while task.wait(2) do
            local isActive = Util.isMagnetEvent()

            if isActive and not lastEventState and Config.Magnet.AutoEvent then
                Util.notify("Magnet Event", "Event started. Farming tokens.")
            end
            lastEventState = isActive

            if isActive and Config.Magnet.AutoFarmTokens then
                local mobs = Util.findMagnetMobs()
                if #mobs > 0 and Config.Magnet.TeleportToEvent then
                    local target = mobs[1]
                    local hrp = target:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        Util.tweenTo(hrp.Position + Vector3.new(0, 5, 0), 0.15)
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(5) do
            if not Config.Magnet.AutoGacha then continue end

            local balance = Util.getTokenBalance()
            if balance >= Config.Magnet.TokenThreshold then
                Util.tweenTo(Vector3.new(-1000, 100, -5000), 1)
                task.wait(1)
                local remotes = Util.Remotes
                local gachaRemote = remotes["MagnetGacha"] or remotes["ZiolesGacha"]
                if gachaRemote then
                    pcall(function()
                        gachaRemote:InvokeServer("Roll", "Magnet")
                    end)
                    Util.notify("Magnet Gacha", "Rolled. Balance was: " .. balance)
                end
            end
        end
    end)

    local FIRST_SEA_ROUTE = {
        Vector3.new(0, 100, 0),
        Vector3.new(-1500, 100, 500),
        Vector3.new(-2500, 100, 0),
        Vector3.new(1000, 100, 2000),
        Vector3.new(-3000, 100, -3000),
        Vector3.new(5000, 100, 5000),
    }

    local SEA_TREATS_ROUTE = {
        Vector3.new(0, 100, 0),
    }

    task.spawn(function()
        while task.wait(0.5) do
            if not Config.Magnet.AutoFarmTokens then continue end
            if not Util.isMagnetEvent() then continue end

            local route = Config.Magnet.FastRoute == "FirstSea" and FIRST_SEA_ROUTE or SEA_TREATS_ROUTE
            local mobs = Util.findMagnetMobs()

            if #mobs > 0 then
                local hrp = Util.hrp()
                local best, bd = nil, math.huge
                for _, m in ipairs(mobs) do
                    local mhrp = m:FindFirstChild("HumanoidRootPart")
                    if mhrp then
                        local d = Util.dist(hrp, mhrp)
                        if d < bd then best, bd = m, d end
                    end
                end
                if best then
                    local bhrp = best:FindFirstChild("HumanoidRootPart")
                    if bhrp then Util.tweenTo(bhrp.Position + Vector3.new(0, 4, 0), 0.1) end
                end
            else
                for _, pos in ipairs(route) do
                    if not Config.Magnet.AutoFarmTokens then break end
                    Util.tweenTo(pos + Vector3.new(0, 20, 0), 0.3)
                    task.wait(1)
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.5) do
            if not Util.hasMagnetFruit() then continue end
            local char = LP.Character
            if char then
                local scrapCount = 0
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name:find("Scrap") and obj:IsA("BasePart") then
                        local d = Util.dist(Util.hrp(), obj)
                        if d < 50 then scrapCount = scrapCount + 1 end
                    end
                end
            end
        end
    end)
end
