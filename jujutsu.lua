local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TeleportOffset = 0.3 -- 상대방 뒤 0.3칸
local CycleInterval = 0.2 -- 0.2초마다 변경

local lastCycleTime = 0
local currentIndex = 1

-- 순환 타겟팅 함수
local function GetNextPlayer()
    local players = Players:GetPlayers()
    local validPlayers = {}
    
    for _, p in pairs(players) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    
    -- 인덱스 순환
    currentIndex = (currentIndex % #validPlayers) + 1
    return validPlayers[currentIndex]
end

-- V키로 토글
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        currentIndex = 1 -- 켤 때마다 처음부터 다시 시작
    end
end)

-- 고속 루프 텔레포트 (0.2초마다 타겟 변경)
RunService.Heartbeat:Connect(function()
    if TargetMode then
        local currentTime = tick()
        
        -- 로컬 캐릭터 체크
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        -- 0.2초마다 타겟 변경 실행
        if (currentTime - lastCycleTime) >= CycleInterval then
            local targetPlayer = GetNextPlayer()
            
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = targetPlayer.Character.HumanoidRootPart
                local targetCFrame = targetPart.CFrame
                
                -- 상대방 뒤 0.3칸(TeleportOffset)으로 텔레포트
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetCFrame.Position + (targetCFrame.LookVector * -TeleportOffset), targetCFrame.Position)
            end
            
            lastCycleTime = currentTime
        end
    end
end)
