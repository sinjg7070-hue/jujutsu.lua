-- 로블록스 텔레포트 스크립트 (최종 통합 버전)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 설정 변수
local TargetMode = false
local CurrentTarget = nil
local CycleInterval = 0.2 -- 타겟 순환 간격 (초)
local TeleportInterval = 0.15 -- 텔레포트 실행 간격 (0.1~0.3 사이 조정 가능)
local TeleportOffset = 0.3 -- 타겟 뒤쪽으로 떨어진 거리 (스터드)
local currentIndex = 0

-- 타이머 변수
local lastCycleTime = 0
local lastTeleportTime = 0

-- 다음 플레이어 찾기 함수
local function GetNextPlayer()
    local allPlayers = Players:GetPlayers()
    local validPlayers = {}
    
    for _, player in ipairs(allPlayers) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(validPlayers, player)
            end
        end
    end
    
    if #validPlayers == 0 then
        return nil
    end
    
    currentIndex = currentIndex + 1
    if currentIndex > #validPlayers then
        currentIndex = 1
    end
    
    return validPlayers[currentIndex]
end

-- 메인 루프
RunService.Heartbeat:Connect(function()
    if TargetMode then
        local currentTime = tick()
        
        -- 타겟 순환 (0.2초마다)
        if currentTime - lastCycleTime >= CycleInterval then
            CurrentTarget = GetNextPlayer()
            lastCycleTime = currentTime
        end
        
        -- 텔레포트 실행 (TeleportInterval마다)
        if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
            if currentTime - lastTeleportTime >= TeleportInterval then
                local targetHRP = CurrentTarget.Character.HumanoidRootPart
                local targetCFrame = targetHRP.CFrame
                local offsetPosition = targetCFrame * CFrame.new(0, 0, TeleportOffset)
                
                HumanoidRootPart.CFrame = offsetPosition
                
                lastTeleportTime = currentTime
            end
        end
    end
end)

-- V 키 입력 처리
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    
    if input.KeyCode == Enum.KeyCode.V then
        TargetMode = not TargetMode
        
        if TargetMode then
            print("텔레포트 모드 활성화")
            currentIndex = 0
            lastCycleTime = 0
            lastTeleportTime = 0
        else
            print("텔레포트 모드 비활성화")
            CurrentTarget = nil
        end
    end
end)

print("스크립트 로드 완료. V 키를 눌러 텔레포트 모드를 토글하세요.")
