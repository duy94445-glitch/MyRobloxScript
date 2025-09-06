-- Tạo GUI chính
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HackGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Hàm tạo button
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
end

-- Hack Fly V1 (space = bay)
local flyV1 = false
createButton("Hack Fly V1", 10, function()
    flyV1 = not flyV1
end)

local UserInputService = game:GetService("UserInputService")
local flySpeed = 50

game:GetService("RunService").RenderStepped:Connect(function()
    if flyV1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local vel = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vel = Vector3.new(0, flySpeed, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel = Vector3.new(0, -flySpeed, 0)
        end

        hrp.Velocity = vel
    end
end)

-- Fly V2 (theo camera)
local flyV2 = false
createButton("Fly V2", 50, function()
    flyV2 = not flyV2
end)

local cam = workspace.CurrentCamera

game:GetService("RunService").RenderStepped:Connect(function()
    if flyV2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local move = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move = move + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move = move - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move = move - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move = move + cam.CFrame.RightVector
        end

        hrp.Velocity = move * flySpeed
    end
end)
