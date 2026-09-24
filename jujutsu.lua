-- 지환 zxxdaswo 주츠 시네니건 스크립트
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [1] 무지개 UI 생성
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local TextLabel = Instance.new("TextLabel", ScreenGui)
TextLabel.Size = UDim2.new(0, 300, 0, 50)
TextLabel.Position = UDim2.new(1, -320, 0, 20)
TextLabel.Text = "주츠 시네니건 스크립트 개발: 지환 zxxdaswo"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18

spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            TextLabel.TextColor3 = Color3.fromHSV(i, 1, 1)
            wait(0.05)
        end
    end
end)

-- [2] 비행 기능
local Flying = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil

LocalPlayer.Chatted:Connect(function(msg)
    if msg == ";fly" then
        Flying = not Flying
        local character = LocalPlayer.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        
        if Flying then
            BodyVelocity = Instance.new("BodyVelocity", root)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyGyro = Instance.new("BodyGyro", root)
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.CFrame = root.CFrame
        else
            if BodyVelocity then BodyVelocity:Destroy() end
            if BodyGyro then BodyGyro:Destroy() end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        BodyVelocity.Velocity = (camera.CFrame.LookVector * (Mouse.Hit.p - root.Position).Unit * FlySpeed)
        BodyGyro.CFrame = camera.CFrame
    end
end)

