-- jujutsu.lua 통합 스크립트 (No-Delay 타겟팅 포함)
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

-- B 키 타겟팅 (노 딜레이)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.B then
        targeting = not targeting
        if targeting then
            Label.Text = "Targeting: ON (No Delay)"
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
                        -- 즉시 이동
                        char.HumanoidRootPart.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end)
        else
            Label.Text = "Targeting: OFF"
            if targetLoop then targetLoop:Disconnect() end
        end
    end
end)

-- 채팅 명령어 처리 (간략화)
LocalPlayer.Chatted:Connect(function(msg)
    if msg == ";fly" then
        Label.Text = "Command: Fly Enabled"
        -- 비행 로직 추가 영역
    elseif msg == ";gojo kill farm" then
        Label.Text = "Command: Kill Farm Active"
        -- 파밍 로직 추가 영역
    end
end)
