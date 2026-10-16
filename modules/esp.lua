return function(Util, Config)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local function makeBox(adornee, color, name)
        local box = Instance.new("BoxHandleAdornment")
        box.Size = adornee.Size
        box.Adornee = adornee
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Transparency = 0.4
        box.Color3 = color
        box.Name = name or "K7ESP"
        box.Parent = adornee
        return box
    end

    -- Player ESP
    task.spawn(function()
        while task.wait(0.5) do
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if Config.ESP.Players and not hrp:FindFirstChild("K7ESP") then
                            makeBox(hrp, Color3.fromRGB(255, 60, 60), "K7ESP")
                        elseif not Config.ESP.Players and hrp:FindFirstChild("K7ESP") then
                            hrp.K7ESP:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- Magnet Mob ESP (Update 30)
    task.spawn(function()
        while task.wait(0.5) do
            local enemies = workspace:FindFirstChild("Enemies")
            if not enemies then continue end
            for _, m in ipairs(enemies:GetChildren()) do
                local hrp = m:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local isMagnet = m.Name:find("Magnetized") or m.Name:find("Overcharged")
                    if Config.ESP.MagnetMobs and isMagnet and not hrp:FindFirstChild("K7MagnetESP") then
                        makeBox(hrp, Color3.fromRGB(0, 200, 255), "K7MagnetESP")
                    elseif not Config.ESP.MagnetMobs and hrp:FindFirstChild("K7MagnetESP") then
                        hrp.K7MagnetESP:Destroy()
                    end
                end
            end
        end
    end)

    -- Fruit ESP (includes Magnet Fruit highlight)
    task.spawn(function()
        while task.wait(1) do
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                    local name = obj.Name
                    if name:find("Fruit") or name:find("Magnet") then
                        local handle = obj.Handle
                        if Config.ESP.Fruits and not handle:FindFirstChild("K7ESP") then
                            local color = name:find("Magnet")
                                and Color3.fromRGB(0, 255, 200)
                                or Color3.fromRGB(60, 255, 60)
                            makeBox(handle, color, "K7ESP")
                        elseif not Config.ESP.Fruits and handle:FindFirstChild("K7ESP") then
                            handle.K7ESP:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- Chest ESP
    task.spawn(function()
        while task.wait(1) do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:find("Chest") then
                    local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        if Config.ESP.Chests and not primary:FindFirstChild("K7ESP") then
                            makeBox(primary, Color3.fromRGB(255, 220, 60), "K7ESP")
                        elseif not Config.ESP.Chests and primary:FindFirstChild("K7ESP") then
                            primary.K7ESP:Destroy()
                        end
                    end
                end
            end
        end
    end)

    -- Magnet Scrap ESP
    task.spawn(function()
        while task.wait(0.5) do
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name:find("Scrap") then
                    if Config.ESP.MagnetScrap and not obj:FindFirstChild("K7ScrapESP") then
                        makeBox(obj, Color3.fromRGB(180, 0, 255), "K7ScrapESP")
                    elseif not Config.ESP.MagnetScrap and obj:FindFirstChild("K7ScrapESP") then
                        obj.K7ScrapESP:Destroy()
                    end
                end
            end
        end
    end)
end
