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
local currentTarget = nil

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
        currentTarget = nil 
        print("Target Mode: " .. tostring(TargetMode))
    end
end)

-- 루프 텔레포트
RunService.Heartbeat:Connect(function()
    if TargetMode then
        local currentTime = tick()
        
        -- 일정 시간마다 타겟 변경
        if (currentTime - lastCycleTime) >= CycleInterval then
            currentTarget = GetNextPlayer()
            lastCycleTime = currentTime
        end
        
        -- 현재 타겟에게 지속적으로 텔레포트
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetPart = currentTarget.Character.HumanoidRootPart
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if myRoot then
                -- 타겟 위치로 텔레포트 (물리 고정 로직 제거)
                myRoot.CFrame = CFrame.new(targetPart.CFrame.Position + (targetPart.CFrame.LookVector * -TeleportOffset), targetPart.CFrame.Position)
            end
        end
    end
end)
