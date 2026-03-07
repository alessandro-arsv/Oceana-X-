
repeat task.wait() until game:IsLoaded()

local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()


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


local HELPERS = Window:Tab({ Title = "Helpers", Icon = "zap"  })
local TPS = Window:Tab({ Title = "Teleports & others", Icon = "zap" })

local autoClick, autoBuyClickPower, autoCleanAccidents, AutoFillFood
HELPERS:Toggle({
    Title = "AutoClick Tung tung",
    Value = false,
    Callback = function(state)
        autoClick = state
    end
})
HELPERS:Toggle({
    Title = "auto Buy ClickPower",
    Value = false,
    Callback = function(state)
        autoBuyClickPower = state
    end
})
HELPERS:Toggle({
    Title = "auto PET Clean Accidents",
    Value = false,
    Callback = function(state)
        autoCleanAccidents = state
    end
})
HELPERS:Toggle({
    Title = "auto Fill Food",
    Value = false,
    Callback = function(state)
        AutoFillFood = state
    end
})
local LP = game.Players.LocalPlayer

task.spawn(function()
    while task.wait() do
        if autoClick then
            workspace.TungTung.TungTungHitbox.ClickDetector.MaxActivationDistance = math.huge
            fireclickdetector(workspace.TungTung.TungTungHitbox.ClickDetector, 1) 
        end
        if autoBuyClickPower then
            local args = {
                "click"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("PurchaseUpgrade"):FireServer(unpack(args))
        end
        if autoCleanAccidents then
            local originalPos = LP.Character.HumanoidRootPart.CFrame
            for _, acciedent in workspace.PetAccidents:GetChildren() do
                local CleanPrompt = acciedent.Union.CleanPrompt
                LP.Character.HumanoidRootPart.CFrame = acciedent.Union.CFrame
                task.wait()
                fireproximityprompt(CleanPrompt)
                task.wait(0.5)
                LP.Character.HumanoidRootPart.CFrame = originalPos
            end
        end
        if AutoFillFood then
            local originalPos = LP.Character.HumanoidRootPart.CFrame
            if workspace.TungFood.Fullness.Value ~= 100 then
                local FoodBuyPart = workspace.FoodBuyPart
                local thePrompt = FoodBuyPart.ProximityPrompt
                LP.Character.HumanoidRootPart.CFrame = FoodBuyPart.CFrame
                task.wait()
                fireproximityprompt(thePrompt)
                task.wait(1.5)
                local foodbowl = workspace.TungFood.FoodBowl
                local foolTool = game:GetService("Players").LocalPlayer.Backpack:GetChildren()[1]

                if foolTool then
                    game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(foolTool)
                    local thePrompt2 = foodbowl.FillBowlPrompt
                    LP.Character.HumanoidRootPart.CFrame = foodbowl.CFrame
                    task.wait(0.5)

                    fireproximityprompt(thePrompt2)

                    task.wait(1)
                end
                LP.Character.HumanoidRootPart.CFrame = originalPos
            end
            
        end
    end
end)

TPS:Button({
    Title = "Open Passive Shop",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("RequestPassivesShopData"):FireServer()
    end
})
TPS:Button({
    Title = "Open Dealer Shop",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("RequestDealerShopData"):FireServer()
    end
})
TPS:Button({
    Title = "Open Shop",
    Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("RequestShopData"):FireServer()
    end
})
TPS:Button({
    Title = "Teleport to Dealer",
    Callback = function()
        LP.Character.HumanoidRootPart.CFrame = workspace["Teleport (Dealer)"]["Teleport (To)"].CFrame
    end
})
TPS:Button({
    Title = "Teleport to Heaven",
    Callback = function()
        LP.Character.HumanoidRootPart.CFrame = workspace["Teleport (Heaven)"]["Teleport (From)"].CFrame
    end
})
TPS:Button({
    Title = "Teleport to Sewer",
    Callback = function()
        LP.Character.HumanoidRootPart.CFrame = workspace["Teleport (Sewer)"]["Teleport (From)"].CFrame
    end
})