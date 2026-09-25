-- ========================================
-- 서버 플레이어 순환 텔레포트 스크립트 (오픈소스)
-- 기능: V 키로 토글, 0.2초마다 다음 플레이어의 뒤쪽 0.5칸으로 텔레포트
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========================================
-- 설정
-- ========================================
local CONFIG = {
    ToggleKey = Enum.KeyCode.V,        -- 활성화/비활성화 토글 키
    SwitchInterval = 0.2,               -- 다음 플레이어로 전환 주기 (초)
    OffsetDistance = 5,                 -- 대상 뒤로 떨어질 거리 (studs, 약 0.5칸)
    OffsetHeight = 0                    -- 높이 오프셋 (필요시 조정)
}

-- ========================================
-- 변수
-- ========================================
local player = Players.LocalPlayer
local isLooping = false
local currentTargetIndex = 1
local lastSwitchTime = tick()

-- ========================================
-- 유틸리티 함수
-- ========================================

-- 플레이어의 캐릭터와 HumanoidRootPart를 안전하게 가져오기
local function getCharacterParts()
    local character = player.Character
    if not character then return nil, nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    return character, humanoidRootPart
end

-- 텔레포트 가능한 타겟 목록 생성 (자신 제외)
local function getValidTargets()
    local targets = {}
    local playerList = Players:GetPlayers()
    
    for _, targetPlayer in ipairs(playerList) do
        if targetPlayer ~= player then
            local targetChar = targetPlayer.Character
            if targetChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    table.insert(targets, {
                        Player = targetPlayer,
                        RootPart = targetRoot
                    })
                end
            end
        end
    end
    
    return targets
end

-- 타겟의 뒤쪽 위치 계산 (타겟이 바라보는 반대 방향)
local function calculateBehindPosition(targetCFrame, distance, heightOffset)
    -- LookVector의 반대 방향으로 거리만큼 이동
    local behindOffset = -targetCFrame.LookVector * distance
    local heightOffsetVector = Vector3.new(0, heightOffset, 0)
    
    -- 타겟의 회전은 유지하되 위치만 뒤로 이동
    return targetCFrame + behindOffset + heightOffsetVector
end

-- ========================================
-- 키 입력 처리
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- UI 입력 중이면 무시
    if gameProcessed then return end
    
    if input.KeyCode == CONFIG.ToggleKey then
        isLooping = not isLooping
        
        -- 상태 메시지 출력
        if isLooping then
            print("✅ [순환 텔레포트] 활성화됨")
            currentTargetIndex = 1  -- 인덱스 초기화
        else
            print("❌ [순환 텔레포트] 비활성화됨")
        end
    end
end)

-- ========================================
-- 메인 루프 (Heartbeat - 매 프레임마다 실행)
-- ========================================
RunService.Heartbeat:Connect(function()
    if not isLooping then return end
    
    -- 시간 체크 (설정된 간격마다만 실행)
    local currentTime = tick()
    if currentTime - lastSwitchTime < CONFIG.SwitchInterval then
        return
    end
    
    -- 캐릭터 유효성 검사
    local character, humanoidRootPart = getCharacterParts()
    if not humanoidRootPart then
        warn("⚠️ HumanoidRootPart를 찾을 수 없습니다.")
        return
    end
    
    -- 텔레포트 가능한 타겟 목록 가져오기
    local targets = getValidTargets()
    
    if #targets == 0 then
        warn("⚠️ 텔레포트 가능한 플레이어가 없습니다.")
        return
    end
    
    -- 인덱스 순환 처리
    if currentTargetIndex > #targets then
        currentTargetIndex = 1
    end
    
    -- 현재 타겟 선택
    local targetData = targets[currentTargetIndex]
    local targetRootPart = targetData.RootPart
    
    -- 타겟 뒤쪽 위치 계산
    local behindPosition = calculateBehindPosition(
        targetRootPart.CFrame,
        CONFIG.OffsetDistance,
        CONFIG.OffsetHeight
    )
    
    -- 텔레포트 실행 (로컬만 적용됨, FE 게임에서는 서버 동기화 안 됨)
    humanoidRootPart.CFrame = behindPosition
    
    -- 디버그 출력 (옵션)
    -- print(string.format("📍 [%d/%d] %s 뒤로 텔레포트", currentTargetIndex, #targets, targetData.Player.Name))
    
    -- 다음 타겟으로 이동
    currentTargetIndex = currentTargetIndex + 1
    lastSwitchTime = currentTime
end)

-- ========================================
-- 캐릭터 리스폰 처리
-- ========================================
player.CharacterAdded:Connect(function(newCharacter)
    -- 캐릭터가 새로 생성될 때마다 참조 갱신
    character = newCharacter
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    print("🔄 캐릭터가 리스폰되었습니다. 스크립트가 계속 작동합니다.")
end)

print("✨ 순환 텔레포트 스크립트 로드 완료")
print("📌 V 키를 눌러 활성화/비활성화할 수 있습니다.")
