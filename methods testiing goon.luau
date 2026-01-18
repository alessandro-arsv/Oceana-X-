local function TeleportChests()
    local itemsFolder = workspace:FindFirstChild("Items")
    local allItems = {}

    if itemsFolder then
        allItems = itemsFolder:GetChildren()
    end

    local _LP = game.Players.LocalPlayer
    local _PP = _LP.Character:WaitForChild("HumanoidRootPart")

    for _, item in ipairs(allItems) do
        if item.Name:match("^Item Chest") then
            local args = { item }
            game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestStartDraggingItem"):FireServer(unpack(args))
            
            task.wait(0.5)
            
            if item:IsA("BasePart") then
                item.CFrame = _PP.CFrame + Vector3.new(0, 3, 0)
            elseif item:IsA("Model") and item.PrimaryPart then
                item:SetPrimaryPartCFrame(_PP.CFrame + Vector3.new(0, 3, 0))
            end
        end
    end
end

TeleportChests() 