local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Lấy nhân vật & humanoid
local function getHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

local Humanoid, HRP = getHumanoid()

-- Khi nhân vật hồi sinh thì reset lại
LocalPlayer.CharacterAdded:Connect(function(char)
    Humanoid, HRP = getHumanoid()
    Humanoid.MaxHealth = 299
    Humanoid.Health = 299
end)

-- Buff máu auto
Humanoid.MaxHealth = 299
Humanoid.Health = 299

Humanoid.HealthChanged:Connect(function(hp)
    if hp < 210 then
        Humanoid.Health = 299
    end
end)

------------------------------------------------
-- Fly GUI (Camera control) giữ nguyên phần trước
------------------------------------------------

local flyButton = onof
local upButton = up
local downButton = down
local plusButton = plus
local minusButton = mine
local speedLabel = speed

local flying = false
local flySpeed = 50
local upPressed, downPressed = false, false
local flyConn

speedLabel.Text = tostring(flySpeed)

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "STOP"
        Humanoid.PlatformStand = true

        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local moveDir = Vector3.new()

            if Humanoid.MoveDirection.Magnitude > 0 then
                moveDir = cam.CFrame:VectorToWorldSpace(Humanoid.MoveDirection)
            end
            if upPressed then
                moveDir = moveDir + Vector3.new(0,1,0)
            end
            if downPressed then
                moveDir = moveDir + Vector3.new(0,-1,0)
            end

            if moveDir.Magnitude > 0 then
                HRP.Velocity = moveDir.Unit * flySpeed
            else
                HRP.Velocity = Vector3.zero
            end
        end)
    else
        flyButton.Text = "fly"
        Humanoid.PlatformStand = false
        if flyConn then flyConn:Disconnect() end
        HRP.Velocity = Vector3.zero
    end
end)

upButton.MouseButton1Down:Connect(function() upPressed = true end)
upButton.MouseButton1Up:Connect(function() upPressed = false end)
downButton.MouseButton1Down:Connect(function() downPressed = true end)
downButton.MouseButton1Up:Connect(function() downPressed = false end)

plusButton.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 10
    speedLabel.Text = tostring(flySpeed)
end)
minusButton.MouseButton1Click:Connect(function()
    if flySpeed > 10 then
        flySpeed = flySpeed - 10
        speedLabel.Text = tostring(flySpeed)
    end
end)
