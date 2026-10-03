local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- 기존 커스텀 UI 제거
pcall(function()
	if CoreGui:FindFirstChild("KoreanAutoUI") then CoreGui.KoreanAutoUI:Destroy() end
	if player.PlayerGui:FindFirstChild("KoreanAutoUI") then player.PlayerGui.KoreanAutoUI:Destroy() end
end)

-- 로블록스 기본 입력창은 숨기고, 대화 내역 창은 유지
pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	TextChatService.ChatWindowConfiguration.Enabled = true
	TextChatService.ChatInputBarConfiguration.Enabled = false
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KoreanAutoUI"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

-- 원래 채팅창 위치 (왼쪽 아래)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 40)
frame.Position = UDim2.new(0, 10, 1, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- 영타 입력창
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -12, 1, 0)
textBox.Position = UDim2.new(0, 6, 0, 0)
textBox.BackgroundTransparency = 1
textBox.BorderSizePixel = 0
textBox.Text = ""
textBox.PlaceholderText = "여기에 입력 후 엔터"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
textBox.TextSize = 14
textBox.Font = Enum.Font.GothamMedium
textBox.ClearTextOnFocus = false
textBox.MultiLine = false
textBox.TextWrapped = true
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Center
textBox.Parent = frame

-- 원래 채팅창 오른쪽 부근에 위치한 선명한 검은색 번역 미리보기 UI
local previewFrame = Instance.new("Frame")
previewFrame.Size = UDim2.new(0, 320, 0, 40)
previewFrame.Position = UDim2.new(0, 335, 1, -50)
previewFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
previewFrame.BackgroundTransparency = 0.2
previewFrame.BorderSizePixel = 0
previewFrame.Parent = screenGui

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 8)
previewCorner.Parent = previewFrame

local previewStroke = Instance.new("UIStroke")
previewStroke.Color = Color3.fromRGB(0, 255, 128)
previewStroke.Thickness = 1.5
previewStroke.Parent = previewFrame

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1, -16, 1, 0)
previewLabel.Position = UDim2.new(0, 8, 0, 0)
previewLabel.BackgroundTransparency = 1
previewLabel.BorderSizePixel = 0
previewLabel.Text = ""
previewLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
previewLabel.TextSize = 14
previewLabel.Font = Enum.Font.GothamBold
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Center
previewLabel.TextWrapped = true
previewLabel.Parent = previewFrame

-- 한글 오토마타 조합 엔진
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
				elseif g > 0 then
					local combined = false
					-- '없' (ㅂ+ㅅ = ㅄ) 및 '않' (ㄴ+ㅎ = ㄶ) 등 정상 겹받침 허용
					if g == 17 and char == "t" then 
						g = 18; combined = true -- ㅄ
					elseif g == 4 and char == "g" then 
						g = 6; combined = true  -- ㄶ (않)
					end
					
					if combined then
						i = i + 1
					else
						-- 허용되지 않은 3개 이상 자음 조합은 강제 차단 후 분리
						flush()
						if cho_v then
							c = cho_v
						elseif jong_v then
							c = jong_v
						end
						i = i + 1
					end
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

textBox:GetPropertyChangedSignal("Text"):Connect(function()
	local rawText = textBox.Text
	if rawText == "" then
		previewLabel.Text = ""
	else
		previewLabel.Text = translateEngToHangul(rawText)
	end
end)

local function sendMessage()
	local rawText = textBox.Text
	rawText = rawText:gsub("[\r\n]", "")
	
	if rawText ~= "" then
		local convertedMsg = translateEngToHangul(rawText)
		textBox.Text = ""
		previewLabel.Text = ""
		
		pcall(function()
			local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			if textChannel then
				textChannel:SendAsync(convertedMsg)
			end
		end)
	end
end

textBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)

-- 슬래시(/) 키를 누르면 자동으로 입력창에 포커스가 가도록 설정
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Slash then
		task.defer(function()
			textBox:CaptureFocus()
			if textBox.Text == "/" then
				textBox.Text = ""
			end
		end)
	end
end)
