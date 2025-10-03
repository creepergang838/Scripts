--// Services
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

--// Variables
local flying = false
local noclip = false
local speed = 50
local minSpeed, maxSpeed = 50, 150
local control = {forward = 0, backward = 0, left = 0, right = 0}
local animator
local draggingSlider = false
local minimized = false

--// GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 20)

local uiGradient = Instance.new("UIGradient", frame)
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 30, 90))
})

local function createButton(parent, text, posY)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = UDim2.new(0.5, -50, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.AutoButtonColor = false

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

    button.MouseEnter:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)
    button.MouseLeave:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    button.MouseButton1Down:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0, 95, 0, 38)}):Play()
    end)
    button.MouseButton1Up:Connect(function()
        tweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0, 100, 0, 40)}):Play()
    end)

    return button
end

local flyButton = createButton(frame, "Start Fly", 10)

-- Speed Slider
local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(0, 120, 0, 20)
sliderFrame.Position = UDim2.new(0.5, -60, 0, 60)
sliderFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(1, 0)

local sliderBar = Instance.new("Frame", sliderFrame)
sliderBar.Size = UDim2.new(0, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1, 0)

local speedLabel = Instance.new("TextLabel", sliderFrame)
speedLabel.Size = UDim2.new(1, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.new(0, 0, 0)
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 14

-- Noclip Button
local noclipButton = createButton(frame, "Noclip: OFF", 110)

-- Close Button
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.AutoButtonColor = false
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

closeButton.MouseEnter:Connect(function()
    tweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
end)
closeButton.MouseLeave:Connect(function()
    tweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18
minimizeButton.AutoButtonColor = false
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(1, 0)

minimizeButton.MouseEnter:Connect(function()
    tweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 210)}):Play()
end)
minimizeButton.MouseLeave:Connect(function()
    tweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
end)

-- Pop-in animation
tweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 220, 0, 250),
    Position = UDim2.new(0.5, -110, 0.5, -125),
    BackgroundTransparency = 0
}):Play()

-- Slider Dragging
sliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        frame.Draggable = false
    end
end)
userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
        frame.Draggable = true
    end
end)
userInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        sliderBar.Size = UDim2.new(relativeX, 0, 1, 0)
        speed = math.floor(minSpeed + (relativeX * (maxSpeed - minSpeed)))
        speedLabel.Text = "Speed: " .. speed
    end
end)

-- Fly Function
local function startFlying()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local root = character:WaitForChild("HumanoidRootPart")

    animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        animator.Parent = nil
    end

    local bodyGyro = Instance.new("BodyGyro", root)
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = root.CFrame

    local bodyVelocity = Instance.new("BodyVelocity", root)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    flying = true

    while flying and root.Parent do
        runService.Heartbeat:Wait()
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame

        local moveVec = Vector3.new(control.left + control.right, 0, control.forward + control.backward)
        if moveVec.Magnitude > 0 then
            moveVec = workspace.CurrentCamera.CFrame:VectorToWorldSpace(moveVec)
            bodyVelocity.Velocity = moveVec.Unit * speed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end

    bodyGyro:Destroy()
    bodyVelocity:Destroy()

    if animator then
        animator.Parent = humanoid
    end
end

-- Noclip Function
runService.Stepped:Connect(function()
    if noclip then
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Input
userInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.W then
        control.forward = -1
    elseif input.KeyCode == Enum.KeyCode.S then
        control.backward = 1
    elseif input.KeyCode == Enum.KeyCode.A then
        control.left = -1
    elseif input.KeyCode == Enum.KeyCode.D then
        control.right = 1
    end
end)
userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
        control.forward = 0
    elseif input.KeyCode == Enum.KeyCode.S then
        control.backward = 0
    elseif input.KeyCode == Enum.KeyCode.A then
        control.left = 0
    elseif input.KeyCode == Enum.KeyCode.D then
        control.right = 0
    end
end)

-- Buttons
flyButton.MouseButton1Click:Connect(function()
    if not flying then
        flying = true
        flyButton.Text = "Stop Fly"
        startFlying()
    else
        flying = false
        flyButton.Text = "Start Fly"
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipButton.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
    flying = false
    noclip = false
    frame.Active = false

    for _, obj in ipairs(frame:GetChildren()) do
        if obj:IsA("TextButton") or obj:IsA("Frame") or obj:IsA("TextLabel") then
            obj:Destroy()
        end
    end

    local originalPos = frame.Position
    for i = 1, 5 do
        local offsetX = math.random(-10, 10)
        local offsetY = math.random(-10, 10)
        frame.Position = originalPos + UDim2.new(0, offsetX, 0, offsetY)
        task.wait(0.05)
    end

    local closeTween = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Circular, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    })
    closeTween:Play()

    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end)

-- Minimize GUI
minimizeButton.MouseButton1Click:Connect(function()
    if minimized == false then
        minimized = true
        for _, obj in ipairs(frame:GetChildren()) do
            if obj:IsA("TextButton") or obj:IsA("Frame") or obj:IsA("TextLabel") then
                if obj ~= closeButton and obj ~= minimizeButton then
                    obj.Visible = false
                end
            end
        end
        tweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 120, 0, 40)}):Play()
    else
        minimized = false
        for _, obj in ipairs(frame:GetChildren()) do
            if obj:IsA("TextButton") or obj:IsA("Frame") or obj:IsA("TextLabel") then
                if obj ~= closeButton and obj ~= minimizeButton then
                    obj.Visible = true
                end
            end
        end
        tweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 250)}):Play()
    end
end)
-- TP GUI Button
local tpButton = createButton(frame, "TP GUI", 160)

tpButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/creepergang838/Scripts/refs/heads/main/tp.lua"))()
    print("TP GUI button pressed! Run your script here.")
end)



