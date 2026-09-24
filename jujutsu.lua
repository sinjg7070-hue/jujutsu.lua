local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 기존 GUI 삭제 (중복 방지)
if game.CoreGui:FindFirstChild("JujutsuScript") then
    game.CoreGui.JujutsuScript:Destroy()
end

-- GUI 생성
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "JujutsuScript"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Jujutsu Script (V to Toggle)"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

-- 거리 입력창
local RangeLabel = Instance.new("TextLabel", MainFrame)
RangeLabel.Size = UDim2.new(0, 80, 0, 30)
RangeLabel.Position = UDim2.new(0, 10, 0, 50)
RangeLabel.Text = "Range:"
RangeLabel.BackgroundTransparency = 1
RangeLabel.TextColor3 = Color3.new(1, 1, 1)

local RangeBox = Instance.new("TextBox", MainFrame)
RangeBox.Size = UDim2.new(0, 80, 0, 30)
RangeBox.Position = UDim2.new(0, 100, 0, 50)
RangeBox.Text = "18" -- 초기값
RangeBox.PlaceholderText = "18"

-- 로직 상태
local Enabled = false
local RainbowSpeed = 0.05

-- 무지개 효과
RunService.RenderStepped:Connect(function()
    local hue = tick() % 5 / 5
    MainFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- 가장 가까운 플레이어 찾기
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- V 키로 토글
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.V then
        Enabled = not Enabled
        print("Targeting Mode: " .. (Enabled and "ON" or "OFF"))
    end
end)

-- 핵심 루프
RunService.Heartbeat:Connect(function()
    if Enabled then
        local closest = getClosestPlayer()
        if closest and closest.Character and closest.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local targetPos = closest.Character.HumanoidRootPart.CFrame
            local charRoot = LocalPlayer.Character.HumanoidRootPart
            
            -- 입력창에서 거리 가져오기 (숫자가 아니면 18 사용)
            local dist = tonumber(RangeBox.Text) or 18
            
            -- 위치 이동 및 바라보기
            charRoot.CFrame = targetPos * CFrame.new(0, 0, dist)
            charRoot.CFrame = CFrame.lookAt(charRoot.Position, closest.Character.HumanoidRootPart.Position)
        end
    end
end)
