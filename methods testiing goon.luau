-- Decompiled with Medal in Seliware

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = {}
v_u_2.__index = v_u_2
v_u_2.Cooldown = 1
v_u_2.Damage = 0
local v_u_3 = game.Players.LocalPlayer
local v_u_4 = require(v_u_3.PlayerScripts.Client)
v_u_3:GetMouse()
local v_u_5 = false
function v_u_2.new(p6, p7)
    -- upvalues: (copy) v_u_2
    local v8 = v_u_2
    local v9 = setmetatable({}, v8)
    v9.Model = p6
    v9.RealModel = p7
    v9.LastSwing = 0
    v9.Damage = p7:GetAttribute("WeaponDamage") or 10
    v9.ResourceDamage = p7:GetAttribute("WeaponResourceDamage") or 10
    v9.Cooldown = p7:GetAttribute("ToolCooldown") or 0.5
    v9.KnockbackVertical = p7:GetAttribute("WeaponKnockbackVertical")
    v9.KnockbackHorizontal = p7:GetAttribute("WeaponKnockbackHorizontal")
    return v9
end
function v_u_2.UpdateParams(p10)
    local v11 = p10.RealModel
    p10.Damage = v11:GetAttribute("WeaponDamage") or 10
    p10.ResourceDamage = v11:GetAttribute("WeaponResourceDamage") or 10
    p10.Cooldown = v11:GetAttribute("ToolCooldown") or 0.5
    p10.KnockbackVertical = v11:GetAttribute("WeaponKnockbackVertical")
    p10.KnockbackHorizontal = v11:GetAttribute("WeaponKnockbackHorizontal")
end
function v_u_2.Break(p12)
    -- upvalues: (copy) v_u_4
    print("time to break locally")
    p12.Broken = true
    v_u_4.InventoryHandler.ClearItemFromInventory(p12.RealModel)
end
function v_u_2.CheckHitbox(p_u_13)
    -- upvalues: (copy) v_u_3, (copy) v_u_4, (ref) v_u_5, (copy) v_u_1
    local v_u_14 = v_u_3.Character
    if v_u_14 then
        v_u_14 = v_u_3.Character:FindFirstChild("HumanoidRootPart")
    end
    if v_u_14 then
        local function v_u_28(p_u_15, p_u_16)
            -- upvalues: (copy) p_u_13, (ref) v_u_4, (ref) v_u_3, (copy) v_u_14, (ref) v_u_5, (ref) v_u_1
            if p_u_13.Broken ~= true then
                task.spawn(function()
                    -- upvalues: (ref) v_u_4, (copy) p_u_15
                    v_u_4.ToolModule.AddEnemyHitParticles(p_u_15)
                end)
                v_u_4.Events.PlayEnemyHitSound:FireAllClients(p_u_15, p_u_13.RealModel)
                task.spawn(function()
                    -- upvalues: (ref) p_u_13, (copy) p_u_16, (ref) v_u_4, (ref) v_u_3, (copy) p_u_15, (ref) v_u_14
                    local v17 = p_u_13.ResourceDamage
                    if p_u_16.Type == "Player" or p_u_16.Type == "NPC" then
                        v17 = p_u_13.Damage
                        v_u_4.Sound.Play("WeaponHit", {
                            ["Volume"] = 0.3,
                            ["Replicate"] = true,
                            ["ReplicationProperties"] = {
                                ["Instance"] = v_u_3.Character.Head,
                                ["Volume"] = 0.4
                            }
                        })
                    end
                    local v18 = p_u_13.RealModel:GetAttribute("IceDamageMultiplier")
                    if v18 and p_u_15:GetAttribute("Resource") == "IceBlock" then
                        v17 = v17 * v18
                    end
                    local v19, v20 = v_u_4.EnemyHandler.ApplyLocalDamage(p_u_15, v17)
                    
                    if not (v21 and v21.Success) and v20 then
                        v20()
                    end
                end)
                local v22 = p_u_16.Type == "Resource" and p_u_15:FindFirstChild("HitRegisters")
                if v22 then
                    if p_u_15:GetAttribute("Health") - v_u_4.EnemyHandler.GetLocalHealthRegistered(v22) <= 0 then
                        if not v_u_5 and (p_u_15.Name == "Small Tree" and v_u_4.TutorialClient.currentID == 1) then
                            v_u_5 = true
                            task.spawn(function()
                                -- upvalues: (ref) v_u_3
                                v_u_3:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("TutorialLabel").Text = "Put wood on Fire until it reaches 100%"
                            end)
                        end
                        if p_u_15:GetAttribute("Resource") == "IceBlock" then
                            v_u_4.Sound.Play("IceBreak", {
                                ["Volume"] = 0.55,
                                ["Replicate"] = true,
                                ["Duplicate"] = true,
                                ["ReplicationProperties"] = {
                                    ["Instance"] = v_u_3.Character.Head,
                                    ["Volume"] = 0.4
                                }
                            })
                        elseif p_u_15:GetAttribute("Resource") == "MeteorNode" then
                            if p_u_15.Name == "Obsidiron Node" then
                                v_u_4.Sound.Play("ObsidionNodeBreak", {
                                    ["Volume"] = 0.3,
                                    ["Replicate"] = true,
                                    ["Duplicate"] = true,
                                    ["ReplicationProperties"] = {
                                        ["Instance"] = v_u_3.Character.Head,
                                        ["Volume"] = 0.3
                                    }
                                })
                                local v_u_23 = v_u_1.Assets.Particles.BreakObsidiron:Clone()
                                v_u_23:PivotTo(p_u_15:GetPivot())
                                v_u_23.Parent = workspace.Particles
                                for _, v24 in pairs(v_u_23:GetDescendants()) do
                                    if v24:IsA("ParticleEmitter") then
                                        v24:Emit(v24:GetAttribute("EmitCount") or 2)
                                    end
                                end
                                task.spawn(function()
                                    -- upvalues: (copy) v_u_23
                                    wait(5)
                                    if v_u_23 then
                                        v_u_23:Destroy()
                                    end
                                end)
                            else
                                v_u_4.Sound.Play("MeteorNodeBreak", {
                                    ["Volume"] = 0.5,
                                    ["Replicate"] = true,
                                    ["Duplicate"] = true,
                                    ["ReplicationProperties"] = {
                                        ["Instance"] = v_u_3.Character.Head,
                                        ["Volume"] = 0.4
                                    }
                                })
                                local v_u_25 = v_u_1.Assets.Particles.BreakMeteor:Clone()
                                v_u_25:PivotTo(p_u_15:GetPivot())
                                v_u_25.Parent = workspace.Particles
                                for _, v26 in pairs(v_u_25:GetDescendants()) do
                                    if v26:IsA("ParticleEmitter") then
                                        v26:Emit(v26:GetAttribute("EmitCount") or 2)
                                    end
                                end
                                task.spawn(function()
                                    -- upvalues: (copy) v_u_25
                                    wait(5)
                                    if v_u_25 then
                                        v_u_25:Destroy()
                                    end
                                end)
                            end
                        end
                        v_u_4.Events.DestroyObject:Fire(p_u_15, v_u_14.CFrame)
                        return
                    end
                    local v27 = p_u_15:GetAttribute("Resource") == "IceBlock" and "IceHit" or (p_u_15:GetAttribute("Resource") == "MeteorNode" and "MeteorNodeHit" or "WoodChop")
                    v_u_4.Sound.Play(v27, {
                        ["Volume"] = 0.5,
                        ["Replicate"] = true,
                        ["Duplicate"] = true,
                        ["ReplicationProperties"] = {
                            ["Instance"] = v_u_3.Character.Head,
                            ["Volume"] = 0.4
                        }
                    })
                end
            end
        end
        task.spawn(function()
            -- upvalues: (copy) v_u_14, (ref) v_u_4, (copy) v_u_28, (copy) p_u_13
            local v29 = v_u_14.CFrame * CFrame.new(0, 0, -2)
            v_u_4.ToolModule.BoxCast(v29, Vector3.new(6, 7, 7), nil, v_u_28, p_u_13.RealModel)
        end)
    end
end
function v_u_2.Activate(p_u_30)
    -- upvalues: (copy) v_u_4
    if time() >= p_u_30.LastSwing + p_u_30.Cooldown then
        p_u_30.LastSwing = time()
        v_u_4.Events.PlayAnimation:Fire("SwingTool", {
            ["FadeTime"] = 0.05,
            ["Speed"] = 1.7
        })
        v_u_4.Sound.Play("Swing", {
            ["Duplicate"] = true
        })
        v_u_4.FirstPersonModule.PlayAnimation("ToolSwing", 0.05, nil, 1.7)
        if p_u_30.Model.PrimaryPart:FindFirstChild("Swing") then
            v_u_4.ToolModule.PlayToolSound(p_u_30, p_u_30.Model.PrimaryPart.Swing)
        end
        task.delay(0.1, function()
            -- upvalues: (copy) p_u_30
            if p_u_30.Equipped then
                p_u_30:CheckHitbox()
            end
        end)
    end
end
function v_u_2.Deactivate(_) end
function v_u_2.OnEquip(p31)
    -- upvalues: (copy) v_u_4
    p31.Equipped = true
    v_u_4.GuiButtonHandler.ShowButton("Swing")
end
function v_u_2.OnUnequip(p32)
    -- upvalues: (copy) v_u_4
    p32.Equipped = false
    v_u_4.GuiButtonHandler.HideButton("Swing")
end
return v_u_2
