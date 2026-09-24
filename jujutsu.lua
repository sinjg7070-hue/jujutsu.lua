--[ Jujutsu.lua 통합 스크립트 ]--
-- 오류 방지용 로딩 대기
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- 1. UI 생성
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JujutsuUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.5, -100, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.Text = "Status: Idle (Press B to Target)"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Parent = Frame

-- 2. B 키 타겟팅 로직
local targeting = false
local targetLoop

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B then
        targeting = not targeting
        
        if targeting then
            Label.Text = "Status: Target Lock ON"
            targetLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local closest = nil
                    local dist = math.huge
                    
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local mag = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if mag < dist then
                                dist = mag
                                closest = p
                            end
                        end
                    end
                    
                    if closest then
                        char.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end)
        else
            Label.Text = "Status: Idle"
            if targetLoop then targetLoop:Disconnect() end
        end
    end
end)

print("스크립트가 성공적으로 로드되었습니다.")
