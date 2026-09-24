local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TargetDistance = 18 -- 기본 거리값

-- GUI 설정
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local DistanceInput = Instance.new("TextBox", MainFrame)
DistanceInput.Size = UDim2.new(0, 180, 0, 30)
DistanceInput.Position = UDim2.new(0, 10, 0, 35)
DistanceInput.PlaceholderText = "거리 입력 (엔터 또는 클릭 해제)"
DistanceInput.Text = tostring(TargetDistance)

-- [수정됨] 포커스를 잃을 때마다(클릭 해제 시) 값이 무조건 업데이트되도록 변경
DistanceInput.FocusLost:Connect(function()
    local newVal = tonumber(DistanceInput.Text)
    if newVal then
        TargetDistance = newVal
        DistanceInput.Text = tostring(TargetDistance) -- 입력값 확인용 업데이트
    else
        DistanceInput.Text = tostring(TargetDistance) -- 잘못된 입력 시 복구
    end
end)

-- 타겟팅 로직
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                closestPlayer = player
                shortestDistance = dist
            end
        end
    end
    return closestPlayer
end

-- V키 토글
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
    end
end)

-- 매 프레임 업데이트
RunService.Heartbeat:Connect(function()
    if TargetMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = GetClosestPlayer()
        if target and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.CFrame
            -- 상대방 뒤쪽 위치 계산
            local offset = targetPos.LookVector * -TargetDistance
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + offset, targetPos.Position)
        end
    end
end)
