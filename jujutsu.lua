local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TargetDistance = 0.1 -- 타겟과의 거리

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true

local currentTarget = nil

-- 타겟 변경 함수
local function GetNextPlayer()
    local players = Players:GetPlayers()
    local validPlayers = {}
    
    for _, p in pairs(players) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    
    -- 현재 타겟 다음 사람 찾기
    local currentIndex = 1
    if currentTarget then
        for i, p in pairs(validPlayers) do
            if p == currentTarget then
                currentIndex = i + 1
                break
            end
        end
    end
    
    if currentIndex > #validPlayers then currentIndex = 1 end
    return validPlayers[currentIndex]
end

-- V키로 토글 및 타겟 변경
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        if TargetMode then
            currentTarget = GetNextPlayer() -- 켜질 때 타겟 설정
        else
            currentTarget = nil -- 꺼지면 타겟 해제
        end
    end
end)

-- 루프 텔레포트 로직
RunService.Heartbeat:Connect(function()
    if TargetMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- 타겟이 유효한지 확인 (죽었거나 나갔는지)
        if not currentTarget or not currentTarget.Character or not currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            currentTarget = GetNextPlayer()
        end
        
        -- 루프 텔레포트 실행
        if currentTarget and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = currentTarget.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + (targetPos.LookVector * -TargetDistance), targetPos.Position)
        end
    end
end)
