-- OCEANA X 
-- GET RICH
-- GET RICH
-- everything is opensource read it or dont lol

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {
    shopRemote = game:GetService("ReplicatedStorage"):WaitForChild("\224\178\161")
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
    AutoClick = false,
    AutoBuyCashPlus = false,
    AutoBuyWalkspeed = false,
    AutoBuyMagnet = false,
    AutoCollectDrops = false,
    AutoFarmArea = false
}

local Shop = Window:Tab({ 
    Title = "Shop",
    Icon = "store",
    IconColor = Color3.fromHex("#a37846"),
    IconShape = "Square",
})

Shop:Toggle({
    Title = "AutoClick",
    Value = false,
    Callback = function(state) 
        settings.AutoClick = state
    end
})

Shop:Toggle({
    Title = "Auto Buy Cash+",
    Value = false,
    Callback = function(state) 
        settings.AutoBuyCashPlus = state
    end
})

Shop:Toggle({
    Title = "Auto Buy Magnet",
    Value = false,
    Callback = function(state) 
        settings.AutoBuyMagnet = state
    end
})

Shop:Toggle({
    Title = "Auto buy walkspeed",
    Value = false,
    Callback = function(state) 
        settings.AutoBuyWalkspeed = state
    end
})
Shop:Toggle({
    Title = "AutoCollect Coins",
    Value = false,
    Callback = function(state) 
        settings.AutoCollectDrops = state
    end
})
Shop:Toggle({
    Title = "AutoFarm Area",
    Value = false,
    Callback = function(state) 
        settings.AutoFarmArea = state
    end
})



game:GetService("RunService").RenderStepped:Connect(function() 
    local i = char_info()
    if not i then return end
    if settings.AutoCollectDrops then
        for _,v in workspace.Drops:GetChildren() do
            local touch =  v:FindFirstChild("TouchInterest")
            if touch then
                firetouchinterest(v or v,i.ROOT, 0)
                firetouchinterest(v or v,i.ROOT, 1)
                task.wait(0.018)
            end
        end
    end
    if settings.AutoClick then
        for count = 0, 3 do
            remotes.shopRemote:FireServer(unpack({
                {
                    "money"
                }
            }))
        end

    end
    if settings.AutoFarmArea then
        local area = workspace.Gates.FarmArea
        local area2 = workspace.Gates.Area2
        firetouchinterest(area,i.ROOT, 0)
        firetouchinterest(area,i.ROOT, 1)

        firetouchinterest(area2,i.ROOT, 0)
        firetouchinterest(area2,i.ROOT, 1)
    end
    
    if settings.AutoBuyCashPlus then
        remotes.shopRemote:FireServer(unpack({
            {
                "buy",
                "Cash+",
                "Upgrades"
            }
        }))

    end
    if settings.AutoBuyMagnet then
        remotes.shopRemote:FireServer(unpack({
            {
                "buy",
                "Magnet",
                "Upgrades"
            }
        }))

    end
    if settings.AutoBuyWalkspeed then
        remotes.shopRemote:FireServer(unpack({
            {
                "buy",
                "Walkspeed",
                "Upgrades"
            }
        }))

    end
end)