repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI:AddTheme({ 
    Name = "My Theme", 
    Accent = Color3.fromHex("#18181b"), 
    Background = Color3.fromHex("#101010"), 
    Outline = Color3.fromHex("#FFFFFF"), 
    Text = Color3.fromHex("#FFFFFF"), 
    Placeholder = Color3.fromHex("#7a7a7a"), 
    Button = Color3.fromHex("#52525b"), 
    Icon = Color3.fromHex("#a1a1aa"), 
})

local remotes = {
    c = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Call", 5)
}

local Window = WindUI:CreateWindow({
    Title = "Oceana X",
    Icon = "door-open",
    Author = "by @s3curee and @twinnn",
    Folder = "Oceana",
    Transparent = true,
    Theme = "My Theme",
    ToggleKey = Enum.KeyCode.RightControl,
    NewElements = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
    },
})

Window:EditOpenButton({
    Title = "Oceana X",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local settings = {
    Lagger = false,
    AntiLag = true,
    LaggerStrength = 20,
    SpeedBoost = false,
    SpeedBoostSpeed = 20
}

local function char_info() 
    local character = LocalPlayer.Character
    if not character then return nil end
    local hum = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return nil end
    return {
        CHAR = character,
        HUM = hum,
        ROOT = root,
        DISPLAY = LocalPlayer.DisplayName,
        NAME = LocalPlayer.Name,
        LP = LocalPlayer,
    }
end

local LagTab = Window:Tab({ 
    Title = "Lag",
    Icon = "solar:flame-bold",
    IconColor = Color3.fromHex("#ff8c00"),
    IconShape = "Square" 
})

local PlayerTab = Window:Tab({ 
    Title = "LocalPlayer",
    Icon = "solar:snowflake-bold",
    IconColor = Color3.fromHex("#2bfb3f"),
    IconShape = "Square" 
})

LagTab:Toggle({
    Title = "AntiLag",
    Value = true,
    Callback = function(state) 
        settings.AntiLag = state
    end
})

LagTab:Toggle({
    Title = "Lagger",
    Value = false,
    Callback = function(state) 
        settings.Lagger = state
    end
})

LagTab:Slider({
    Title = "Lag Strength",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 20,
    },
    Callback = function(value)
        settings.LaggerStrength = value
    end
})

PlayerTab:Toggle({
    Title = "SpeedBoost",
    Value = false,
    Callback = function(state) 
        settings.SpeedBoost = state
        if not state then
            local data = char_info()
            if data then data.HUM.WalkSpeed = 16 end
        end
    end
})

PlayerTab:Slider({
    Title = "Speedboost speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 20,
    },
    Callback = function(value)
        settings.SpeedBoostSpeed = value
    end
})

local function kl(obj)
    if not settings.AntiLag then return end
    if obj:FindFirstAncestor("WindUI") or obj.Name == "WindUI" then return end

    if obj:IsA("TextLabel") or obj:IsA("BillboardGui") or obj:IsA("Sound") or obj:IsA("ScreenGui") then
        task.spawn(function()
            pcall(function() obj:Destroy() end)
        end)
    end

    if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
        local p = obj.Parent
        if p and (p:IsA("ScreenGui") or p:IsA("BillboardGui") or p:IsA("Frame") or p:IsA("TextLabel")) then
            task.spawn(function()
                pcall(function() obj:Destroy() end)
            end)
        end
    end
end

local function mp(path)
    if not path then return end
    path.DescendantAdded:Connect(kl)
    for _, v in ipairs(path:GetDescendants()) do
        kl(v)
    end
end

task.spawn(function()
    mp(LocalPlayer:WaitForChild("PlayerGui"))
end)

LocalPlayer.CharacterAdded:Connect(mp)
if LocalPlayer.Character then mp(LocalPlayer.Character) end

for _, v in ipairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then
        v.CharacterAdded:Connect(mp)
        if v.Character then mp(v.Character) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(mp)
end)

RunService.Heartbeat:Connect(function()
    local data = char_info()
    
    if settings.Lagger and remotes.c then
        for count = 1, settings.LaggerStrength do
            remotes.c:FireServer()
        end
    end
    
    if settings.SpeedBoost and data then
        data.HUM.WalkSpeed = settings.SpeedBoostSpeed
    end
end)