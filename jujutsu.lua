local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TargetDistance = 18 -- 거리값

-- GUI 설정
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local DistanceInput = Instance.new("TextBox", MainFrame)
DistanceInput.Size = UDim2.new(0, 180, 0, 30)
DistanceInput.Position = UDim2.new(0, 10, 0, 35)
DistanceInput.PlaceholderText = "거리를 입력하세요 (현재: " .. TargetDistance .. ")"
DistanceInput.Text = tostring(TargetDistance)

DistanceInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        TargetDistance = tonumber(DistanceInput.Text) or 18
    end
end)

-- 타겟팅 로직 (No-Delay)
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
            -- 상대방 뒤쪽 위치 계산 (Offset)
            local offset = targetPos.LookVector * -TargetDistance
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + offset, targetPos.Position)
        end
    end
end)
