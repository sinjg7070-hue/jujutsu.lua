local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PositionMarkerGui"
gui.ResetOnSpawn = false

-- 기본 창 크기 및 한 칸당 높이 설정
local baseHeight = 350
local rowHeight = 45

-- 메인 창 크기 및 위치 설정
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, baseHeight)
frame.Position = UDim2.new(0.5, -210, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

-- 창 드래그 기능
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)


--------------------------------------------------
-- [왼쪽 열] 상단 고정 버튼들 (AFK, 플라이, 풀브라이트)
--------------------------------------------------

local afkBtn = Instance.new("TextButton", frame)
afkBtn.Size = UDim2.new(0, 120, 0, 35)
afkBtn.Position = UDim2.new(0, 10, 0, 15)
afkBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
afkBtn.Text = "Auto AFK: OFF"
afkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
afkBtn.TextSize = 13
afkBtn.Font = Enum.Font.SourceSansBold

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0, 120, 0, 35)
flyBtn.Position = UDim2.new(0, 10, 0, 55)
flyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
flyBtn.Text = "플라이: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextSize = 13
flyBtn.Font = Enum.Font.SourceSansBold

local brightBtn = Instance.new("TextButton", frame)
brightBtn.Size = UDim2.new(0, 120, 0, 35)
brightBtn.Position = UDim2.new(0, 10, 0, 95)
brightBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
brightBtn.Text = "밝게 빛나기: OFF"
brightBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
brightBtn.TextSize = 13
brightBtn.Font = Enum.Font.SourceSansBold


--------------------------------------------------
-- [중앙~오른쪽] 상단 플라이 속도 조절 설정
--------------------------------------------------

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 130, 0, 35)
speedLabel.Position = UDim2.new(0, 140, 0, 15)
speedLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedLabel.Text = "플라이 속도:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.SourceSansBold

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 120, 0, 35)
speedBox.Position = UDim2.new(0, 280, 0, 15)
speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 14
speedBox.Font = Enum.Font.SourceSansBold
speedBox.ClearTextOnFocus = false


--------------------------------------------------
-- 동적 좌표 관리 시스템 (텔레포트, 저장, 이름, 삭제 한 줄 세트)
--------------------------------------------------

local coordinates = {} 
local startY = 145 -- 첫 번째 좌표 세트가 시작되는 Y 위치

local function createCoordinateRow(index)
	local currentY = startY + ((index - 1) * rowHeight)
	
	-- 1. 왼쪽: 수동 텔레포트 버튼
	local tpBtn = Instance.new("TextButton", frame)
	tpBtn.Size = UDim2.new(0, 120, 0, 35)
	tpBtn.Position = UDim2.new(0, 10, 0, currentY)
	tpBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
	tpBtn.Text = index .. "번째 텔레포트"
	tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tpBtn.TextSize = 13
	tpBtn.Font = Enum.Font.SourceSansBold
	
	-- 2. 중앙: 좌표 저장 버튼
	local saveBtn = Instance.new("TextButton", frame)
	saveBtn.Size = UDim2.new(0, 130, 0, 35)
	saveBtn.Position = UDim2.new(0, 140, 0, currentY)
	saveBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	saveBtn.Text = index .. "번째 좌표 저장"
	saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveBtn.TextSize = 13
	saveBtn.Font = Enum.Font.SourceSansBold
	
	-- 3. 오른쪽: 이름 입력창
	local nameBox = Instance.new("TextBox", frame)
	nameBox.Size = UDim2.new(0, 60, 0, 35)
	nameBox.Position = UDim2.new(0, 280, 0, currentY)
	nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	nameBox.Text = "이름" .. index
	nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameBox.TextSize = 13
	nameBox.Font = Enum.Font.SourceSansBold
	nameBox.ClearTextOnFocus = false
	
	-- 4. 오른쪽 끝: 개별 삭제 버튼
	local deleteBtn = Instance.new("TextButton", frame)
	deleteBtn.Size = UDim2.new(0, 55, 0, 35)
	deleteBtn.Position = UDim2.new(0, 345, 0, currentY)
	deleteBtn.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
	deleteBtn.Text = "삭제"
	deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	deleteBtn.TextSize = 12
	deleteBtn.Font = Enum.Font.SourceSansBold
	
	local data = {
		cframe = nil,
		marker = nil,
		tpBtn = tpBtn,
		saveBtn = saveBtn,
		nameBox = nameBox,
		deleteBtn = deleteBtn
	}
	
	-- 좌표 저장 이벤트
	saveBtn.MouseButton1Click:Connect(function()
		local char = player.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local rootPart = char.HumanoidRootPart
		
		data.cframe = rootPart.CFrame
		if data.marker then data.marker:Destroy() end
		
		data.marker = Instance.new("Part")
		data.marker.Size = Vector3.new(3, 1, 3)
		data.marker.Position = rootPart.Position - Vector3.new(0, 3, 0)
		data.marker.Anchored = true
		data.marker.CanCollide = false
		data.marker.BrickColor = BrickColor.random()
		data.marker.Material = Enum.Material.Neon
		data.marker.Parent = workspace
		
		local customName = nameBox.Text
		tpBtn.Text = customName
	end)
	
	-- 텔레포트 이벤트
	tpBtn.MouseButton1Click:Connect(function()
		if not data.cframe then return end
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = data.cframe
		end
	end)
	
	-- 개별 삭제 이벤트
	deleteBtn.MouseButton1Click:Connect(function()
		data.cframe = nil
		if data.marker then
			data.marker:Destroy()
			data.marker = nil
		end
		tpBtn.Text = index .. "번째 텔레포트"
	end)
	
	table.insert(coordinates, data)
	return currentY + rowHeight
end

-- 기본 1번, 2번 좌표 생성
local nextY = createCoordinateRow(1)
nextY = createCoordinateRow(2)

-- 플러스(+) 버튼 생성
local addBtn = Instance.new("TextButton", frame)
addBtn.Size = UDim2.new(0, 120, 0, 35)
addBtn.Position = UDim2.new(0, 140, 0, nextY + 5)
addBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
addBtn.Text = "+ 좌표 추가"
addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addBtn.TextSize = 14
addBtn.Font = Enum.Font.SourceSansBold

-- 모든 좌표 삭제 버튼 생성 (플러스 버튼 아래에 배치)
local deleteAllBtn = Instance.new("TextButton", frame)
deleteAllBtn.Size = UDim2.new(0, 120, 0, 35)
deleteAllBtn.Position = UDim2.new(0, 140, 0, nextY + 45)
deleteAllBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
deleteAllBtn.Text = "모든 좌표 삭제"
deleteAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteAllBtn.TextSize = 13
deleteAllBtn.Font = Enum.Font.SourceSansBold

-- 메인 창 크기 업데이트 함수
local function updateFrameSize()
	local totalRows = #coordinates
	local newHeight = startY + (totalRows * rowHeight) + 95
	frame.Size = UDim2.new(0, 420, 0, newHeight)
end
updateFrameSize()

-- 플러스 버튼 클릭 시 새로운 좌표 세트 추가
addBtn.MouseButton1Click:Connect(function()
	local newIndex = #coordinates + 1
	local finalY = createCoordinateRow(newIndex)
	
	-- 플러스 버튼 및 전체 삭제 버튼 위치 아래로 재배치
	addBtn.Position = UDim2.new(0, 140, 0, finalY + 5)
	deleteAllBtn.Position = UDim2.new(0, 140, 0, finalY + 45)
	
	-- 메인 창 크기 늘리기
	updateFrameSize()
end)


--------------------------------------------------
-- 기타 부가 기능 로직 (AFK, 밝기, 플라이, 전체 삭제)
--------------------------------------------------

-- Auto AFK 기능
local autoAfkEnabled = false
afkBtn.MouseButton1Click:Connect(function()
	autoAfkEnabled = not autoAfkEnabled
	if autoAfkEnabled then
		afkBtn.Text = "Auto AFK: ON"
		afkBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	else
		afkBtn.Text = "Auto AFK: OFF"
		afkBtn.BackgroundColor3 = Color3.fromRGB(127, 140, 141)
	end
end)

task.spawn(function()
	while true do
		task.wait(50)
		if autoAfkEnabled then
			local char = player.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

-- 밤에 밝게 빛나기 기능 (FullBright)
local brightEnabled = false
local lighting = game:GetService("Lighting")
local originalClockTime = lighting.ClockTime
local originalBrightness = lighting.Brightness
local originalOutdoorAmbient = lighting.OutdoorAmbient

brightBtn.MouseButton1Click:Connect(function()
	brightEnabled = not brightEnabled
	if brightEnabled then
		brightBtn.Text = "밝게 빛나기: ON"
		brightBtn.BackgroundColor3 = Color3.fromRGB(243, 156, 18)
		lighting.ClockTime = 14
		lighting.Brightness = 2
		lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	else
		brightBtn.Text = "밝게 빛나기: OFF"
		brightBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
		lighting.ClockTime = originalClockTime
		lighting.Brightness = originalBrightness
		lighting.OutdoorAmbient = originalOutdoorAmbient
	end
end)

-- 플라이 기능
local flyEnabled = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local bg, bv

flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then
		flyEnabled = false
		return
	end
	
	local hrp = char.HumanoidRootPart
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	
	if flyEnabled then
		flyBtn.Text = "플라이: ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		
		bg = Instance.new("BodyGyro", hrp)
		bg.P = 9e4
		bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
		
		bv = Instance.new("BodyVelocity", hrp)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
		
		if humanoid then humanoid.PlatformStand = true end
		
		task.spawn(function()
			while flyEnabled do
				rs.RenderStepped:Wait()
				local camera = workspace.CurrentCamera
				local speed = tonumber(speedBox.Text) or 50
				local moveDir = Vector3.new(0,0,0)
				
				if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CoordinateFrame.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CoordinateFrame.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CoordinateFrame.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CoordinateFrame.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
				if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
				
				if bv and bg then
					bv.Velocity = moveDir * speed
					bg.CFrame = camera.CoordinateFrame
				end
			end
		end)
	else
		flyBtn.Text = "플라이: OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
		if humanoid then humanoid.PlatformStand = false end
	end
end)

player.CharacterAdded:Connect(function(char)
	flyEnabled = false
	flyBtn.Text = "플라이: OFF"
	flyBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
end)

-- 모든 좌표 삭제 버튼
deleteAllBtn.MouseButton1Click:Connect(function()
	for index, data in ipairs(coordinates) do
		data.cframe = nil
		if data.marker then
			data.marker:Destroy()
			data.marker = nil
		end
		data.tpBtn.Text = index .. "번째 텔레포트"
	end
end)
