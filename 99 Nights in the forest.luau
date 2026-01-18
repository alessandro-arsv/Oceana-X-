-- 99 nights in the forest modification 

-- version 1.0.0
-- OCEANA X
-- yes everything uses windUI
-- this was pushed back i work on other things

--[[ future new tabs: 
    Combat
    Auto Farm
    ESP
    Movement
    World
    Teleport
]]

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
    RPI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"),
    SDI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem"),
    RSDI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem"),
    ROIC = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestOpenItemChest"),
    RRP = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestRevivePlayer"),
}
local Window = WindUI:CreateWindow({
    Title = "Oceana X",
    Icon = "door-open",
    Author = "by @s3curee and @twinnn",
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

function item_teleport(item)

    local args = { item }
    remotes.RSDI:FireServer(unpack(args))
    task.wait(0.03)
    if item:IsA("BasePart") then
        item.CFrame = char_info().ROOT.CFrame + Vector3.new(0, 3, 0)
    elseif item:IsA("Model") and item.PrimaryPart then
        item:SetPrimaryPartCFrame(char_info().ROOT.CFrame + Vector3.new(0, 3, 0))
    end

    remotes.SDI:FireServer(unpack(args))
end


local settings = {
    SpamPlant = false,
    PlantOrbit = false,
    Plant = nil,
    OrbitSpeed = 5,
    OrbitRadius = 10,
    Walkspeed = 16,
    WalkspeedEnabled = false,
    ExcludeItems = {"Item Chest", "Item Chest2", "Item Chest3", "Item Chest4", "Item Chest5", "Item Chest6", "Item Chest7", "StoneChest1", "StoneChest2", "Halloween Maze Chest", "Halloween Chest1", "Mossy Chest", "Stronghold Diamond Chest", "Volcanic Chest1", "Volcanic Chest2", "Coin Stack"},
    FlammableItems = {"Log", "Oil Barrel", "Coal", "Fuel Canister", "Chair", "Cultist", "Crossbow Cultist", "Bear Corpse", "Wolf Corpse", "Biofuel"},
    ScrapItems = {"Broken Microwave", "Broken Fan", "Bolt", "Old Radio", "Sheet Metal", "Tyre", "Cultist Experiment", "Washing Machine", "Cultist Prototype", "Gem of the Forest", "Cultist Gem", "Old Car Engine", "Metal Chair"},
    Weapons =  {"Revolver", "Rifle", "Scythe", "Morningstar", "Explosive Rifle"}, -- adding more later
    
}
-- SAPLINGS
local SaplingsTab = Window:Tab({ 
    Title = "Saplings",
    Icon = "leafy-green",
    IconColor = Color3.fromHex("#2bfb35"),
    IconShape = "Square" 
})
SaplingsTab:Toggle({
    Title = "Spam Plant",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        settings.SpamPlant = state
    end
})
SaplingsTab:Toggle({
    Title = "Plant orbit",
    type = "Toggle",
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

-- ITEMS TAB
local ItemsTab = Window:Tab({ 
    Title = "Items",
    Icon = "align-center-vertical",
    IconColor = Color3.fromHex("#6c4c22"),
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
            local isExcluded = false
            for _, excludeName in ipairs(settings.ExcludeItems) do
                if item.Name == excludeName then
                    isExcluded = true
                    break
                end
            end
            if not isExcluded then
                item_teleport(item)
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
        local flammableItems = settings.FlammableItems
        for _, item in ipairs(allItems) do
            local isFlammable = false
            for _, flammableName in ipairs(flammableItems) do
                if item.Name == flammableName then
                    isFlammable = true
                    break
                end
            end
            if isFlammable then
                item_teleport(item)
            end
        end
    end
})

ItemsTab:Button({
    Title = "Bring all scrap",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local scrapItems = settings.ScrapItems
        for _, item in ipairs(allItems) do
            local isScrap = false
            for _, scrapName in ipairs(scrapItems) do
                if item.Name == scrapName then
                    isScrap = true
                    break
                end
            end
            if isScrap then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Open all chests",
    Callback = function()
        for _,v in workspace.Items:GetChildren() do
            local args = {
                v
            }
            remotes.ROIC:FireServer(unpack(args))
        end
    end
})
-- PLAYER TAB
local PlayerTab = Window:Tab({ 
    Title = "Player",
    Icon = "user",
    IconColor = Color3.fromRGB(20, 18, 150),
    IconShape = "Square" 
})
PlayerTab:Button({
    Title = "God Mode",
    Desc = "use again if you put on armor or eat food",
    Callback = function() 
        game.ReplicatedStorage.RemoteEvents:FindFirstChild("DamagePlayer"):FireServer(-math.huge)
    end
})
PlayerTab:Toggle({
    Title = "Walkspeed enabled",
    Type = "Toggle",
    Value = false, -- default value
    Callback = function(state) 
        settings.WalkspeedEnabled = state
    end
})

PlayerTab:Slider({
    Title = "Walkspeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        settings.Walkspeed = value
    end
})

-- plant orbit
local a = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local i = char_info()
    if not i.CHAR then return end
    a = a + math.rad(settings.OrbitSpeed)
    if settings.SpamPlant and (settings.Plant or workspace.Items:FindFirstChild("Sapling")) then
        remotes.RPI:InvokeServer(settings.Plant or workspace.Items:FindFirstChild("Sapling"), i.ROOT.Position)
    end
    if settings.PlantOrbit and (settings.Plant or workspace.Items:FindFirstChild("Sapling")) then
        local of = Vector3.new(
            math.cos(a) * settings.OrbitRadius,
            0,
            math.sin(a) * settings.OrbitRadius
        )
        remotes.RPI:InvokeServer(settings.Plant or workspace.Items:FindFirstChild("Sapling") ,i.ROOT.Position + of)
    end
    if settings.WalkspeedEnabled then
        i.HUM.WalkSpeed = settings.Walkspeed
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