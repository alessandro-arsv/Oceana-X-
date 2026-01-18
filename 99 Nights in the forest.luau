-- 99 nights in the forest modification 

-- version 1.0.0
-- OCEANA X
-- yes everything uses windUI
-- this was pushed back i work on other things

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local itemsFolder = workspace:FindFirstChild("Items")
local allItems = {}


local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {
    DMG = game.ReplicatedStorage.RemoteEvents:FindFirstChild("DamagePlayer"),
    RPI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem")
}
local Window = WindUI:CreateWindow({
    Title = "Oceana X",
    Icon = "door-open",
    Author = "by @s3curee and @twinnn",
    Folder = "Oceana",
    Transparent = true,
    Theme = "Dark",
    ToggleKey = Enum.KeyCode.RightControl,

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
    SpamPlant = false,
    PlantOrbit = false,
    Plant = nil,
    OrbitSpeed = 5,
    OrbitRadius = 10,
}

local SaplingsTab = Window:Tab({ 
    Title = "Saplings",
    Icon = "solar:flame-bold",
    IconColor = Color3.fromHex("#ff8c00"),
    IconShape = "Square" 
})
SaplingsTab:Toggle({
    Title = "Spam Plant",
    Value = false,
    Callback = function(state) 
        settings.SpamPlant = state
    end
})
SaplingsTab:Toggle({
    Title = "Plant orbit",
    Value = false,
    Callback = function(state) 
        settings.PlantOrbit = state
    end
})
SaplingsTab:Slider({
    Title = "Orbit radius",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 10,
    },
    Callback = function(value)
        settings.OrbitRadius = value
    end
})
SaplingsTab:Slider({
    Title = "Orbit speed",
    Step = 1,
    Value = {
        Min = 1,
        Max = 20,
        Default = 5,
    },
    Callback = function(value)
        settings.OrbitSpeed = value
    end
})

local ItemsTab = Window:Tab({ 
    Title = "Items",
    Icon = "solar:flame-bold",
    IconColor = Color3.fromHex("#ff8c00"),
    IconShape = "Square" 
})
ItemsTab:Button({
    Title = "Bring all items",
    Callback = function() 
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        for _, item in ipairs(allItems) do
            if item.Name ~= "^Item Chest" then
                local args = { item }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem"):FireServer(unpack(args))
            task.wait(0.03)
            if item:IsA("BasePart") then
                item.CFrame = i.ROOT.CFrame + Vector3.new(0, 3, 0)
            elseif item:IsA("Model") and item.PrimaryPart then
                item:SetPrimaryPartCFrame(i.ROOT.CFrame + Vector3.new(0, 3, 0))
            end
        end
    end
end
})
ItemsTab:Button({
    Title = "Bring all flammables",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local flammableItems = {"Log", "Oil Barrel", "Coal", "Fuel Canister"}
        for _, item in ipairs(allItems) do
            local isFlammable = false
            for _, flammableName in ipairs(flammableItems) do
                if item.Name == flammableName then
                    isFlammable = true
                    break
                end
            end
            if isFlammable then
                local args = { item }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem"):FireServer(unpack(args))
                task.wait(0.03)
                if item:IsA("BasePart") then
                    item.CFrame = i.ROOT.CFrame + Vector3.new(0, 3, 0)
                elseif item:IsA("Model") and item.PrimaryPart then
                    item:SetPrimaryPartCFrame(i.ROOT.CFrame + Vector3.new(0, 3, 0))
                end
            end
        end
    end
})
-- plant orbit
local a = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local i = char_info()
    if not i.CHAR then return end
    a = a + math.rad(settings.OrbitSpeed)
    if settings.SpamPlant and settings.Plant then
        remotes.RPI:InvokeServer(settings.Plant, i.ROOT.Position)
    end
    if settings.PlantOrbit and settings.Plant then
        local of = Vector3.new(
            math.cos(a) * settings.OrbitRadius,
            0,
            math.sin(a) * settings.OrbitRadius
        )
        remotes.RPI:InvokeServer(settings.Plant,i.ROOT.Position + of)
    end
end)

-- hook
local old;
old = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if self == remotes.RPI then
        if method:lower() == "invokeserver" or method:lower() == "fireserver" then
            if args[1] then
                settings.Plant = args[1]
            end
        end
    end
    return old(self, ...)
end)