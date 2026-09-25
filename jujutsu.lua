local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerList = {}
local CurrentTargetIndex = 1
local IsCycling = false
local OffsetDistance = 5 -- 타겟 뒤쪽으로 떨어질 거리

-- 플레이어 목록 업데이트 함수
local function UpdatePlayerList()
    PlayerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(PlayerList, player)
        end
    end
end

-- 텔레포트 실행 함수
local function TeleportToTarget()
    if #PlayerList == 0 then
        return
    end

    -- 인덱스 범위 확인
    if CurrentTargetIndex > #PlayerList then
        CurrentTargetIndex = 1
    elseif CurrentTargetIndex < 1 then
        CurrentTargetIndex = #PlayerList
    end

    local TargetPlayer = PlayerList[CurrentTargetIndex]

    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local TargetHRP = TargetPlayer.Character.HumanoidRootPart
        local MyHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if MyHRP then
            -- 타겟의 바라보는 방향의 반대쪽 계산
            local TargetLookVector = TargetHRP.CFrame.LookVector
            local NewPosition = TargetHRP.CFrame.Position - (TargetLookVector * OffsetDistance)
            
            -- 텔레포트 실행
            MyHRP.CFrame = CFrame.new(NewPosition, TargetHRP.Position)
        end
    end
end

-- 키 입력 이벤트 처리 (V키)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.V then
        IsCycling = not IsCycling
        
        if IsCycling then
            UpdatePlayerList()
            if #PlayerList > 0 then
                TeleportToTarget()
            end
        end
    end
end)

-- 루프 처리 (필요 시 업데이트)
RunService.Heartbeat:Connect(function()
    if IsCycling then
        -- 플레이어가 나갈 경우를 대비해 주기적으로 업데이트
        if tick() % 1 < 0.05 then
            UpdatePlayerList()
        end
    end
end)
