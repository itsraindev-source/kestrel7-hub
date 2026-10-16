return function(Util, Config)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local seen = {}

    local function isFruit(obj)
        if not obj:IsA("Tool") then return false end
        if not obj:FindFirstChild("Handle") then return false end
        local n = obj.Name
        if n:find("Fruit") then return true end
        if n == "Magnet" or n:find("Magnet") then return true end
        return false
    end

    task.spawn(function()
        while task.wait(1) do
            if not Config.Fruit.Sniper and not Config.Fruit.Notify then continue end

            for _, obj in ipairs(workspace:GetChildren()) do
                if isFruit(obj) then
                    if not seen[obj] then
                        seen[obj] = true
                        local n = obj.Name

                        if Config.Fruit.Notify then
                            Util.notify("Fruit", n .. " spawned")
                        end

                        if Config.Fruit.MagnetAlert and n:find("Magnet") then
                            Util.notify("MAGNET", "Magnet Fruit on ground")
                        end

                        if Config.Fruit.Sniper then
                            local handle = obj:FindFirstChild("Handle")
                            if handle then
                                Util.tweenTo(handle.Position + Vector3.new(0, 3, 0), 0.5)
                                task.wait(0.3)
                                pcall(function()
                                    firetouchinterest(Util.hrp(), handle, 0)
                                    firetouchinterest(Util.hrp(), handle, 1)
                                end)
                            end
                        end
                    end
                end
            end

            -- Clean seen table of destroyed instances
            for obj in pairs(seen) do
                if typeof(obj) == "Instance" and not obj.Parent then
                    seen[obj] = nil
                end
            end
        end
    end)

    -- Dealer watcher: detects Magnet Fruit restock at Blox Fruit Dealer
    task.spawn(function()
        while task.wait(5) do
            if not Config.Fruit.Notify then continue end
            local dealerStock = workspace:FindFirstChild("FruitDealerStock")
            if not dealerStock then continue end
            for _, item in ipairs(dealerStock:GetChildren()) do
                if item.Name:find("Magnet") then
                    Util.notify("Dealer", "Magnet Fruit in dealer stock")
                end
            end
        end
    end)
end
