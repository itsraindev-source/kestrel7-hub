return function(Util, Config)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local QUESTS = {
        [1]    = {mob = "Bandit",          npc = "Sword Dealer",   sea = 1},
        [10]   = {mob = "Monkey",          npc = "Sword Dealer",   sea = 1},
        [30]   = {mob = "Gorilla",         npc = "Sword Dealer",   sea = 1},
        [60]   = {mob = "Pirate",          npc = "Sword Dealer",   sea = 1},
        [90]   = {mob = "Brute",           npc = "Sword Dealer",   sea = 1},
        [120]  = {mob = "Desert Bandit",   npc = "Sword Dealer",   sea = 1},
        [190]  = {mob = "Desert Officer",  npc = "Sword Dealer",   sea = 1},
        [300]  = {mob = "Snow Bandit",     npc = "Sword Dealer",   sea = 1},
        [450]  = {mob = "Snowman",         npc = "Sword Dealer",   sea = 1},
        [625]  = {mob = "Frost Bandit",    npc = "Sword Dealer",   sea = 1},
        [875]  = {mob = "Magma Ninja",     npc = "Sword Dealer",   sea = 2},
        [1000] = {mob = "Lava Pirate",     npc = "Sword Dealer",   sea = 2},
        [1250] = {mob = "Ship Deckhand",   npc = "Sword Dealer",   sea = 2},
        [1500] = {mob = "Reborn Skeleton", npc = "Sword Dealer",   sea = 3},
        [2800] = {mob = "Cursed Captain",  npc = "HauntedQuest",   sea = 3},
        [2850] = {mob = "Soul Reaper",     npc = "HauntedQuest",   sea = 3},
        [2900] = {mob = "Void Walker",     npc = "HauntedQuest",   sea = 3},
        [2950] = {mob = "Abyssal Horror",  npc = "HauntedQuest",   sea = 3},
        [3000] = {mob = "Magnetized Titan",npc = "MagnetQuest",    sea = 3},
    }

    local function nearestEnemy()
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        local hrp = char.HumanoidRootPart
        local best, bd = nil, math.huge
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return nil end
        for _, e in ipairs(enemies:GetChildren()) do
            local ehrp = e:FindFirstChild("HumanoidRootPart")
            local ehum = e:FindFirstChildOfClass("Humanoid")
            if ehrp and ehum and ehum.Health > 0 then
                local d = Util.dist(hrp, ehrp)
                if d < bd then best, bd = e, d end
            end
        end
        return best
    end

    task.spawn(function()
        while task.wait(0.1) do
            if not Config.Farm.Enabled then continue end
            local target = nearestEnemy()
            if target then
                if Config.Farm.BringMobs then
                    local thrp = target:FindFirstChild("HumanoidRootPart")
                    if thrp then
                        thrp.CFrame = Util.hrp().CFrame * CFrame.new(0, 0, -3)
                    end
                end
                local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
    end)

    task.spawn(function()
        while task.wait(1) do
            if not Config.Farm.Enabled then continue end
            local lvl = LP.Data and LP.Data.Level and LP.Data.Level.Value or 0
            for req, q in pairs(QUESTS) do
                if lvl >= req and lvl < req + 50 then
                    local remotes = Util.Remotes
                    local questRemote = remotes["CommF_"]
                    if questRemote then
                        pcall(function()
                            questRemote:InvokeServer("StartQuest", q.npc, req)
                        end)
                    end
                    break
                end
            end
        end
    end)
end
