local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ThumbnailService = game:GetService("Players")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Rounded corners for main frame
local roundFrame = Instance.new("UICorner")
roundFrame.CornerRadius = UDim.new(0, 8)
roundFrame.Parent = frame

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Teleport to Player"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Scroll area
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)
layout.Parent = scroll

-- Create Player Button with avatar
local function createPlayerButton(player)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -10, 0, 40)
	container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	container.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = container

	local button = Instance.new("TextButton")
	button.BackgroundTransparency = 1
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Text = ""
	button.Parent = container

	local avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.new(0, 32, 0, 32)
	avatar.Position = UDim2.new(0, 4, 0.5, -16)
	avatar.BackgroundTransparency = 1
	avatar.Parent = container

	local username = Instance.new("TextLabel")
	username.Size = UDim2.new(1, -44, 1, 0)
	username.Position = UDim2.new(0, 44, 0, 0)
	username.BackgroundTransparency = 1
	username.Text = player.Name
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.Font = Enum.Font.SourceSans
	username.TextSize = 16
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.Parent = container

	-- Set avatar thumbnail
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local content, _ = Players:GetUserThumbnailAsync(player.UserId, thumbType, thumbSize)
	avatar.Image = content

	-- Teleport when clicked
	button.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local myChar = LocalPlayer.Character
			if myChar and myChar:FindFirstChild("HumanoidRootPart") then
				myChar.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end)
end

-- Refresh player list every second
task.spawn(function()
	while true do
		-- Clear old buttons
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				createPlayerButton(player)
			end
		end

		scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
		task.wait(30)
	end
end)
