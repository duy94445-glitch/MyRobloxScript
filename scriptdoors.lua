-- ✅ Doors Script với GUI + Ctrl+Alt unlock mouse

local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- Tạo GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -30, 0, 30)
title.Text = "Doors Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,0,0)

-- Biến
local hum = plr.Character:WaitForChild("Humanoid")
local char = plr.Character
local speed = 16
local noclip = false

-- ESP Button
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 30)
espBtn.Position = UDim2.new(0, 10, 0, 40)
espBtn.Text = "ESP: OFF"

local espOn = false
espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = "ESP: " .. (espOn and "ON" or "OFF")
    -- TODO: bạn thêm code ESP của bạn ở đây
end)

-- Speed Button
local spdBtn = Instance.new("TextButton", frame)
spdBtn.Size = UDim2.new(1, -20, 0, 30)
spdBtn.Position = UDim2.new(0, 10, 0, 75)
spdBtn.Text = "Speed: "..speed

spdBtn.MouseButton1Click:Connect(function()
    if speed == 16 then
        speed = 40
    else
        speed = 16
    end
    spdBtn.Text = "Speed: "..speed
end)

-- Noclip Button
local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(1, -20, 0, 30)
noclipBtn.Position = UDim2.new(0, 10, 0, 110)
noclipBtn.Text = "Noclip: OFF"

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- Đóng menu
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Loop Speed + Noclip
RS.Stepped:Connect(function()
    if hum and hum.Parent then
        hum.WalkSpeed = speed
    end
    if noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Script kéo thả menu
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ✅ Ctrl + Alt unlock mouse
UIS.InputBegan:Connect(function(input, processed)
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
        local UIS2 = game:GetService("UserInputService")
        if UIS2.MouseBehavior == Enum.MouseBehavior.LockCenter then
            UIS2.MouseBehavior = Enum.MouseBehavior.Default
        else
            UIS2.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)
