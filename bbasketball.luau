-- Basketball brainrotted Modification

-- version 1.0.0
-- OCEANA X
-- yes everything uses windUI
-- this was pushed back i work on other things

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local Call = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Call", 5) or ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Call", 5)

local Window = WindUI:CreateWindow({
    Title = "Oceana X",
    Icon = "door-open",
    Author = "by @s3curee",
    Folder = "Oceana",
    Transparent = true,
    Theme = "Sky",
    ToggleKey = Enum.KeyCode.RightControl,
    NewElements = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
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

function char_info() 
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    return {
        CHAR = character,
        HUM = character:FindFirstChildOfClass("Humanoid"),
        ROOT = character.HumanoidRootPart,
        DISPLAY = LocalPlayer.DisplayName,
        NAME = LocalPlayer.Name,
        LP = LocalPlayer,
    }
end

local settings = {
    Lagger = false,
    AntiLag = true,
    LaggerStrength = 10,
    SpeedBoost = false,
    SpeedBoostSpeed = 16
}

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
}) -- player
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
    Desc = "They sort of patched this now it lags you more than others and only sort of lags on 100%",
    Callback = function(state) 
        settings.Lagger = state
    end
})
LagTab:Slider({
    Title = "Lag Strength",
    Step = 10,
    Value = {
        Min = 20,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        settings.LaggerStrength = value
    end
})
-- local player
PlayerTab:Toggle({
    Title = "SpeedBoost",
    Value = false,
    Callback = function(state) 
        settings.SpeedBoost = state
    end
})
PlayerTab:Slider({
    Title = "Speedboost speed",
    Step = 10,
    Value = {
        Min = 20,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        settings.SpeedBoostSpeed = value
    end
})

-- totally not geminied
local function kl(obj)
    if not settings.AntiLag then return end
    if obj:FindFirstAncestor("WindUI") then return end

    if obj:IsA("TextLabel") or obj:IsA("BillboardGui") or obj:IsA("Sound") or obj:IsA("ScreenGui") then
        if obj:IsA("TextLabel") then
            if obj:IsA("TextLabel").Text == "Pass" then
                obj:Destroy()
            end
        end
        task.spawn(function()
            obj:Destroy()
        end)
    end

    if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
        local p = obj.Parent
        if p:IsA("ScreenGui") or p:IsA("BillboardGui") or p:IsA("Frame") or p:IsA("TextLabel") then
            task.spawn(function()
                obj:Destroy()
            end)
        end
    end
end

local function mp(path)
    if not path then return end
    path.DescendantAdded:Connect(kl)
end

mp(LocalPlayer.PlayerGui)
LocalPlayer.CharacterAdded:Connect(mp)
if LocalPlayer.Character then mp(LocalPlayer.Character) end
for _,v in game.Players:GetPlayers() do
    v.CharacterAdded:Connect(mp)
    if v.Character then mp(v.Character) end
end
game:GetService("RunService").RenderStepped:Connect(function()
    local data = char_info()
    if not data.CHAR or not data.ROOT then return end
    if settings.Lagger then
        for count = 1, settings.LaggerStrength do
            if not settings.Lagger then break end
            Call:FireServer()
        end
    end
    if settings.SpeedBoost then
        data.HUM.WalkSpeed = settings.SpeedBoostSpeed
    end
end)