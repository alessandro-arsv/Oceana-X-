-- alessandro using ai for everything 🥱✌

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ToolController = {}
ToolController.__index = ToolController

-- Default Stats
ToolController.Cooldown = 1
ToolController.Damage = 0

local LocalPlayer = Players.LocalPlayer
local ClientModule = require(LocalPlayer.PlayerScripts.Client)
local IsTutorialStepComplete = false

-- Constructor: Initialize a new tool instance
function ToolController.new(model, realModel)
    local self = setmetatable({}, ToolController)
    
    self.Model = model
    self.RealModel = realModel
    self.LastSwing = 0
    self.Equipped = false
    self.Broken = false
    
    -- Load attributes from the model or set defaults
    self:UpdateParams()
    
    return self
end

-- Refresh tool stats (Damage, Cooldown, etc.)
function ToolController.UpdateParams(self)
    local model = self.RealModel
    self.Damage = model:GetAttribute("WeaponDamage") or 10
    self.ResourceDamage = model:GetAttribute("WeaponResourceDamage") or 10
    self.Cooldown = model:GetAttribute("ToolCooldown") or 0.5
    self.KnockbackVertical = model:GetAttribute("WeaponKnockbackVertical")
    self.KnockbackHorizontal = model:GetAttribute("WeaponKnockbackHorizontal")
end

-- Handle tool durability breaking
function ToolController.Break(self)
    print("Tool broken locally")
    self.Broken = true
    ClientModule.InventoryHandler.ClearItemFromInventory(self.RealModel)
end

-- Main combat and harvesting logic
function ToolController.CheckHitbox(self)
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    if not rootPart then return end

    -- Internal function to handle what happens when something is hit
    local function onHit(hitTarget, targetData)
        if self.Broken then return end

        -- Visual & Sound Effects
        task.spawn(function()
            ClientModule.ToolModule.AddEnemyHitParticles(hitTarget)
        end)
        ClientModule.Events.PlayEnemyHitSound:FireAllClients(hitTarget, self.RealModel)

        -- Damage Logic
        task.spawn(function()
            local finalDamage = self.ResourceDamage
            
            -- Check if target is a living entity
            if targetData.Type == "Player" or targetData.Type == "NPC" then
                finalDamage = self.Damage
                ClientModule.Sound.Play("WeaponHit", {
                    Volume = 0.3,
                    Replicate = true,
                    ReplicationProperties = { Instance = character.Head, Volume = 0.4 }
                })
            end

            -- Multiplier for specific resources (e.g., Ice)
            local iceMult = self.RealModel:GetAttribute("IceDamageMultiplier")
            if iceMult and hitTarget:GetAttribute("Resource") == "IceBlock" then
                finalDamage = finalDamage * iceMult
            end

            -- Apply damage locally and notify server
            local damageAmount, onDeathCallback = ClientModule.EnemyHandler.ApplyLocalDamage(hitTarget, finalDamage)
            local serverResponse = ClientModule.Events.ToolDamageObject:InvokeServer(hitTarget, self.RealModel, damageAmount, rootPart.CFrame)
            
            -- If server rejects hit but client thought it killed it, run cleanup
            if not (serverResponse and serverResponse.Success) and onDeathCallback then
                onDeathCallback()
            end
        end)

        -- Resource Specific logic (Trees, Ice, Ore)
        if targetData.Type == "Resource" then
            local hitRegisters = hitTarget:FindFirstChild("HitRegisters")
            if hitRegisters then
                local currentHealth = hitTarget:GetAttribute("Health") - ClientModule.EnemyHandler.GetLocalHealthRegistered(hitRegisters)
                
                if currentHealth <= 0 then
                    self:HandleResourceBreak(hitTarget, rootPart)
                    return
                end
            end
            
            -- Play generic hit sounds if not broken yet
            local hitSound = "WoodChop"
            local resType = hitTarget:GetAttribute("Resource")
            if resType == "IceBlock" then hitSound = "IceHit"
            elseif resType == "MeteorNode" then hitSound = "MeteorNodeHit" end
            
            ClientModule.Sound.Play(hitSound, {
                Volume = 0.5, Replicate = true, Duplicate = true,
                ReplicationProperties = { Instance = character.Head, Volume = 0.4 }
            })
        end
    end

    -- Perform the physical hit detection
    task.spawn(function()
        local boxPos = rootPart.CFrame * CFrame.new(0, 0, -2) -- 2 studs in front of player
        ClientModule.ToolModule.BoxCast(boxPos, Vector3.new(6, 7, 7), nil, onHit, self.RealModel)
    end)
end

-- Helper: Handles effects when a resource is fully depleted
function ToolController.HandleResourceBreak(self, hitTarget, rootPart)
    -- Tutorial Logic
    if not IsTutorialStepComplete and hitTarget.Name == "Small Tree" and ClientModule.TutorialClient.currentID == 1 then
        IsTutorialStepComplete = true
        task.spawn(function()
            LocalPlayer.PlayerGui.Interface.TutorialLabel.Text = "Put wood on Fire until it reaches 100%"
        end)
    end

    -- Special Effects for Ice/Meteors
    local resType = hitTarget:GetAttribute("Resource")
    if resType == "IceBlock" then
        ClientModule.Sound.Play("IceBreak", { Volume = 0.55, Replicate = true, Duplicate = true, ReplicationProperties = { Instance = LocalPlayer.Character.Head, Volume = 0.4 }})
    elseif resType == "MeteorNode" then
        local particleName = (hitTarget.Name == "Obsidiron Node") and "BreakObsidiron" or "BreakMeteor"
        local soundName = (hitTarget.Name == "Obsidiron Node") and "ObsidionNodeBreak" or "MeteorNodeBreak"
        
        ClientModule.Sound.Play(soundName, { Volume = 0.5, Replicate = true, Duplicate = true, ReplicationProperties = { Instance = LocalPlayer.Character.Head, Volume = 0.4 }})
        
        local fx = ReplicatedStorage.Assets.Particles[particleName]:Clone()
        fx:PivotTo(hitTarget:GetPivot())
        fx.Parent = workspace.Particles
        for _, p in pairs(fx:GetDescendants()) do if p:IsA("ParticleEmitter") then p:Emit(p:GetAttribute("EmitCount") or 2) end end
        task.delay(5, function() fx:Destroy() end)
    end

    ClientModule.Events.DestroyObject:Fire(hitTarget, rootPart.CFrame)
end

-- Activate tool (Left Click)
function ToolController.Activate(self)
    if time() >= self.LastSwing + self.Cooldown then
        self.LastSwing = time()

        -- Animations & Sounds
        ClientModule.Events.PlayAnimation:Fire("SwingTool", { FadeTime = 0.05, Speed = 1.7 })
        ClientModule.Sound.Play("Swing", { Duplicate = true })
        ClientModule.FirstPersonModule.PlayAnimation("ToolSwing", 0.05, nil, 1.7)

        if self.Model.PrimaryPart:FindFirstChild("Swing") then
            ClientModule.ToolModule.PlayToolSound(self, self.Model.PrimaryPart.Swing)
        end

        -- Delay hitbox detection to match animation swing
        task.delay(0.1, function()
            if self.Equipped then
                self:CheckHitbox()
            end
        end)
    end
end

function ToolController.Deactivate(_) end

function ToolController.OnEquip(self)
    self.Equipped = true
    ClientModule.GuiButtonHandler.ShowButton("Swing")
end

function ToolController.OnUnequip(self)
    self.Equipped = false
    ClientModule.GuiButtonHandler.HideButton("Swing")
end

return ToolController