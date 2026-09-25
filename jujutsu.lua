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

-- 순환 타겟팅 로직 (리스트를 매번 최신화)
local function GetNextPlayer()
    local allPlayers = Players:GetPlayers()
    local validPlayers = {}
    
    for _, p in pairs(allPlayers) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    
    -- 인덱스 범위를 초과하면 다시 1번으로
    if currentIndex > #validPlayers then
        currentIndex = 1
    end
    
    local target = validPlayers[currentIndex]
    currentIndex = currentIndex + 1
    
    return target
end

-- V키 토글
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        currentIndex = 1 -- 시작할 때마다 첫 번째 사람부터
        print("Target Mode: " .. tostring(TargetMode))
    end
end)

-- 루프 텔레포트
RunService.Heartbeat:Connect(function()
    if TargetMode then
        local currentTime = tick()
        
        if (currentTime - lastCycleTime) >= CycleInterval then
            local targetPlayer = GetNextPlayer()
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = targetPlayer.Character.HumanoidRootPart
                local targetCFrame = targetPart.CFrame
                
                -- 로컬 플레이어 텔레포트
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetCFrame.Position + (targetCFrame.LookVector * -TeleportOffset), targetCFrame.Position)
                end
            end
            
            lastCycleTime = currentTime
        end
    end
end)
