local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TeleportOffset = 0.3
local CycleInterval = 0.2

local lastCycleTime = 0
local currentIndex = 1

local function GetNextPlayer()
    local allPlayers = Players:GetPlayers()
    local validPlayers = {}
    
    for _, p in pairs(allPlayers) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    if currentIndex > #validPlayers then currentIndex = 1 end
    
    local target = validPlayers[currentIndex]
    currentIndex = currentIndex + 1
    return target
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        currentIndex = 1
        print("Target Mode: " .. tostring(TargetMode))
    end
end)

RunService.Heartbeat:Connect(function()
    if TargetMode then
        local currentTime = tick()
        
        if (currentTime - lastCycleTime) >= CycleInterval then
            local targetPlayer = GetNextPlayer()
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = targetPlayer.Character.HumanoidRootPart
                local targetCFrame = targetPart.CFrame
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- 텔레포트 전후로 물리적인 충돌을 일시적으로 무시하거나 위치를 강제 고정하는 효과
                    local myRoot = LocalPlayer.Character.HumanoidRootPart
                    
                    -- CFrame을 target 뒤쪽으로 설정
                    myRoot.CFrame = CFrame.new(targetCFrame.Position + (targetCFrame.LookVector * -TeleportOffset), targetCFrame.Position)
                    
                    -- 일부 게임에서는 Velocity를 0으로 만들어야 튕기는 것을 방지함
                    myRoot.Velocity = Vector3.new(0, 0, 0)
                    myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
            
            lastCycleTime = currentTime
        end
    end
end)
