-- OCEANA X 
-- You Vs Homer Mod
-- this was made because onionware fr sucks 
-- YOU VS HOMER
-- everything is opensource read it or dont lol

repeat task.wait() until game:IsLoaded()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {
    bi = game:GetService("ReplicatedStorage"):WaitForChild("eventFolders"):WaitForChild("store"):WaitForChild("buyItem"),
    cs = game:GetService("ReplicatedStorage"):WaitForChild("eventFolders"):WaitForChild("store"):WaitForChild("changeSkin")
}
local module_scripts = {
    skinData = require(game:GetService("ReplicatedStorage").moduleFolders.lists.skinData)
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
    AutoCoins = false,
    KillAll = false,
    AutoFarm = false
}

local Farming = Window:Tab({ 
    Title = "Farming",
    Icon = "ranch",
    IconColor = Color3.fromHex("#2bfb7d"),
    IconShape = "Square",
})

Farming:Toggle({
    Title = "Autofarm coins",
    Value = false,
    Callback = function(state) 
        settings.AutoCoins = state
    end
})

Farming:Toggle({
    Title = "Kill All(homer)",
    Value = false,
    Callback = function(state) 
        settings.KillAll = state
    end
})

Farming:Toggle({
    Title = "AutoFarm",
    Value = false,
    Callback = function(state) 
        settings.AutoFarm = state
    end
})

local Skins = Window:Tab({ 
    Title = "Skins",
    Icon = "ranch",
    IconColor = Color3.fromHex("#bc863d"),
    IconShape = "Square",
})
Skins:Section({ 
    Title = "Homers",
    Opened = true,
})
for b,v in pairs(module_scripts.skinData.Homer) do
    Skins:Button({
        Title = b,
        Desc = "this character costs " .. v["cost"],
        Locked = false,
        Callback = function()
            local args = {
                "Homer",
                b,
                v["cost"]
            }
            remotes.bi:FireServer(unpack(args))

            task.wait(0.05)

            local args = {
                "Homer",
                b
            }
            remotes.cs:FireServer(unpack(args))
        end
    })
end
Skins:Section({ 
    Title = "Barts",
    Opened = true,
})
for b,v in pairs(module_scripts.skinData.Bart) do
    Skins:Button({
        Title = b,
        Desc = "this character costs " .. v["cost"],
        Locked = false,
        Callback = function()
            local args = {
                "Bart",
                b,
                v["cost"]
            }
            remotes.bi:FireServer(unpack(args))

            task.wait(0.05)

            local args = {
                "Bart",
                b
            }
            remotes.cs:FireServer(unpack(args))
        end
    })
end


RunService.RenderStepped:Connect(function()
    local i = char_info()
    if not i then return end
    
    if settings.AutoCoins then
        firetouchinterest(workspace.lobbyCage.obby.landawnObby.winpad, i.ROOT, 0)
        firetouchinterest(workspace.lobbyCage.obby.landawnObby.winpad,i.ROOT, 1) 

    end
    if settings.KillAll then
        if game.Players.LocalPlayer.Team == "Homer" then -- this is mine & was sent to onion owner to use(dont think they use it)
            for _,v in game.Players:GetPlayers() do
                if v == game.Players.LocalPlayer or v.Team ~= "Bart" or game.LocalPLayer.Team ~= "Homer" or v:FindFirstChild("HumanoidRootPart").TouchInterest == nil then continue end
                if firetouchinterest then
                    local i = v.Character:FindFirstChild("HumanoidRootPart").TouchInterest
                    firetouchinterest(i,i.ROOT,0)
                    firetouchinterest(i,i.ROOT,1)
                else
                    v.Character.HumanoidRootPart.CFrame = i.ROOT.CFrame
                end
            end
        end
    end
    if settings.AutoFarm then 
        if game.Players.LocalPlayer.Team == "Homer" then -- yea
            for _,v in game.Players:GetPlayers() do
                if v == game.Players.LocalPlayer or v.Team ~= "Bart" or game.LocalPLayer.Team ~= "Homer" or v:FindFirstChild("HumanoidRootPart").TouchInterest == nil then continue end
                if firetouchinterest then
                    local i = v.Character:FindFirstChild("HumanoidRootPart").TouchInterest
                    firetouchinterest(i, i.ROOT,0)
                    firetouchinterest(i, i.ROOT,1)
                else
                    v.Character.HumanoidRootPart.CFrame =  i.ROOT.CFrame
                end
            end
        else -- same thing for this(this is mine & was sent to onion owner to use(dont think they use it))
            firetouchinterest(workspace.lobbyCage.obby.landawnObby.winpad,  i.ROOT, 0)
            firetouchinterest(workspace.lobbyCage.obby.landawnObby.winpad, i.ROOT, 1)
        end
    end


end)