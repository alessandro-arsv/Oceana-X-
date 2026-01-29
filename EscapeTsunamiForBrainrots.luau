-- Escape TsunamiForBrainrots

-- version 1.0.0
-- OCEANA X
-- yes everything uses windUI

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {

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
    InfJump = false,
}

local PlayerTab = Window:Tab({ 
    Title = "LocalPlayer",
    Icon = "solar:snowflake-bold",
    IconColor = Color3.fromHex("#2bfb3f"),
    IconShape = "Square" 
}) -- player
-- local player
PlayerTab:Toggle({
    Title = "SpeedBoost",
    Value = false,
    Callback = function(state) 
        settings.SpeedBoost = state
    end
})
PlayerTab:Slider({
    Title = "Speedboost Strength",
    Step = 10,
    Value = {
        Min = 10,
        Max = 500,
        Default = 200,
    },
    Callback = function(value)
        settings.SpeedBoostSpeed = value
    end
})
PlayerTab:Toggle({
    Title = "InfJump",
    Value = false,
    Callback = function(state) 
        settings.InfJump = state
    end
})
PlayerTab:Button({
    Title = "Free VIP(walls)",
    Locked = false,
    Callback = function()
        local chardata = char_info()
        if not chardata then return end
        chardata.LP:SetAttribute("HasVIPPlus",true)
        chardata.LP:SetAttribute("HasVIP",true)
        for _,v in workspace.VIPWalls:GetChildren() do
            v:Destroy()
        end
    end
})
RunService.RenderStepped:Connect(function()
    local chardata = char_info()
    if not chardata then return end
    local moveDir = chardata.HUM.MoveDirection
    if settings.SpeedBoost == true and moveDir.Magnitude > 0 then
        chardata.ROOT.AssemblyLinearVelocity = Vector3.new(moveDir.X * settings.SpeedBoostSpeed, chardata.ROOT.AssemblyLinearVelocity.Y, moveDir.Z * settings.SpeedBoostSpeed)
    end
    if settings.InfJump and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
        chardata.ROOT.AssemblyLinearVelocity = Vector3.new(chardata.ROOT.AssemblyLinearVelocity.X, chardata.HUM.JumpPower, chardata.ROOT.AssemblyLinearVelocity.Z)
    end


end)