-- OCEANA X 
-- my fishing brainrots ah script
-- everything is opensource read it or dont lol

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {
    RES = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Networker"):WaitForChild("RF/RequestEggSpawn")
}

local Window = WindUI:CreateWindow({
    Title = "Oceana X",
    Icon = "door-open",
    Author = "by @s3curee",
    Folder = "Oceana",
    Transparent = true,
    Theme = "Sky",
    ToggleKey = Enum.KeyCode.RightControl,
    NewElements = true,
    HideSearchBar = false,
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
    SpeedBoost = false,
    SpeedBoostSpeed = 16,
    AutoSpawn = false
}

local Shop = Window:Tab({ 
    Title = "Eggs",
    Icon = "egg",
    IconColor = Color3.fromHex("#a37846"),
    IconShape = "Square",
})
local PlayerTab = Window:Tab({ 
    Title = "LocalPlayer",
    Icon = "user",
    IconColor = Color3.fromHex("#2bfb3f"),
    IconShape = "Square" 
})
-- eggs
Shop:Toggle({
    Title = "Auto spawn",
    Value = false,
    Callback = function(state) 
        settings.AutoSpawn = state
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
        Default = 20,
    },
    Callback = function(value)
        settings.SpeedBoostSpeed = value
    end
})


game:GetService("RunService").RenderStepped:Connect(function() 
    local i = char_info()
    if not i then return end
    if settings.SpeedBoost then
        i.HUM.WalkSpeed = settings.SpeedBoostSpeed
    end
    if settings.AutoSpawn then
        remotes.RES:InvokeServer()
    end

end)