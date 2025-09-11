-- Loadstring mẫu:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/duy94445-glitch/MyRobloxScript/refs/heads/main/script.lua"))()

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UtilityGUI"
gui.Parent = game.CoreGui

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
statusLabel.Text = "MiniHack Loaded & Clean"
statusLabel.Parent = frame

-- Helpers
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
            if val then
                callback(val)
            end
        end
    end)
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local activeFeatures = {speed = 16, jump = 50}

-- GUI Options
createToggle("Ẩn/Hiện GUI", 10, function(state)
    frame.Visible = not state
end)

createInput("Speed", 50, 16, function(val)
    activeFeatures.speed = val
end)

createInput("JumpPower", 90, 50, function(val)
    activeFeatures.jump = val
end)

createToggle("Fly V1 (Flappy Bird)", 130, function(state)
    activeFeatures.flyV1 = state
end)

createToggle("Fly V2 (Free-fly theo camera)", 170, function(state)
    activeFeatures.flyV2 = state
end)

createToggle("God Mode V1", 210, function(state)
    activeFeatures.godMode1 = state
end)

createToggle("God Mode V2 (Ghost)", 250, function(state)
    activeFeatures.godMode2 = state
end)

createToggle("Noclip", 290, function(state)
    activeFeatures.noclip = state
end)

createInput("Zoom Min", 330, 5, function(val)
    player.CameraMinZoomDistance = val
end)

createInput("Zoom Max", 370, 50, function(val)
    player.CameraMaxZoomDistance = val
end)

createToggle("Unlock Camera Mode", 410, function(state)
    if state then
        player.CameraMode = Enum.CameraMode.Classic
    else
        player.CameraMode = Enum.CameraMode.LockFirstPerson
    end
end)

createToggle("Infinite Jump", 450, function(state)
    activeFeatures.infiniteJump = state
end)

createToggle("Forced Jump", 490, function(state)
    activeFeatures.forcedJump = state
end)

createToggle("Bỏ Lock Chuột", 530, function(state)
    if state then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)

-- Sky Jump (Blox Fruits style)
local maxSkyJumps = 3
local skyJumpCount = 0
createToggle("Sky Jump (Blox Fruits)", 570, function(state)
    activeFeatures.skyJump = state
    skyJumpCount = 0
end)

-- Reset Sky Jump khi chạm đất
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            skyJumpCount = 0
        end
    end)
end)

-- Xử lý nhảy trên không
UserInputService.JumpRequest:Connect(function()
    if activeFeatures.skyJump then
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if skyJumpCount < maxSkyJumps then
                skyJumpCount += 1
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                hrp.Velocity = Vector3.new(hrp.Velocity.X, activeFeatures.jump, hrp.Velocity.Z)
            end
        end
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if not (char and hrp and hum) then return end

        -- Speed + JumpPower
        hum.WalkSpeed = activeFeatures.speed
        hum.JumpPower = activeFeatures.jump

        -- God Modes
        if activeFeatures.godMode1 or activeFeatures.godMode2 then
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end

        -- Noclip/Ghost
        local isClipping = activeFeatures.noclip or activeFeatures.godMode2
        if isClipping then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            if hrp then hrp.CanCollide = true end
            local head = char:FindFirstChild("Head")
            if head then head.CanCollide = true end
        end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = activeFeatures.godMode2 and 0.5 or 0
            end
        end

        -- Fly
        if activeFeatures.flyV2 then
            local move = Vector3.new()
            local speed = 50
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= cam.CFrame.UpVector end

            if move.Magnitude > 0 then
                hrp.Velocity = move.Unit * speed
            else
                hrp.Velocity = Vector3.new()
            end
        elseif activeFeatures.flyV1 then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
            end
        end

        -- Infinite Jump
        if activeFeatures.infiniteJump then
            hum.Jump = true
        end

        -- Forced Jump
        if activeFeatures.forcedJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)
