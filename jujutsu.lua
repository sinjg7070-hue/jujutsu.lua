local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TargetDistance = 0.1 -- 거리는 거의 딱 붙게 유지
local SwitchInterval = 0.1 -- 몇 초마다 다음 사람으로 넘어갈지 설정 (0.1초)
local LastSwitchTime = 0

-- GUI 설정 (생략 가능하지만 기존 구조 유지)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

-- 타겟팅을 위한 플레이어 인덱스
local targetIndex = 1

-- 순환 타겟팅 함수
local function GetNextPlayer()
    local players = Players:GetPlayers()
    -- 로컬 플레이어 제외하고 리스트 정리
    local validPlayers = {}
    for _, p in pairs(players) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    
    -- 인덱스 관리 (리스트 끝에 도달하면 처음으로)
    if targetIndex > #validPlayers then targetIndex = 1 end
    local target = validPlayers[targetIndex]
    targetIndex = targetIndex + 1
    return target
end

-- V키 토글
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        targetIndex = 1 -- 켤 때마다 처음부터 다시 시작
    end
end)

-- 매 프레임 업데이트
local currentTarget = nil
RunService.Heartbeat:Connect(function()
    if TargetMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentTime = tick()
        
        -- 일정 시간(0.1초)이 지났거나 타겟이 없으면 다음 사람으로 전환
        if (currentTime - LastSwitchTime) >= SwitchInterval or not currentTarget or not currentTarget.Character then
            currentTarget = GetNextPlayer()
            LastSwitchTime = currentTime
        end
        
        if currentTarget and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = currentTarget.Character.HumanoidRootPart.CFrame
            -- 대상에게 TP
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + (targetPos.LookVector * -TargetDistance), targetPos.Position)
        end
    end
end)
