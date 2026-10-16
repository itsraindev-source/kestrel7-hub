return function(Util, Config)
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local lastQuestAttempt = 0

    -- Quest NPC table: level bracket -> NPC name (Third Sea routing for 1500+)
    local QUESTS = {
        {min = 1,    max = 9,    npc = "Sword Dealer",    island = "Starter Island"},
        {min = 10,   max = 29,   npc = "Sword Dealer",    island = "Starter Island"},
        {min = 30,   max = 59,   npc = "Sword Dealer",    island = "Jungle"},
        {min = 60,   max = 89,   npc = "Sword Dealer",    island = "Jungle"},
        {min = 90,   max = 119,  npc = "Sword Dealer",    island = "Pirate Village"},
        {min = 120,  max = 189,  npc = "Sword Dealer",    island = "Desert"},
        {min = 190,  max = 299,  npc = "Sword Dealer",    island = "Desert"},
        {min = 300,  max = 449,  npc = "Sword Dealer",    island = "Frozen Village"},
        {min = 450,  max = 624,  npc = "Sword Dealer",    island = "Frozen Village"},
        {min = 625,  max = 874,  npc = "Sword Dealer",    island = "Marine Fortress"},
        {min = 875,  max = 999,  npc = "Sword Dealer",    island = "Skylands"},
        {min = 1000, max = 1249, npc = "Sword Dealer",    island = "Kingdom of Rose"},
        {min = 1250, max = 1499, npc = "Sword Dealer",    island = "Cursed Ship"},
        {min = 1500, max = 1749, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 1750, max = 1899, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 1900, max = 2099, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 2100, max = 2299, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 2300, max = 2499, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 2500, max = 2699, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 2700, max = 2849, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 2850, max = 2999, npc = "Guest Giver",     island = "Haunted Castle"},
        {min = 3000, max = 9999, npc = "Guest Giver",     island = "Haunted Castle"},
    }

    local function currentQuest()
        local lvl = Util.getLevel()
        for _, q in ipairs(QUESTS) do
            if lvl >= q.min and lvl <= q.max then return q end
        end
        return QUESTS[#QUESTS]
    end

    local function nearestEnemy()
        local char = LP.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local list = Util.getAllEnemies()
        if #list == 0 then return nil end

        local best, bd = nil, math.huge
        for _, e in ipairs(list) do
            local ehrp = e:FindFirstChild("HumanoidRootPart")
            if ehrp then
                local d = Util.dist(hrp, ehrp)
                if d < bd then best, bd = e, d end
            end
        end
        return best
    end

    -- Auto-quest: re-invoke quest remote every 3 seconds
    task.spawn(function()
        while task.wait(3) do
            if not Config.Farm.Enabled then continue end
            local q = currentQuest()
            local now = tick()
            if now - lastQuestAttempt < 3 then continue end
            lastQuestAttempt = now
            local ok = Util.startQuest(q.npc, Util.getLevel())
            if ok then
                print("[K7-Farm] Quest attempted:", q.npc, "lvl", Util.getLevel())
            end
        end
    end)

    -- Main farm loop
    task.spawn(function()
        while task.wait(0.15) do
            if not Config.Farm.Enabled then continue end

            local char = LP.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            local target = nearestEnemy()
            if target then
                if Config.Farm.BringMobs then
                    local thrp = target:FindFirstChild("HumanoidRootPart")
                    if thrp then
                        pcall(function()
                            thrp.CFrame = Util.hrp().CFrame * CFrame.new(0, 0, -3)
                        end)
                    end
                end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function() tool:Activate() end)
                end
            end
        end
    end)

    -- Diagnostic: print enemy count every 3s when farming
    task.spawn(function()
        while task.wait(3) do
            if not Config.Farm.Enabled then continue end
            print("[K7-Farm] Enabled | Enemies in container:", #Util.getAllEnemies(),
                  "| Level:", Util.getLevel())
        end
    end)
end
