-- jujutsu.lua 통합 스크립트 (거리 유지 + 회피 모드)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI 설정
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.8, 0, 0.5, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Active = true
Frame.Draggable = true

local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.TextColor3 = Color3.new(1, 1, 1)
Label.Text = "Jujutsu Script Loaded"

-- 무지개 효과
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Label.TextColor3 = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- 타겟팅 변수
local targeting = false
local targetLoop = nil

-- B 키 타겟팅 (거리 유지 및 회피 로직)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B then
        targeting = not targeting
        if targeting then
            Label.Text = "Targeting: ON (Evasion Mode)"
            targetLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local closest, dist = nil, 9999
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist then dist = d; closest = p end
                        end
                    end
                    
                    if closest then
                        -- [핵심] 상대와 10스터드(Studs) 거리를 유지하며 상대를 바라봄
                        -- Y축(높이)은 상대와 비슷하게 유지하여 공격이 빗나가지 않게 함
                        local targetPos = closest.Character.HumanoidRootPart.CFrame
                        char.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 0, 10) -- 여기서 10을 조절하면 거리가 변함
                        
                        -- 공격을 위한 바라보기
                        char.HumanoidRootPart.CFrame = CFrame.lookAt(char.HumanoidRootPart.Position, targetPos.Position)
                    end
                end
            end)
        else
            Label.Text = "Targeting: OFF"
            if targetLoop then targetLoop:Disconnect() end
        end
    end
end)
