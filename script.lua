-- Loadstring mẫu:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/duy94445-glitch/MyRobloxScript/refs/heads/main/script.lua"))()

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local cam = workspace.CurrentCamera

-- GUI
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
statusLabel.Text = "MiniHack Loaded & Improved"
statusLabel.Parent = frame

-- Toggle/Input creator
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
local activeFeatures = {speed = 16, jump = 50, flySpeed = 50}
local maxSkyJumps, skyJumpCount = 3, 0

-- GUI Ẩn/Hiện
createToggle("Ẩn/Hiện GUI", 10, function(state)
    frame.Visible = not state
end)

-- Speed/Jump
createInput("Speed", 50, 16, function(val) activeFeatures.speed = val end)
createInput("JumpPower", 90, 50, function(val) activeFeatures.jump = val end)

-- Fly V2 (theo camera)
createToggle("Fly V2 (Free-fly)", 130, function(state)
    activeFeatures.flyV2 = state
    if not state then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if hrp:FindFirstChild("FlyControl") then
                hrp.FlyControl:Destroy()
            end
        end
    end
end)

-- Fly Speed Input
createInput("Fly Speed", 170, 50, function(val)
    activeFeatures.flySpeed = val
end)

-- Sky Jump
createToggle("Sky Jump (Blox Fruits)", 210, function(state)
    activeFeatures.skyJump = state
    skyJumpCount = 0
end)

-- Noclip
createToggle("Noclip", 250, function(state)
    activeFeatures.noclip = state
end)

-- Forced Jump
createToggle("Forced Jump", 290, function(state)
    activeFeatures.forcedJump = state
end)

-- Full Bright
createToggle("Full Bright", 330, function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 1e5
        game.Lighting.GlobalShadows = false
        game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        game.Lighting.GlobalShadows = true
    end
end)

-- Phím RightShift để bật/tắt GUI
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
    end
end)

-- Phím Ctrl+Alt bỏ lock chuột
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) 
        and UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

-- Sky Jump reset khi chạm đất
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Landed then
            skyJumpCount = 0
        end
    end)
end)

-- JumpRequest xử lý Sky Jump
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

        -- Speed & Jump
        hum.WalkSpeed = activeFeatures.speed
        hum.JumpPower = activeFeatures.jump

        -- Forced Jump
        if activeFeatures.forcedJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        -- Fly V2
        if activeFeatures.flyV2 then
            local bv = hrp:FindFirstChild("FlyControl")
            if not bv then
                bv = Instance.new("BodyVelocity")
                bv.Name = "FlyControl"
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end

            local move = Vector3.zero
            local speed = activeFeatures.flySpeed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= cam.CFrame.UpVector end

            if move.Magnitude > 0 then
                bv.Velocity = move.Unit * speed
            else
                bv.Velocity = Vector3.zero
            end
        end

        -- Noclip
        if activeFeatures.noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end)
