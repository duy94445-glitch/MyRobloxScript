-- GUI setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "UtilityGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 470)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "MiniHack Loaded"
statusLabel.Parent = frame

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

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local activeFeatures = {}

-- Ẩn/Hiện GUI
createToggle("Ẩn/Hiện GUI", 10, function(state)
    frame.Visible = not state
end)

-- Fly V1
createToggle("Fly V1", 50, function(state)
    activeFeatures.flyV1 = state
end)

-- Fly V2
createToggle("Fly V2", 90, function(state)
    activeFeatures.flyV2 = state
end)

-- God Mode
local godConn = nil
createToggle("God Mode", 130, function(state)
    activeFeatures.godMode = state
    if godConn then godConn:Disconnect(); godConn = nil end
    if state then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            godConn = hum.HealthChanged:Connect(function(health)
                if health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end
    end
end)

-- Anti Animation
local charConn = nil
createToggle("Anti Animation", 170, function(state)
    activeFeatures.antiAnim = state
    if charConn then charConn:Disconnect(); charConn = nil end
    local function destroyAnims(char)
        if char then
            for _, anim in pairs(char:GetDescendants()) do
                if anim:IsA("Animation") then anim:Destroy() end
            end
        end
    end
    if state then
        destroyAnims(player.Character)
        charConn = player.CharacterAdded:Connect(destroyAnims)
    end
end)

-- Anti chặn di chuyển
createToggle("Anti Chặn Di chuyển", 210, function(state)
    activeFeatures.antiBlock = state
end)

-- Tăng độ sáng
createToggle("Tăng độ sáng", 250, function(state)
    game.Lighting.Brightness = state and 5 or 1
end)

-- Nhảy cao
createToggle("Nhảy cao", 290, function(state)
    activeFeatures.highJump = state
end)

-- Tăng tốc auto input (dummy)
createToggle("Tăng tốc độ Auto Input", 330, function(state)
    activeFeatures.fastInput = state
end)

-- Anti AFK
local afkConn = nil
createToggle("Anti AFK", 370, function(state)
    if afkConn then afkConn:Disconnect(); afkConn = nil end
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        afkConn = player.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait()
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- RunService main loop
RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    local cam = workspace.CurrentCamera

    -- Fly V1 kiểu Flappy Bird
    if activeFeatures.flyV1 and hrp then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        end
    end

    -- Fly V2 bay tự do 3D
    if activeFeatures.flyV2 and hrp then
        local move = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
        
        hrp.AssemblyLinearVelocity = move * 50
    end

    -- Anti Block
    if activeFeatures.antiBlock and hum then
        hum.WalkSpeed = 16
    end

    -- High Jump
    if hum then
        hum.JumpPower = activeFeatures.highJump and 200 or 50
    end
end)
