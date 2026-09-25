local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local lighting = game:GetService("Lighting")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PositionMarkerGui"
gui.ResetOnSpawn = false

-- 기본 창 크기 및 한 칸당 높이 설정
local baseHeight = 350
local rowHeight = 45

--------------------------------------------------
-- [메인 창 생성]
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, baseHeight)
frame.Position = UDim2.new(0.5, -210, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true -- 초기 상태

--------------------------------------------------
-- [모바일 친화적 드래그 가능 구슬 버튼]
--------------------------------------------------
local toggleBubble = Instance.new("TextButton", gui)
toggleBubble.Size = UDim2.new(0, 50, 0, 50)
toggleBubble.Position = UDim2.new(0, 20, 0.5, -25)
toggleBubble.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
toggleBubble.Text = "닫기"
toggleBubble.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBubble.TextSize = 14
toggleBubble.Font = Enum.Font.SourceSansBold
toggleBubble.Active = true

-- 동그랗게 만들기 (UICorner)
local corner = Instance.new("UICorner", toggleBubble)
corner.CornerRadius = UDim.new(1, 0)

-- 구슬 드래그 지원 (터치 & 마우스 공용)
local bubbleDragging = false
local bubbleDragStart, startBubblePos

local function updateInput(input)
	local delta = input.Position - bubbleDragStart
	toggleBubble.Position = UDim2.new(
		startBubblePos.X.Scale, startBubblePos.X.Offset + delta.X,
		startBubblePos.Y.Scale, startBubblePos.Y.Offset + delta.Y
	)
end

toggleBubble.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		bubbleDragging = true
		bubbleDragStart = input.Position
		startBubblePos = toggleBubble.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				bubbleDragging = false
			end
		end)
	end
end)

uis.InputChanged:Connect(function(input)
	if bubbleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateInput(input)
	end
end)

-- 구슬 클릭 시 창 토글 (드래그 시 클릭 미작동)
local dragDistance = 0
toggleBubble.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragDistance = 0
	end
end)

toggleBubble.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragDistance = dragDistance + 1
	end
end)

toggleBubble.MouseButton1Click:Connect(function()
	-- 약간의 드래그는 무시하고 클릭으로 처리
	if dragDistance < 5 then
		frame.Visible = not frame.Visible
		if frame.Visible then
			toggleBubble.Text = "닫기"
			toggleBubble.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
		else
			toggleBubble.Text = "열기"
			toggleBubble.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		end
	end
end)

--------------------------------------------------
-- [메인 창 드래그 기능 (모바일/PC 지원)]
--------------------------------------------------
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

uis.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
		dragging = false 
	end
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
-- 동적 좌표 관리 시스템
--------------------------------------------------

local coordinates = {} 
local startY = 145

local function createCoordinateRow(index)
	local currentY = startY + ((index - 1) * rowHeight)
	
	local tpBtn = Instance.new("TextButton", frame)
	tpBtn.Size = UDim2.new(0, 120, 0, 35)
	tpBtn.Position = UDim2.new(0, 10, 0, currentY)
	tpBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
	tpBtn.Text = index .. "번째 텔레포트"
	tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	tpBtn.TextSize = 13
	tpBtn.Font = Enum.Font.SourceSansBold
	
	local saveBtn = Instance.new("TextButton", frame)
	saveBtn.Size = UDim2.new(0, 130, 0, 35)
	saveBtn.Position = UDim2.new(0, 140, 0, currentY)
	saveBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	saveBtn.Text = index .. "번째 좌표 저장"
	saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveBtn.TextSize = 13
	saveBtn.Font = Enum.Font.SourceSansBold
	
	local nameBox = Instance.new("TextBox", frame)
	nameBox.Size = UDim2.new(0, 60, 0, 35)
	nameBox.Position = UDim2.new(0, 280, 0, currentY)
	nameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	nameBox.Text = "이름" .. index
	nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameBox.TextSize = 13
	nameBox.Font = Enum.Font.SourceSansBold
	nameBox.ClearTextOnFocus = false
	
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
	
	tpBtn.MouseButton1Click:Connect(function()
		if not data.cframe then return end
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = data.cframe
		end
	end)
	
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

-- 모든 좌표 삭제 버튼 생성
local deleteAllBtn = Instance.new("TextButton", frame)
deleteAllBtn.Size = UDim2.new(0, 120, 0, 35)
deleteAllBtn.Position = UDim2.new(0, 140, 0, nextY + 45)
deleteAllBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
deleteAllBtn.Text = "모든 좌표 삭제"
deleteAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteAllBtn.TextSize = 13
deleteAllBtn.Font = Enum.Font.SourceSansBold

local function updateFrameSize()
	local totalRows = #coordinates
	local newHeight = startY + (totalRows * rowHeight) + 95
	frame.Size = UDim2.new(0, 420, 0, newHeight)
end
updateFrameSize()

addBtn.MouseButton1Click:Connect(function()
	local newIndex = #coordinates + 1
	local finalY = createCoordinateRow(newIndex)
	
	addBtn.Position = UDim2.new(0, 140, 0, finalY + 5)
	deleteAllBtn.Position = UDim2.new(0, 140, 0, finalY + 45)
	
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

player.CharacterAdded:Connect(function()
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
