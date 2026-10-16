return function(Util, Config)
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local LP = Players.LocalPlayer

    -- Hop on death
    local function attachDeath(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        hum.Died:Connect(function()
            if not Config.Misc.HopOnDeath then return end
            local ok, servers = pcall(function()
                return HttpService:JSONDecode(
                    game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
                )
            end)
            if not ok or not servers or not servers.data then return end
            for _, s in ipairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LP)
                    end)
                    break
                end
            end
        end)
    end

    if LP.Character then attachDeath(LP.Character) end
    LP.CharacterAdded:Connect(attachDeath)

    -- Auto stats allocation
    task.spawn(function()
        while task.wait(5) do
            if not Config.Misc.AutoStats then continue end
            local remotes = Util.Remotes
            local statRemote = remotes["CommF_"] or remotes["StatsSystem"]
            if not statRemote then continue end

            local data = LP:FindFirstChild("Data")
            local points = 0
            if data then
                local sp = data:FindFirstChild("StatPoint")
                if sp then points = sp.Value end
            end
            if points > 0 then
                local stat = Config.Farm.Method == "Melee" and "Melee" or "Defense"
                pcall(function()
                    statRemote:InvokeServer("AddPoint", stat, points)
                end)
            end
        end
    end)

    -- Auto redeem codes (Update 30 active codes)
    local CODES = {
        "MAGNETUPDATE",
        "UPDATE30",
        "KITSUNERELEASE",
    }

    task.spawn(function()
        while task.wait(0.5) do
            if not Config.Misc.AutoRedeemCodes then continue end
            local remotes = Util.Remotes
            local codeRemote = remotes["RedeemCode"]
                or remotes["CommF_"]
                or remotes["CodesSystem"]
            if not codeRemote then continue end
            for _, code in ipairs(CODES) do
                pcall(function()
                    codeRemote:InvokeServer("Redeem", code)
                end)
                task.wait(0.5)
            end
            Config.Misc.AutoRedeemCodes = false
        end
    end)
end
