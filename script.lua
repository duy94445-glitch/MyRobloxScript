--// GUI Hack Full cho Roblox (Mobile + PC)
--// Tính năng: Speed, Jump, Fly, Noclip, Godmode, Zoom, ESP, Fullbright, Spectator Teleport (Tốc biến), Anti (Screech, Halt, Seek, A-90, Giggle), Auto heal, NoHitbox
--// Author: ChatGPT x Khiêm

-- Bảo vệ cơ bản
pcall(function() getgenv()._loaded:Disconnect() end)
getgenv()._loaded = Instance.new("BindableEvent")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local cam = Workspace.CurrentCamera
local hrp = nil
local hum = nil

-- GUI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 500)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.Active = true
mainFrame.Draggable = true

local uiList = Instance.new("UIListLayout", mainFrame)
uiList.Padding = UDim.new(0,5)

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1,0,0,25)
statusLabel.Text = "Hack Menu - Active"
statusLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
statusLabel.TextColor3 = Color3.fromRGB(0,255,0)

-- Helper
local function createToggle(name, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(1,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = "[OFF] " .. name
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = (state and "[ON] " or "[OFF] ") .. name
        callback(state)
    end)
end

-- Update character
local function updateChar()
    if player.Character then
        hrp = player.Character:FindFirstChild("HumanoidRootPart")
        hum = player.Character:FindFirstChildOfClass("Humanoid")
    end
end
player.CharacterAdded:Connect(updateChar)
updateChar()

--// 1. Fullbright
createToggle("Fullbright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e9
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.GlobalShadows = true
    end
end)

--// 2. Walkspeed
createToggle("Speed Hack", function(state)
    if state and hum then
        local input = tonumber(game:GetService("Players").LocalPlayer:Kick("Nhập tốc độ ở Console!")) or 50
        hum.WalkSpeed = input
    elseif hum then
        hum.WalkSpeed = 16
    end
end)

--// 3. Jump Power
createToggle("Jump Hack", function(state)
    if state and hum then
        local input = tonumber(game:GetService("Players").LocalPlayer:Kick("Nhập nhảy cao ở Console!")) or 100
        hum.JumpPower = input
    elseif hum then
        hum.JumpPower = 50
    end
end)

--// 4. Noclip
local noclipConn
createToggle("Noclip", function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if hrp then
                for _,v in pairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

--// 5. Fly
local flyConn
createToggle("Fly", function(state)
    if state then
        flyConn = RunService.RenderStepped:Connect(function()
            if hrp then
                local vel = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,50,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel + Vector3.new(0,-50,0) end
                hrp.Velocity = Vector3.new(0, vel.Y, 0)
            end
        end)
    else
        if flyConn then flyConn:Disconnect() end
    end
end)

--// 6. Godmode (v1 + v2)
createToggle("Godmode v1", function(state)
    if state and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    elseif hum then
        hum.MaxHealth = 100
        hum.Health = 100
    end
end)
createToggle("Godmode v2 (NoHitbox)", function(state)
    if state and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v.CanCollide = false
                v.Size = Vector3.new(0,0,0)
            end
        end
    end
end)

--// 7. Zoom unlock + unlock mouse
createToggle("Unlock Zoom", function(state)
    if state then
        player.CameraMaxZoomDistance = 1000
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    else
        player.CameraMaxZoomDistance = 20
    end
end)

--// 8. Auto Heal nếu máu = 255
RunService.Heartbeat:Connect(function()
    if hum and hum.Health == 255 then
        hum.Health = hum.MaxHealth
    end
end)

--// 9. Spectator Teleport (Tốc biến)
local teleportMode = false
local freecamConn
createToggle("Thoát hồn/Tốc biến", function(state)
    teleportMode = state
    if state then
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = hrp and hrp.CFrame or cam.CFrame
        statusLabel.Text = "Thoát hồn - tap để dịch chuyển"
    else
        cam.CameraType = Enum.CameraType.Custom
        cam.CameraSubject = hum
        if freecamConn then freecamConn:Disconnect() end
        statusLabel.Text = "Thoát hồn/Tốc biến đã tắt"
    end
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if teleportMode and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if hrp then
            hrp.CFrame = cam.CFrame
            teleportMode = false
            cam.CameraType = Enum.CameraType.Custom
            cam.CameraSubject = hum
            statusLabel.Text = "Đã tốc biến!"
        end
    end
end)

--// 10. Anti (Screech, Halt, Seek, A-90, Giggle) - dạng đơn giản
local antiFeatures = {"Screech","Halt","Seek","A90","Giggle"}
for _,name in pairs(antiFeatures) do
    createToggle("Anti "..name, function(state)
        if state then
            -- Cơ chế chặn cơ bản: xóa Entity nếu spawn
            Workspace.DescendantAdded:Connect(function(obj)
                if obj.Name:lower():find(name:lower()) then
                    obj:Destroy()
                    statusLabel.Text = "Chặn "..name
                end
            end)
        end
    end)
end

--// 11. ESP cơ bản (Doors/Key/Lever/Items/Monster)
createToggle("ESP Items/Monsters", function(state)
    if state then
        for _,obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") then
                if obj:FindFirstChild("Humanoid") or obj.Name:lower():find("key") or obj.Name:lower():find("door") then
                    local billboard = Instance.new("BillboardGui", obj)
                    billboard.Size = UDim2.new(0,200,0,50)
                    billboard.AlwaysOnTop = true
                    local text = Instance.new("TextLabel", billboard)
                    text.Size = UDim2.new(1,0,1,0)
                    text.TextColor3 = Color3.fromRGB(255,0,0)
                    text.BackgroundTransparency = 1
                    text.Text = obj.Name
                end
            end
        end
    else
        for _,v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") then v:Destroy() end
        end
    end
end)

statusLabel.Text = "Hack GUI đã load thành công!"
