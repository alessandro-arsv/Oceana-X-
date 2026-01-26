-- 99 nights in the forest modification 

-- version 1.0.0
-- OCEANA X
-- yes everything uses windUI
-- this was pushed back i work on other things

--[[ future new tabs: 
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
local charactersFolder = workspace:WaitForChild("Characters")
local FoliageFolder = workspace.Map:WaitForChild("Foliage")
local allItems = {}
local characters = {}


local vers = "eeea3871e0458b7626f446121fbe58eb61689229"
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/" .. vers .. "/dist/main.lua"))()

local remotes = {
    DMG = game.ReplicatedStorage.RemoteEvents:FindFirstChild("DamagePlayer"),
    RPI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"),
    SDI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("StopDraggingItem"),
    RSDI = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem"),
    ROIC = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestOpenItemChest"),
    RRP = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestRevivePlayer"),
    TDO = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"),
    UEIH = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UnequipItemHandle"),
    EIH = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("EquipItemHandle"),
    RBP = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestBroadcastPing")
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
    KillAura = false,
    KillAuraRange = 100,
    ChopAuraRange = 10,
    AntiAFKEnabled = false,
    PlayerNames = false,
    PlayerTracers = false,
    CharacterNames = false,
    CharacterTracers = false,
    ItemNames = false,
    ItemTracers = false,
    ChildNames = false,
    ChildTracers = false,
    CampfireName = false,
    CampfireTracers = false,
    ExcludeItems = {"Item Chest", "Item Chest2", "Item Chest3", "Item Chest4", "Item Chest5", "Item Chest6", "Item Chest7", "StoneChest1", "StoneChest2", "Halloween Maze Chest", "Halloween Chest1", "Mossy Chest", "Stronghold Diamond Chest", "Volcanic Chest1", "Volcanic Chest2", "Coin Stack", "Alien Chest", "Hardmode Crate"},
    FlammableItems = {"Log", "Oil Barrel", "Coal", "Fuel Canister", "Chair", "Cultist", "Crossbow Cultist", "Bear Corpse", "Wolf Corpse", "Biofuel", "Alpha Wolf Corpse", "Alien", "Alien Elite"},
    ScrapItems = {"Broken Microwave", "Broken Fan", "Bolt", "Old Radio", "Sheet Metal", "Tyre", "Cultist Experiment", "Washing Machine", "Cultist Prototype", "Gem of the Forest", "Cultist Gem", "Old Car Engine", "Metal Chair", "UFO Component", "UFO Scrap"},
    Weapons =  {"Revolver", "Rifle", "Scythe", "Morningstar", "Explosive Rifle", "Kunai", "Strong Axe", "Good Axe", "Spear"},
    excludedCharacters = {"Lost Child", "Lost Child2", "Lost Child3", "Lost Child4"},
    Food = {"Morsel", "Steak", "Cooked Morsel", "Cooked Steak", "Cake", "Berry", "Carrot", "Cooked Ribs"},
    sapling = {"Sapling"}, -- sapling
    Heals = {"Bandage", "MedKit"},
    Sacks = {"Good Sack", "Infernal Sack", "Giant Sack"},
    Armor = {"Leather Body", "Iron Body", "Thorn Body", "Alien Armour", "Obsidiron Body", "Vampire Cloak", "Riot Shield", "Poison Armour"},
    explosives = {"Impact Grenade", "Dynamite"},
    weaponaxesithink = {"Old Axe", "Good Axe", "Strong Axe"},
    MeleeOnlyWeapons = {"Old Axe", "Good Axe", "Strong Axe", "Spear", "Morningstar"}, -- not adding scythe cause its annoying
}
-- SAPLINGS TAB
local SaplingsTab = Window:Tab({ 
    Title = "Saplings",
    Icon = "leafy-green",
    IconColor = Color3.fromHex("#2bfb35"),
    IconShape = "Square" 
})
SaplingsTab:Toggle({
    Title = "Spam plant",
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
    Title = "Bring all items (everything)",
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
    Title = "Bring all weapons",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local weaponItems = settings.Weapons
        for _, item in ipairs(allItems) do
            local isWeapon = false
            for _, weaponName in ipairs(weaponItems) do
                if item.Name == weaponName then
                    isWeapon = true
                    break
                end
            end
            if isWeapon then
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
    Title = "Bring all food",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local foodItems = settings.Food
        for _, item in ipairs(allItems) do
            local isFood = false
            for _, foodName in ipairs(foodItems) do
                if item.Name == foodName then
                    isFood = true
                    break
                end
            end
            if isFood then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Bring all saplings",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local saplingsItems = settings.sapling
        for _, item in ipairs(allItems) do
            local isSapling = false
            for _, saplingName in ipairs(saplingsItems) do
                if item.Name == saplingName then
                    isSapling = true
                    break
                end
            end
            if isSapling then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Bring all heals",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local healingItems = settings.Heals
        for _, item in ipairs(allItems) do
            local isHeals = false
            for _, healsName in ipairs(healingItems) do
                if item.Name == healsName then
                    isHeals = true
                    break
                end
            end
            if isHeals then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Bring all sacks",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local sackItems = settings.Sacks
        for _, item in ipairs(allItems) do
            local isSack = false
            for _, sackName in ipairs(sackItems) do
                if item.Name == sackName then
                    isSack = true
                    break
                end
            end
            if isSack then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Bring all armor/armour",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local armorItems = settings.Armor
        for _, item in ipairs(allItems) do
            local isArmor = false
            for _, armorName in ipairs(armorItems) do
                if item.Name == armorName then
                    isArmor = true
                    break
                end
            end
            if isArmor then
                item_teleport(item)
            end
        end
    end
})
ItemsTab:Button({
    Title = "Bring all explosives",
    Callback = function()
        local i = char_info()
        if itemsFolder then
            allItems = itemsFolder:GetChildren()
        end
        local explosiveItems = settings.explosives
        for _, item in ipairs(allItems) do
            local isExplosive = false
            for _, explosiveName in ipairs(explosiveItems) do
                if item.Name == explosiveName then
                    isExplosive = true
                    break
                end
            end
            if isExplosive then
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
    IconColor = Color3.fromRGB(43, 169, 251),
    IconShape = "Square" 
})
PlayerTab:Button({
    Title = "God Mode",
    Desc = "use again if you eat something that deals damage or gives health. (like raw food)",
    Callback = function() 
        game.ReplicatedStorage.RemoteEvents:FindFirstChild("DamagePlayer"):FireServer(-math.huge)
    end
})
PlayerTab:Toggle({
    Title = "Anti-AFK",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.AntiAFKEnabled = state
    end
})
PlayerTab:Toggle({
    Title = "Walkspeed enabled",
    Type = "Toggle",
    Value = false,
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

-- COMBAT TAB
local CombatTab = Window:Tab({ 
    Title = "Combat",
    Icon = "sword",
    IconColor = Color3.fromHex("#db1010"),
    IconShape = "Square"
})
CombatTab:Toggle({
    Title = "Kill Aura",
    Desc = "Warning: Melee weapons only (hold out weapon to actually do kill aura)",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        settings.KillAura = state
    end
})
CombatTab:Slider({
    Title = "Kill Aura Range",
    Step = 1,
    Value = {
        Min = 50,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        settings.KillAuraRange = value
    end
})
CombatTab:Toggle({
    Title = "Chop Aura",
    Desc = "Warning: Axe only. (hold out axe to actually do chop aura)",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        settings.ChopAura = state
    end
})
CombatTab:Slider({
    Title = "Chop Aura Range",
    Step = 1,
    Value = {
        Min = 10,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        settings.ChopAuraRange = value
    end
})

-- ESP TAB
local ESPTab = Window:Tab({ -- i add the stuff later
    Title = "ESP",
    Icon = "eye",
    IconColor = Color3.fromHex("#00d4ff"),
    IconShape = "Square" 
})
ESPTab:Toggle({
    Title = "Player Names",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.PlayerNames = state
    end
})
ESPTab:Toggle({
    Title = "Player Tracers",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.PlayerTracers = state
    end
})
ESPTab:Toggle({
    Title = "Animal/Character Names",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.CharacterNames = state
    end
})
ESPTab:Toggle({
    Title = "Animal/Character Tracers",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.CharacterTracers = state
    end
})
ESPTab:Toggle({
    Title = "Item Names",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.ItemNames = state
    end
})
ESPTab:Toggle({
    Title = "Item Tracers",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.ItemTracers = state
    end
})
ESPTab:Toggle({
    Title = "Child Names",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.ChildNames = state
    end
})
ESPTab:Toggle({
    Title = "Child Tracers",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.ChildTracers = state
    end
})
ESPTab:Toggle({
    Title = "Campfire Name",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.CampfireName = state
    end
})
ESPTab:Toggle({
    Title = "Campfire Tracers",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        settings.CampfireTracers = state
    end
})

-- SETTINGS
local Settings = Window:Tab({
    Title = "Settings",
    Icon = "settings",
    IconColor = Color3.fromHex("#757575"),
    IconShape = "Square" 
})

local a = 0
local ClientModule = nil
local function lf()
    if not ClientModule then
        local gc = getgc(true)
        for i = 1, #gc do
            local v = gc[i]
            if type(v) == "table" then
                if rawget(v, "EnemyHandler") and rawget(v, "Events") and rawget(v, "Databases") then
                    ClientModule = v
                    return true
                end
            end
        end
    end
    return ClientModule ~= nil
end
-- kill aura
task.spawn(function()
    while task.wait() do
        local i = char_info()
        if not i.CHAR then return end
        if not lf() then continue end
        if settings.KillAura then
            if charactersFolder then
                local playerInventory = i.LP:WaitForChild("Inventory")
                local weapon = nil
                for idx = #settings.MeleeOnlyWeapons, 1, -1 do 
                    local weaponName = settings.MeleeOnlyWeapons[idx]
                    weapon = playerInventory:FindFirstChild(weaponName)
                    if weapon then 
                        break 
                    end
                end
                if weapon then
                    local resourceDamage = weapon:GetAttribute("WeaponResourceDamage") or 10
                    for _, character in ipairs(charactersFolder:GetChildren()) do
                        local isExcluded = false
                        for _, excludeName in ipairs(settings.excludedCharacters) do
                            if character.Name == excludeName then
                                isExcluded = true
                                break
                            end
                        end
                        if not isExcluded and character:FindFirstChild("HumanoidRootPart") then
                            local distance = (i.ROOT.Position - character.HumanoidRootPart.Position).Magnitude
                            if distance <= settings.KillAuraRange then
                                remotes.EIH:FireServer(weapon)
                                remotes.TDO:InvokeServer(character, weapon, resourceDamage, character.HumanoidRootPart.CFrame)
                                remotes.UEIH:FireServer(weapon)
                            end
                        end
                    end
                end
            end
        end
        -- chop aura
        if settings.ChopAura and FoliageFolder then
            local Character = i.LP.Character
            if not Character then return end
            local weapon = nil
            for _, weaponName in ipairs(settings.weaponaxesithink) do 
                weapon = Character:FindFirstChild(weaponName) or i.LP.Inventory:FindFirstChild(weaponName)
                if weapon then break end
            end
            if weapon then
                local resourceDamage = weapon:GetAttribute("WeaponResourceDamage") or 10
                local allowedTrees = {"Small Tree", "TreeBig1", "TreeBig2", "TreeBig3"}
                for _, tree in ipairs(FoliageFolder:GetChildren()) do
                    local trunk = tree:FindFirstChild("Trunk")
                    if table.find(allowedTrees, tree.Name) and trunk then
                        local distance = (i.ROOT.Position - trunk.Position).Magnitude
                        if distance <= settings.ChopAuraRange then
                            remotes.EIH:FireServer(weapon)
                            local response = remotes.TDO:InvokeServer(tree, weapon, resourceDamage, i.ROOT.CFrame)
                            if response then
                                local hitRegisters = tree:FindFirstChild("HitRegisters")
                                if hitRegisters then
                                    local registeredHealth = ClientModule.EnemyHandler.GetLocalHealthRegistered(hitRegisters)
                                    local currentHealth = tree:GetAttribute("Health") - registeredHealth
                                    if currentHealth <= 0 and tree.Parent ~= nil then
                                        ClientModule.Events.DestroyObject:Fire(tree, i.ROOT.CFrame)
                                    end
                                end
                            end
                            remotes.UEIH:FireServer(weapon)
                        end
                    end
                end
            end
        end
    end
end)
-- anti afk
RunService.RenderStepped:Connect(function()
    if settings.AntiAFKEnabled then
        for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
            v:Disable()
        end
    else
        for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
            v:Enable()
        end
    end
end)
-- ESP
task.spawn(function()
    local espFolder = workspace:FindFirstChild("OceanaX_ESP")
    if not espFolder then
        espFolder = Instance.new("Folder")
        espFolder.Name = "OceanaX_ESP"
        espFolder.Parent = workspace
    end
    local function ensureAttachment(part)
        if not part then return nil end
        local att = part:FindFirstChild("OceanaXTracerAttachment")
        if not att then
            att = Instance.new("Attachment")
            att.Name = "OceanaXTracerAttachment"
            att.Parent = part
        end
        return att
    end
    local function ensureLabel(cache, adornee, name, color)
        local gui = cache[adornee]
        if not gui or gui.Parent == nil then
            gui = Instance.new("BillboardGui")
            gui.Name = name
            gui.Size = UDim2.new(0, 200, 0, 50)
            gui.MaxDistance = 500
            gui.AlwaysOnTop = true
            gui.Adornee = adornee
            local t = Instance.new("TextLabel")
            t.BackgroundTransparency = 1
            t.TextScaled = true
            t.Size = UDim2.new(1, 0, 1, 0)
            t.TextColor3 = color
            t.Parent = gui
            gui.Parent = espFolder
            cache[adornee] = gui
        else
            gui.Adornee = adornee
        end
        return gui
    end
    local function ensureBeam(cache, key, name, color)
        local beam = cache[key]
        if not beam or beam.Parent == nil then
            beam = Instance.new("Beam")
            beam.Name = name
            beam.FaceCamera = true
            beam.LightInfluence = 0
            beam.Width0 = 0.08
            beam.Width1 = 0.08
            beam.Color = ColorSequence.new(color)
            beam.Parent = espFolder
            cache[key] = beam
        end
        return beam
    end
    local function destroyAllInCache(cache)
        for k, obj in pairs(cache) do
            if obj and obj.Parent ~= nil then
                obj:Destroy()
            end
            cache[k] = nil
        end
    end
    local charLabels = setmetatable({}, { __mode = "k" })
    local charBeams = setmetatable({}, { __mode = "k" })
    local playerLabels = setmetatable({}, { __mode = "k" })
    local playerBeams = setmetatable({}, { __mode = "k" })
    local itemLabels = setmetatable({}, { __mode = "k" })
    local itemBeams = setmetatable({}, { __mode = "k" })
    local childLabels = setmetatable({}, { __mode = "k" })
    local childBeams = setmetatable({}, { __mode = "k" })
    local campfireBeam = nil
    local campfireLabel = nil
    local seenCharacters = {}
    local seenItems = {}
    local seenChildren = {}
    while task.wait(0.1) do
        local i = char_info()
        if not i then continue end
        local localAttach = ensureAttachment(i.ROOT)
        if not localAttach then continue end
        seenCharacters = {}
        seenItems = {}
        seenChildren = {}
        if not settings.CharacterNames and not settings.CharacterTracers then
            destroyAllInCache(charLabels)
            destroyAllInCache(charBeams)
        end
        if not settings.PlayerNames and not settings.PlayerTracers then
            destroyAllInCache(playerLabels)
            destroyAllInCache(playerBeams)
        end
        if not settings.ItemNames and not settings.ItemTracers then
            destroyAllInCache(itemLabels)
            destroyAllInCache(itemBeams)
        end
        if not settings.ChildNames and not settings.ChildTracers then
            destroyAllInCache(childLabels)
            destroyAllInCache(childBeams)
        end
        if not settings.CampfireTracers and not settings.CampfireName then
            if campfireBeam and campfireBeam.Parent ~= nil then
                campfireBeam:Destroy()
                campfireBeam = nil
            end
            if campfireLabel and campfireLabel.Parent ~= nil then
                campfireLabel:Destroy()
                campfireLabel = nil
            end
        end
        if settings.CharacterNames or settings.CharacterTracers then
            for _, character in ipairs(charactersFolder:GetChildren()) do
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if humanoid and hrp and humanoid.Parent ~= i.LP.Character then
                    seenCharacters[hrp] = true
                    if settings.CharacterNames then
                        local gui = ensureLabel(charLabels, hrp, "ESPLabel", Color3.fromRGB(255, 0, 0))
                        local t = gui:FindFirstChildOfClass("TextLabel")
                        if t then t.Text = character.Name .. " [" .. math.floor(humanoid.Health) .. "HP]" end
                        gui.Enabled = true
                    else
                        local gui = charLabels[hrp]
                        if gui then gui.Enabled = false end
                    end
                    if settings.CharacterTracers then
                        local beam = ensureBeam(charBeams, hrp, "ESPTracer", Color3.fromRGB(255, 0, 0))
                        beam.Attachment0 = localAttach
                        beam.Attachment1 = ensureAttachment(hrp)
                        beam.Enabled = true
                    else
                        local beam = charBeams[hrp]
                        if beam then beam.Enabled = false end
                    end
                end
            end
            for hrp, _ in pairs(charLabels) do
                if not seenCharacters[hrp] then
                    local gui = charLabels[hrp]
                    if gui and gui.Parent ~= nil then gui:Destroy() end
                    charLabels[hrp] = nil
                end
            end
            for hrp, _ in pairs(charBeams) do
                if not seenCharacters[hrp] then
                    local beam = charBeams[hrp]
                    if beam and beam.Parent ~= nil then beam:Destroy() end
                    charBeams[hrp] = nil
                end
            end
        end
        if settings.PlayerNames or settings.PlayerTracers then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= i.LP then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if hrp and humanoid then
                        if settings.PlayerNames then
                            local gui = ensureLabel(playerLabels, hrp, "ESPPlayerLabel", Color3.fromRGB(0, 170, 255))
                            local t = gui:FindFirstChildOfClass("TextLabel")
                            if t then t.Text = plr.DisplayName .. " [" .. math.floor(humanoid.Health) .. "HP]" end
                            gui.Enabled = true
                        else
                            local gui = playerLabels[hrp]
                            if gui then gui.Enabled = false end
                        end
                        if settings.PlayerTracers then
                            local beam = ensureBeam(playerBeams, hrp, "ESPPlayerTracer", Color3.fromRGB(0, 170, 255))
                            beam.Attachment0 = localAttach
                            beam.Attachment1 = ensureAttachment(hrp)
                            beam.Enabled = true
                        else
                            local beam = playerBeams[hrp]
                            if beam then beam.Enabled = false end
                        end
                    end
                end
            end
        end
        if (settings.ItemNames or settings.ItemTracers) and itemsFolder then
            for _, item in ipairs(itemsFolder:GetChildren()) do
                local adornee = item:IsA("BasePart") and item or item.PrimaryPart
                if adornee then
                    seenItems[adornee] = true
                    if settings.ItemNames then
                        local gui = ensureLabel(itemLabels, adornee, "ESPItemLabel", Color3.fromRGB(0, 255, 0))
                        local t = gui:FindFirstChildOfClass("TextLabel")
                        if t then t.Text = item.Name end
                        gui.Enabled = true
                    else
                        local gui = itemLabels[adornee]
                        if gui then gui.Enabled = false end
                    end
                    if settings.ItemTracers then
                        local beam = ensureBeam(itemBeams, adornee, "ESPItemTracer", Color3.fromRGB(0, 255, 0))
                        beam.Attachment0 = localAttach
                        beam.Attachment1 = ensureAttachment(adornee)
                        beam.Enabled = true
                    else
                        local beam = itemBeams[adornee]
                        if beam then beam.Enabled = false end
                    end
                end
            end
            for adornee, _ in pairs(itemLabels) do
                if not seenItems[adornee] then
                    local gui = itemLabels[adornee]
                    if gui and gui.Parent ~= nil then gui:Destroy() end
                    itemLabels[adornee] = nil
                end
            end
            for adornee, _ in pairs(itemBeams) do
                if not seenItems[adornee] then
                    local beam = itemBeams[adornee]
                    if beam and beam.Parent ~= nil then beam:Destroy() end
                    itemBeams[adornee] = nil
                end
            end
        elseif not (settings.ItemNames or settings.ItemTracers) then
            destroyAllInCache(itemLabels)
            destroyAllInCache(itemBeams)
        end
        if settings.ChildNames or settings.ChildTracers then
            for _, character in ipairs(charactersFolder:GetChildren()) do
                local isChild = false
                for _, n in ipairs(settings.excludedCharacters) do
                    if character.Name == n then isChild = true break end
                end
                if isChild then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        seenChildren[hrp] = true
                        if settings.ChildNames then
                            local gui = ensureLabel(childLabels, hrp, "ESPChildLabel", Color3.fromRGB(255, 255, 0))
                            local t = gui:FindFirstChildOfClass("TextLabel")
                            if t then t.Text = character.Name end
                            gui.Enabled = true
                        else
                            local gui = childLabels[hrp]
                            if gui then gui.Enabled = false end
                        end
                        if settings.ChildTracers then
                            local beam = ensureBeam(childBeams, hrp, "ESPChildTracer", Color3.fromRGB(255, 255, 0))
                            beam.Attachment0 = localAttach
                            beam.Attachment1 = ensureAttachment(hrp)
                            beam.Enabled = true
                        else
                            local beam = childBeams[hrp]
                            if beam then beam.Enabled = false end
                        end
                    end
                end
            end
            for hrp, _ in pairs(childLabels) do
                if not seenChildren[hrp] then
                    local gui = childLabels[hrp]
                    if gui and gui.Parent ~= nil then gui:Destroy() end
                    childLabels[hrp] = nil
                end
            end
            for hrp, _ in pairs(childBeams) do
                if not seenChildren[hrp] then
                    local beam = childBeams[hrp]
                    if beam and beam.Parent ~= nil then beam:Destroy() end
                    childBeams[hrp] = nil
                end
            end
        elseif not (settings.ChildNames or settings.ChildTracers) then
            destroyAllInCache(childLabels)
            destroyAllInCache(childBeams)
        end
        if settings.CampfireTracers or settings.CampfireName then
            local map = workspace:FindFirstChild("Map")
            local campground = map and map:FindFirstChild("Campground")
            local mainFire = campground and campground:FindFirstChild("MainFire")
            local center = mainFire and mainFire:FindFirstChild("Center")
            if center and center:IsA("BasePart") then
                if settings.CampfireTracers then
                    if not campfireBeam or campfireBeam.Parent == nil then
                        campfireBeam = Instance.new("Beam")
                        campfireBeam.Name = "ESPCampfireTracer"
                        campfireBeam.FaceCamera = true
                        campfireBeam.LightInfluence = 0
                        campfireBeam.Width0 = 0.1
                        campfireBeam.Width1 = 0.1
                        campfireBeam.Color = ColorSequence.new(Color3.fromRGB(255, 140, 0))
                        campfireBeam.Parent = espFolder
                    end
                    campfireBeam.Attachment0 = localAttach
                    campfireBeam.Attachment1 = ensureAttachment(center)
                    campfireBeam.Enabled = true
                else
                    if campfireBeam then campfireBeam.Enabled = false end
                end
                if settings.CampfireName then
                    if not campfireLabel or campfireLabel.Parent == nil then
                        campfireLabel = Instance.new("BillboardGui")
                        campfireLabel.Name = "CampfireESPLabel"
                        campfireLabel.Size = UDim2.new(0, 200, 0, 50)
                        campfireLabel.MaxDistance = 500
                        campfireLabel.AlwaysOnTop = true
                        campfireLabel.Adornee = center
                        local t = Instance.new("TextLabel")
                        t.BackgroundTransparency = 1
                        t.TextScaled = true
                        t.Size = UDim2.new(1, 0, 1, 0)
                        t.TextColor3 = Color3.fromRGB(255, 140, 0)
                        t.Text = "Campfire"
                        t.Parent = campfireLabel
                        campfireLabel.Parent = espFolder
                    end
                    campfireLabel.Enabled = true
                else
                    if campfireLabel then campfireLabel.Enabled = false end
                end
            end
        end
    end
end)
-- plant orbit
RunService.RenderStepped:Connect(function()
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