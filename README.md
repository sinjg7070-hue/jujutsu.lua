local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

pcall(function()
	if CoreGui:FindFirstChild("KoreanAutoUI") then CoreGui.KoreanAutoUI:Destroy() end
	if player.PlayerGui:FindFirstChild("KoreanAutoUI") then player.PlayerGui.KoreanAutoUI:Destroy() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KoreanAutoUI"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 155)
frame.Position = UDim2.new(0.5, -210, 0.5, -77)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, -170, 0, 30)
titleBar.Position = UDim2.new(0, 10, 0, 5)
titleBar.BackgroundTransparency = 1
titleBar.Text = "  한글 조합 미리보기 변환기"
titleBar.TextColor3 = Color3.fromRGB(180, 180, 180)
titleBar.TextSize = 12
titleBar.Font = Enum.Font.GothamBold
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = frame

local sizeInputBox = Instance.new("TextBox")
sizeInputBox.Size = UDim2.new(0, 75, 0, 26)
sizeInputBox.Position = UDim2.new(1, -160, 0, 5)
sizeInputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
sizeInputBox.BorderSizePixel = 0
sizeInputBox.Text = "2"
sizeInputBox.PlaceholderText = "크기(1~5)"
sizeInputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
sizeInputBox.TextSize = 12
sizeInputBox.Font = Enum.Font.GothamBold
sizeInputBox.ClearTextOnFocus = false
sizeInputBox.Parent = frame

local sizeBoxCorner = Instance.new("UICorner")
sizeBoxCorner.CornerRadius = UDim.new(0, 6)
sizeBoxCorner.Parent = sizeInputBox

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0, 70, 0, 26)
sendButton.Position = UDim2.new(1, -78, 0, 5)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
sendButton.Text = "보내기"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.TextSize = 12
sendButton.Font = Enum.Font.GothamBold
sendButton.Parent = frame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendButton

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 45)
textBox.Position = UDim2.new(0, 10, 0, 38)
textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
textBox.BorderSizePixel = 0
textBox.Text = ""
textBox.PlaceholderText = ""
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
textBox.TextSize = 15
textBox.Font = Enum.Font.GothamMedium
textBox.ClearTextOnFocus = false
textBox.MultiLine = false
textBox.TextWrapped = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Center
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = textBox

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1, -20, 0, 45)
previewLabel.Position = UDim2.new(0, 10, 0, 93)
previewLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
previewLabel.BorderSizePixel = 0
previewLabel.Text = ""
previewLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
previewLabel.TextSize = 14
previewLabel.Font = Enum.Font.GothamBold
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Center
previewLabel.TextWrapped = true
previewLabel.Parent = frame

local prevCorner = Instance.new("UICorner")
prevCorner.CornerRadius = UDim.new(0, 6)
prevCorner.Parent = previewLabel

local CHO = {"ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"}
local JUNG = {"ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"}
local JONG = {"", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"}

local CHO_MAP = {r=1, R=2, s=3, e=4, E=5, f=6, a=7, q=8, Q=9, t=10, T=11, d=12, w=13, W=14, c=15, z=16, x=17, v=18, g=19}
local JUNG_MAP = {k=1, o=2, i=3, O=4, j=5, p=6, u=7, P=8, h=9, y=13, n=14, b=18, m=19, l=21}
local JONG_MAP = {r=1, R=2, s=4, e=7, f=8, a=16, q=17, t=19, T=20, d=21, w=22, c=23, z=24, x=25, v=26, g=27}
local JUNG_COMP = {hk = 10, ho = 11, hl = 12, nj = 15, np = 16, nl = 17, ml = 20}

local function translateEngToHangul(str)
	local result = {}
	local i = 1
	local len = #str
	local c, j, g = 0, 0, 0
	
	local function flush()
		if c > 0 and j > 0 then
			local code = 0xAC00 + (c - 1) * 588 + (j - 1) * 28 + g
			table.insert(result, utf8.char(code))
		elseif c > 0 then
			table.insert(result, CHO[c])
		elseif j > 0 then
			table.insert(result, JUNG[j])
		end
		c, j, g = 0, 0, 0
	end
	
	while i <= len do
		local char = str:sub(i, i)
		if not char:match("[a-zA-Z]") then
			flush()
			table.insert(result, char)
			i = i + 1
		else
			local cho_v = CHO_MAP[char]
			local jung_v = JUNG_MAP[char]
			
			if c == 0 then
				if cho_v then
					c = cho_v
					i = i + 1
				elseif jung_v then
					j = jung_v
					i = i + 1
					flush()
				else
					flush()
					table.insert(result, char)
					i = i + 1
				end
			elseif j == 0 then
				if jung_v then
					j = jung_v
					i = i + 1
				elseif cho_v then
					table.insert(result, CHO[c])
					c = cho_v
					i = i + 1
				else
					flush()
					table.insert(result, char)
					i = i + 1
				end
			else
				local jong_v = JONG_MAP[char]
				local next_char = str:sub(i+1, i+1)
				local next_jung_v = JUNG_MAP[next_char]
				
				local currentJungName = JUNG[j]
				local combinedJungKey = (currentJungName and char) and (currentJungName == "ㅗ" and char == "k" and "hk" or (currentJungName == "ㅗ" and char == "o" and "ho" or (currentJungName == "ㅗ" and char == "l" and "hl" or (currentJungName == "ㅜ" and char == "j" and "nj" or (currentJungName == "ㅜ" and char == "p" and "np" or (currentJungName == "ㅜ" and char == "l" and "nl" or (currentJungName == "ㅡ" and char == "l" and "ml" or ""))))))) or ""
				
				if JUNG_COMP[combinedJungKey] and g == 0 then
					j = JUNG_COMP[combinedJungKey]
					i = i + 1
				elseif jong_v and g == 0 and not next_jung_v then
					g = jong_v
					i = i + 1
				elseif cho_v then
					flush()
					c = cho_v
					i = i + 1
				else
					flush()
					if cho_v then
						c = cho_v
						i = i + 1
					elseif jung_v then
						j = jung_v
						i = i + 1
					else
						table.insert(result, char)
						i = i + 1
					end
				end
			end
		end
	end
	flush()
	return table.concat(result)
end

sizeInputBox:GetPropertyChangedSignal("Text"):Connect(function()
	local num = tonumber(sizeInputBox.Text)
	if not num then return end
	if num < 1 then num = 1 end
	if num > 5 then num = 5 end
	
	local w = 350 + (num * 75)
	local boxH = 30 + (num * 12)
	local prevH = 30 + (num * 12)
	local prevY = 38 + boxH + 8
	local h = prevY + prevH + 12
	
	local textSz = 11 + (num * 3)
	local prevSz = 10 + (num * 3)
	
	frame.Size = UDim2.new(0, w, 0, h)
	textBox.Size = UDim2.new(1, -20, 0, boxH)
	previewLabel.Position = UDim2.new(0, 10, 0, prevY)
	previewLabel.Size = UDim2.new(1, -20, 0, prevH)
	
	textBox.TextSize = textSz
	previewLabel.TextSize = prevSz
end)

textBox:GetPropertyChangedSignal("Text"):Connect(function()
	local rawText = textBox.Text
	if rawText == "" then
		previewLabel.Text = ""
	else
		previewLabel.Text = "  " .. translateEngToHangul(rawText)
	end
end)

local function sendMessage()
	local rawText = textBox.Text
	rawText = rawText:gsub("[\r\n]", "")
	
	if rawText ~= "" then
		local convertedMsg = translateEngToHangul(rawText)
		textBox.Text = ""
		previewLabel.Text = ""
		
		local sent = false
		pcall(function()
			local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			if textChannel then
				textChannel:SendAsync(convertedMsg)
				sent = true
			end
		end)
		
		if not sent then
			pcall(function()
				local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents", true)
				if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
					chatEvents.SayMessageRequest:FireServer(convertedMsg, "All")
					sent = true
				end
			end)
		end
	end
end

sendButton.MouseButton1Click:Connect(sendMessage)

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)
