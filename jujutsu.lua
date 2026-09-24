-- 서비스 로드
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 상태 변수
local isFlying = false
local isTargeting = false
local flySpeed = 50

-- 1. 무지개 GUI 생성
local ScreenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.8, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Text = "주츠 시네니건 스크립트"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1

-- 무지개 효과 함수
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            TextLabel.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- 2. 비행 로직 (간소화)
local function toggleFly()
    isFlying = not isFlying
    if isFlying then
        -- 비행 모드 시작 시의 코드
        print("Fly 활성화")
    else
        -- 비행 모드 종료 시의 코드
        print("Fly 비활성화")
    end
end

-- 3. 타겟팅/텔레포트 로직 (가장 가까운 플레이어 추적)
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    return closestPlayer
end

-- 4. 키 입력 처리 (B키)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- B 키를 누를 때마다 기능 토글
    if input.KeyCode == Enum.KeyCode.B then
        isTargeting = not isTargeting
        if isTargeting then
            print("타겟팅 모드 ON: 가장 가까운 플레이어 추적")
        else
            print("타겟팅 모드 OFF")
        end
    end
end)

-- 핵심 루프
RunService.Heartbeat:Connect(function()
