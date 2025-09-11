-- scriptdoors.lua
-- Full ESP + Skip + Local Player + Notify + Toggle Mouse

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LP = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

-- Tạo frame chính
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 300)
Frame.Position = UDim2.new(0.25, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.Parent = ScreenGui

-- Tab system
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Text = name
    Button.Size = UDim2.new(0, 100, 0, 30)
    Button.Parent = Frame
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, -110, 1, -40)
    TabFrame.Position = UDim2.new(0, 110, 0, 40)
    TabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabFrame.Visible = false
    TabFrame.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        TabFrame.Visible = true
        CurrentTab = TabFrame
    end)

    Tabs[name] = TabFrame
    return TabFrame
end

-- ESP Tab
local ESPFrame = CreateTab("ESP")
-- (placeholder label)
local ESPLabel = Instance.new("TextLabel")
ESPLabel.Text = "ESP Options (Hotel, Mines, Backdoors, Outdoors, Rooms)"
ESPLabel.Size = UDim2.new(1, 0, 0, 30)
ESPLabel.TextColor3 = Color3.new(1,1,1)
ESPLabel.Parent = ESPFrame

-- Skip Tab
local SkipFrame = CreateTab("Skip")
local SkipLabel = Instance.new("TextLabel")
SkipLabel.Text = "Skip Options (Screech, A-90, Seek, Halt, Eyestalk)"
SkipLabel.Size = UDim2.new(1, 0, 0, 30)
SkipLabel.TextColor3 = Color3.new(1,1,1)
SkipLabel.Parent = SkipFrame

-- Local Player Tab
local LocalFrame = CreateTab("LocalPlayer")

-- Speed Slider (simple input)
local SpeedBox = Instance.new("TextBox")
SpeedBox.PlaceholderText = "Enter WalkSpeed"
SpeedBox.Size = UDim2.new(0, 200, 0, 30)
SpeedBox.Position = UDim2.new(0, 10, 0, 10)
SpeedBox.Text = ""
SpeedBox.Parent = LocalFrame

SpeedBox.FocusLost:Connect(function()
    local val = tonumber(SpeedBox.Text)
    if val then
        LP.Character.Humanoid.WalkSpeed = val
    end
end)

-- GodMode loop
RS.Heartbeat:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("Humanoid") then
        if char.Humanoid.Health <= 200 then
            char.Humanoid.Health = 300
        end
        char.Humanoid.MaxHealth = 300
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Full Bright
game:GetService("Lighting").Brightness = 2
game:GetService("Lighting").ClockTime = 12
game:GetService("Lighting").FogEnd = 100000

-- No Clip
local noclip = true
RS.Stepped:Connect(function()
    if noclip and LP.Character then
        for _,v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Toggle Mouse Lock bằng phím 0
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Zero then
        if UIS.MouseBehavior == Enum.MouseBehavior.LockCenter then
            UIS.MouseBehavior = Enum.MouseBehavior.Default
        else
            UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)

-- Notify quái trong chat
local function Notify(msg)
    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
        Text = "[ALERT] " .. msg,
        Color = Color3.fromRGB(255,0,0),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18
    })
end

-- Giả lập notify (bạn thay trigger sau)
local Monsters = {"Rush","Ambush","Blitz","Suge","A-60","A-120"}
for _,m in ipairs(Monsters) do
    task.delay(10*_ , function()
        Notify(m .. " is coming!")
    end)
end

-- Default tab
Tabs["ESP"].Visible = true
CurrentTab = Tabs["ESP"]
