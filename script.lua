-- GUI setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HackGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 450)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui

local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name .. " [OFF]"
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local cam = workspace.CurrentCamera

-- Fly V1 (space = bay / shift xuống)
local flyV1Speed = 50
local flyV1 = false
createToggle("Fly V1", 10, function(state)
    flyV1 = state
end)

RunService.RenderStepped:Connect(function()
    if flyV1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local vel = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vel = Vector3.new(0, flyV1Speed, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel = Vector3.new(0, -flyV1Speed, 0)
        end
        hrp.Velocity = vel
    end
end)

-- Fly V2 (theo camera)
local flyV2Speed = 50
local flyV2 = false
createToggle("Fly V2", 50, function(state)
    flyV2 = state
end)

RunService.RenderStepped:Connect(function()
    if flyV2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        hrp.AssemblyLinearVelocity = move * flyV2Speed
    end
end)

-- God Mode
local godMode = false
createToggle("God Mode", 90, function(state)
    godMode = state
end)

RunService.RenderStepped:Connect(function()
    if godMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        hum.MaxHealth = 1000000
        hum.Health = 1000000
    end
end)

-- Anti Animation
local antiAnim = false
createToggle("Anti Animation", 130, function(state)
    antiAnim = state
end)

player.CharacterAdded:Connect(function(char)
    if antiAnim then
        for _,anim in pairs(char:GetDescendants()) do
            if anim:IsA("Animation") then anim:Destroy() end
        end
    end
end)

-- Anti chặn di chuyển
local antiBlock = false
createToggle("Anti Chặn Di chuyển", 170, function(state)
    antiBlock = state
end)

RunService.RenderStepped:Connect(function()
    if antiBlock and player.Character then
        for _,part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local vf = part:FindFirstChildOfClass("VectorForce")
                if vf then vf:Destroy() end
            end
        end
    end
end)

-- Tăng độ sáng
local bright = false
createToggle("Tăng độ sáng", 210, function(state)
    bright = state
    game.Lighting.Brightness = bright and 5 or 1
end)

-- Tăng tốc độ auto input (dummy example)
local fastInput = false
createToggle("Tăng tốc độ Auto Input", 250, function(state)
    fastInput = state
end)
-- Lưu ý: tùy game mới fireServer input được

-- Nhảy cao
local highJump = false
createToggle("Nhảy cao", 290, function(state)
    highJump = state
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = highJump and 200 or 50
    end
end)

-- Anti AFK
local antiAFK = false
createToggle("Anti AFK", 330, function(state)
    antiAFK = state
end)

if antiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

print("GUI hack fully loaded!")
