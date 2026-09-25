local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local TargetMode = false
local TargetKey = Enum.KeyCode.V
local TargetDistance = 0.1
local SwitchInterval = 0.2 -- 요청하신 대로 0.2초로 변경
local LastSwitchTime = 0

-- GUI 설정
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local targetIndex = 1

local function GetNextPlayer()
    local players = Players:GetPlayers()
    local validPlayers = {}
    for _, p in pairs(players) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlayers, p)
        end
    end
    
    if #validPlayers == 0 then return nil end
    
    if targetIndex > #validPlayers then targetIndex = 1 end
    local target = validPlayers[targetIndex]
    targetIndex = targetIndex + 1
    return target
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TargetKey then
        TargetMode = not TargetMode
        targetIndex = 1
    end
end)

local currentTarget = nil
RunService.Heartbeat:Connect(function()
    if TargetMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentTime = tick()
        
        -- 0.2초 간격으로 전환
        if (currentTime - LastSwitchTime) >= SwitchInterval or not currentTarget or not currentTarget.Character then
            currentTarget = GetNextPlayer()
            LastSwitchTime = currentTime
        end
        
        if currentTarget and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = currentTarget.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos.Position + (targetPos.LookVector * -TargetDistance), targetPos.Position)
        end
    end
end)
