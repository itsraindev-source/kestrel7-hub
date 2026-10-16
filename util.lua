local Util = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer

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
    bp:Destroy()
end

function Util.notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4,
    })
end

function Util.isMagnetEvent()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        for _, child in ipairs(sky:GetChildren()) do
            if child.Name:find("Magnet") then return true end
        end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name:find("Scrap") or obj.Name:find("Magnet") then
            return true
        end
    end
    return false
end

function Util.findMagnetMobs()
    local mobs = {}
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return mobs end
    for _, m in ipairs(enemies:GetChildren()) do
        local hum = m:FindFirstChildOfClass("Humanoid")
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum.Health > 0 then
            local name = m.Name
            if name:find("Magnetized") or name:find("Overcharged") then
                table.insert(mobs, m)
            end
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
    local remotes = Util.Remotes
    local tokenRemote = remotes["MagnetTokenCheck"] or remotes["GachaCheck"]
    if not tokenRemote then return 0 end
    local ok, balance = pcall(function()
        return tokenRemote:InvokeServer("MagnetTokens")
    end)
    if ok and type(balance) == "number" then return balance end
    return 0
end

return Util
