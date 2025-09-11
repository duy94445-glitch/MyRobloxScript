-- Loadstring mẫu:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/duy94445-glitch/MyRobloxScript/refs/heads/main/script.lua"))()

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UtilityGUI"
gui.Parent = game.CoreGui

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 800)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 770)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "MiniHack Loaded & Improved"
statusLabel.Parent = frame

-- Nút Toggle Menu (luôn hiển thị)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "Ẩn Menu"
toggleBtn.Parent = gui

local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    toggleBtn.Text = menuVisible and "Ẩn Menu" or "Hiện Menu"
end)

-- Drag toggle button
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        toggleBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Helper functions
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. " [OFF]"
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        statusLabel.Text = name .. " " .. (state and "bật" or "tắt")
        callback(state)
    end)
end

local function createInput(name, posY, default, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 130, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = name
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 140, 0, 30)
    box.Position = UDim2.new(0, 150, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Text = tostring(default)
    box.Parent = frame
    box.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(box.Text)
            if val then callback(val) end
        end
    end)
end

-- Features
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera
local activeFeatures = {speed = 16, jump = 50}

createInput("Speed", 50, 16, function(val) activeFeatures.speed = val end)
createInput("JumpPower", 90, 50, function(val) activeFeatures.jump = val end)

createToggle("Fly V1 (Flappy)", 130, function(state) activeFeatures.flyV1 = state end)
createToggle("Fly V2 (Free-fly)", 170, function(state)
    activeFeatures.flyV2 = state
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    if state then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyControl"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp
    else
        local bv = hrp:FindFirstChild("FlyControl")
        if bv then bv:Destroy() end
    end
end)

createToggle("God Mode", 210, function(state) activeFeatures.godMode = state end)
createToggle("Noclip", 250, function(state) activeFeatures.noclip = state end)
createToggle("Infinite Jump", 290, function(state) activeFeatures.infiniteJump = state end)
createToggle("Forced Jump", 330, function(state) activeFeatures.forcedJump = state end)

-- Sky Jump
local maxSkyJumps, skyJumpCount = 3, 0
createToggle("Sky Jump", 370, function(state) activeFeatures.skyJump = state skyJumpCount = 0 end)

player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then skyJumpCount = 0 end
    end)
end)

-- Hotkeys
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.RightShift then
            frame.Visible = not frame.Visible
        elseif input.KeyCode == Enum.KeyCode.LeftControl and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
    end
end)

-- Jump logic
UserInputService.JumpRequest:Connect(function()
    local char, hum, hrp = player.Character, nil, nil
    if char then
        hum = char:FindFirstChild("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
    if not hum or not hrp then return end

    if activeFeatures.skyJump and skyJumpCount < maxSkyJumps then
        skyJumpCount += 1
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        hrp.Velocity = Vector3.new(hrp.Velocity.X, activeFeatures.jump, hrp.Velocity.Z)
    elseif activeFeatures.infiniteJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    elseif activeFeatures.forcedJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not (char and hrp and hum) then return end

    hum.WalkSpeed = activeFeatures.speed
    hum.JumpPower = activeFeatures.jump

    if activeFeatures.godMode then
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end

    if activeFeatures.noclip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if activeFeatures.flyV2 then
        local bv = hrp:FindFirstChild("FlyControl")
        if bv then
            local move, speed = Vector3.zero, 50
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= cam.CFrame.UpVector end
            bv.Velocity = (move.Magnitude > 0) and move.Unit * speed or Vector3.zero
        end
    elseif activeFeatures.flyV1 then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end
end)
