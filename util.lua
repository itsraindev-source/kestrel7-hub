local Util = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer

local NPC_NAMES = {
    ["Set Home Point"] = true,
    ["Guest Giver"] = true,
    ["Haunted Castle Guest Giver"] = true,
    ["Sword Dealer"] = true,
    ["Blox Fruit Dealer"] = true,
    ["Weapon Dealer"] = true,
    ["Fighting Style Dealer"] = true,
    ["Ability Teacher"] = true,
    ["Blacksmith"] = true,
    ["Barber"] = true,
    ["Awakened Ice Admiral"] = true,
    ["Legendary Sword Dealer"] = true,
}

function Util.isNPC(model)
    if not model or not model.Name then return true end
    if NPC_NAMES[model.Name] then return true end
    local n = model.Name
    if n:find("Dealer") or n:find("Shop") or n:find("Quest")
       or n:find("Giver") or n:find("Point") or n:find("Blacksmith")
       or n:find("Barber") or n:find("Teacher") or n:find("Master") then
        return true
    end
    if Players:GetPlayerFromCharacter(model) then return true end
    return false
end

function Util.getRemotes()
    local r = {}
    local rs = ReplicatedStorage:FindFirstChild("Remotes")
    if rs then
        for _, v in ipairs(rs:GetChildren()) do
            r[v.Name] = v
        end
    end
    local net = ReplicatedStorage:FindFirstChild("Net")
    if net then
        for _, v in ipairs(net:GetChildren()) do
            r[v.Name] = v
        end
    end
    return r
end

Util.Remotes = Util.getRemotes()

-- Universal remote fetch from gc
function Util.fetchRemote(name)
    if Util.Remotes[name] then return Util.Remotes[name] end
    for _, v in pairs(getgc(true)) do
        if type(v) == "table" then
            for k, remote in pairs(v) do
                if type(k) == "string" and k == name
                   and typeof(remote) == "Instance"
                   and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                    Util.Remotes[name] = remote
                    return remote
                end
            end
        end
    end
    return nil
end

function Util.vu()
    LP.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

function Util.char()
    return LP.Character or LP.CharacterAdded:Wait()
end

function Util.hrp()
    return Util.char():WaitForChild("HumanoidRootPart")
end

function Util.hum()
    return Util.char():WaitForChild("Humanoid")
end

function Util.dist(a, b)
    return (a.Position - b.Position).Magnitude
end

function Util.tweenTo(pos, speed)
    local hrp = Util.hrp()
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bp.Position = pos
    bp.Parent = hrp
    task.wait(speed or 0.1)
    if bp and bp.Parent then bp:Destroy() end
end

function Util.notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 4,
        })
    end)
end

function Util.isMagnetEvent()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        for _, child in ipairs(sky:GetChildren()) do
            if child.Name:find("Magnet") then return true end
        end
    end
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, m in ipairs(enemies:GetChildren()) do
            if m.Name:find("Magnetized") or m.Name:find("Overcharged") then
                return true
            end
        end
    end
    return false
end

-- PRIMARY enemy fetcher. Targets workspace.Enemies.
function Util.getAllEnemies()
    local list = {}
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return list end
    for _, m in ipairs(enemies:GetChildren()) do
        local hum = m:FindFirstChildOfClass("Humanoid")
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            if not Util.isNPC(m) then
                table.insert(list, m)
            end
        end
    end
    return list
end

function Util.findMagnetMobs()
    local mobs = {}
    for _, m in ipairs(Util.getAllEnemies()) do
        local n = m.Name
        if n:find("Magnetized") or n:find("Overcharged") then
            table.insert(mobs, m)
        end
    end
    return mobs
end

function Util.hasMagnetFruit()
    local char = LP.Character
    if not char then return false end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:find("Magnet") then
            return true
        end
    end
    return false
end

function Util.getTokenBalance()
    local tokenRemote = Util.fetchRemote("MagnetTokenCheck")
        or Util.fetchRemote("GachaCheck")
        or Util.fetchRemote("CommF_")
    if not tokenRemote then return 0 end
    local ok, balance = pcall(function()
        return tokenRemote:InvokeServer("MagnetTokens")
    end)
    if ok and type(balance) == "number" then return balance end
    return 0
end

-- Quest interaction. Universal fallback set.
function Util.startQuest(npcName, level)
    local candidates = {
        Util.fetchRemote("CommF_"),
        Util.fetchRemote("CommE_"),
        Util.fetchRemote("QuestSystem"),
        Util.fetchRemote("QuestRemote"),
    }
    for _, remote in ipairs(candidates) do
        if remote then
            local ok = pcall(function()
                remote:InvokeServer("StartQuest", npcName, level)
            end)
            if ok then return true end
        end
    end
    return false
end

function Util.getLevel()
    local data = LP:FindFirstChild("Data")
    if data then
        local lvl = data:FindFirstChild("Level")
        if lvl then return lvl.Value end
    end
    return 1
end

return Util
