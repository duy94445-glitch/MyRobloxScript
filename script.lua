-- GUI setup
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MiniHackGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 350)
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
    btn.Text = name.." [OFF]"
    btn.Parent = frame
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name..(state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Ẩn/Hiện GUI
local guiHidden = false
createToggle("Ẩn/Hiện GUI", 10, function(state)
    guiHidden = state
    frame.Visible = not guiHidden
end)

-- Hack Tăng tốc độ
local speedHack = false
local speedValue = 100 -- tốc độ
createToggle("Tăng tốc độ", 50, function(state)
    speedHack = state
end)

RunService.RenderStepped:Connect(function()
    if speedHack and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedValue
    elseif player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16 -- default
    end
end)

-- Nhảy cao tự nhập số
local highJump = false
local jumpValue = 200
createToggle("Nhảy cao", 90, function(state)
    highJump = state
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = highJump and jumpValue or 50
    end
end)

-- Tăng độ sáng
local bright = false
createToggle("Tăng độ sáng", 130, function(state)
    bright = state
    game.Lighting.Brightness = bright and 5 or 1
end)

-- Xuyên tường / Anti Block
local antiBlock = false
createToggle("Xuyên tường", 170, function(state)
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

-- God Mode kiểu máu max 300, auto hồi khi <200
local godMode = false
local maxHealth = 300
createToggle("God Mode", 210, function(state)
    godMode = state
end)

RunService.RenderStepped:Connect(function()
    if godMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        hum.MaxHealth = maxHealth
        if hum.Health < 200 then
            hum.Health = maxHealth
        end
    end
end)

print("MiniHack GUI Loaded with Hide/Show!")

