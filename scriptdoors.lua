--== FULL GUI MULTITAB ESP + LOCAL PLAYER + CHAT ALERT (FIXED) ==--

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

--== GUI ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Full_GUI"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 550)
frame.Position = UDim2.new(0.5, -225, 0.5, -275)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true

-- Toggle GUI
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Toggle GUI"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Tabs
local tabs = {"Hotel","The Mine","The Backdoors","The Outdoors","The Rooms","Skip","Local Player"}
local tabFrames = {}

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    return btn
end

local function createTabFrame()
    local tab = Instance.new("Frame", frame)
    tab.Size = UDim2.new(1, -20, 1, -50)
    tab.Position = UDim2.new(0, 10, 0, 40)
    tab.BackgroundTransparency = 1
    tab.Visible = false
    return tab
end

for i, tabName in ipairs(tabs) do
    local btn = createTabButton(tabName, (i-1) * 100)
    local tabFrame = createTabFrame()
    tabFrames[tabName] = tabFrame
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        tabFrame.Visible = true
    end)
    if i == 1 then tabFrame.Visible = true end
end

--== Helpers ==--
local function createToggle(parent, name, posY, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 400, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name.." [OFF]"
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        if callback then callback(state) end
    end)
end

--== ESP System ==--
local ESPConnections = {}
local ESPHighlightedObjs = {}

local function highlightObject(obj, color)
    if ESPHighlightedObjs[obj] then return end
    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = color
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.OutlineTransparency = 0
    hl.Parent = obj
    ESPHighlightedObjs[obj] = hl
end

local function enableESP(names, color, keyName)
    local function check(obj)
        for _, nm in ipairs(names) do
            if obj.Name == nm or obj.Name:lower():find(nm:lower()) then
                highlightObject(obj, color)
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        check(obj)
    end
    local conn = workspace.DescendantAdded:Connect(function(obj)
        check(obj)
    end)
    ESPConnections[keyName] = conn
end

local function disableESP(keyName)
    if ESPConnections[keyName] then
        ESPConnections[keyName]:Disconnect()
        ESPConnections[keyName] = nil
    end
    for obj, hl in pairs(ESPHighlightedObjs) do
        if hl and hl.Parent then
            hl:Destroy()
        end
        ESPHighlightedObjs[obj] = nil
    end
end

local function addESPToggle(tabName, entityNames, posY, color)
    createToggle(tabFrames[tabName], "ESP "..table.concat(entityNames,", "), posY, function(state)
        if state then
            enableESP(entityNames, color, tabName.."_"..entityNames[1])
        else
            disableESP(tabName.."_"..entityNames[1])
        end
    end)
end

--== ESP Entities ==--
-- Hotel
addESPToggle("Hotel", {"Rush","Ambush","Figure","Seek","Snare","Window"}, 10, Color3.fromRGB(255,0,0))
addESPToggle("Hotel", {"Pin"}, 250, Color3.fromRGB(0,255,255))
addESPToggle("Hotel", {"Book"}, 290, Color3.fromRGB(0,200,255))
addESPToggle("Hotel", {"Key"}, 330, Color3.fromRGB(255,215,0))

-- Mines
addESPToggle("The Mine", {"Rush","Ambush","Figure","Seek","Giggle","Grumble","Gloombat"}, 10, Color3.fromRGB(255,0,0))
addESPToggle("The Mine", {"Electric"}, 250, Color3.fromRGB(0,255,100))
addESPToggle("The Mine", {"Machine"}, 290, Color3.fromRGB(0,100,255))

-- Backdoors
addESPToggle("The Backdoors", {"Bliz","Lookman"}, 10, Color3.fromRGB(255,0,0))
addESPToggle("The Backdoors", {"Lever"}, 90, Color3.fromRGB(200,200,0))
addESPToggle("The Backdoors", {"Key"}, 250, Color3.fromRGB(255,215,0))

-- Outdoors
addESPToggle("The Outdoors", {"Suge","Mandrake","Groundskeeper","Eyestalk","Bramble","Monument"}, 10, Color3.fromRGB(255,0,0))
addESPToggle("The Outdoors", {"Lever"}, 290, Color3.fromRGB(200,200,0))

-- Rooms
addESPToggle("The Rooms", {"A-60","A-120"}, 10, Color3.fromRGB(255,0,0))

-- Skip
addESPToggle("Skip", {"Bypass Screech","Bypass A-90","Bypass Seek","Bypass Halt","Bypass Eyestalk"}, 10, Color3.fromRGB(255,0,0))
addESPToggle("Skip", {"CorrectDoor"}, 250, Color3.fromRGB(255,0,255))

--== Local Player ==--
local lpTab = tabFrames["Local Player"]

-- Speed
local speedBox = Instance.new("TextBox", lpTab)
speedBox.Size = UDim2.new(0, 150, 0, 20)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Speed Value"
speedBox.Text = ""

local setSpeed = Instance.new("TextButton", lpTab)
setSpeed.Size = UDim2.new(0, 100, 0, 30)
setSpeed.Position = UDim2.new(0, 170, 0, 10)
setSpeed.Text = "Set Speed"
setSpeed.MouseButton1Click:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = val
    end
end)

-- God Mode
local godConn
createToggle(lpTab, "God Mode 300 HP", 60, function(state)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end
    if state then
        hum.MaxHealth = 300
        if hum.Health < 300 then hum.Health = 300 end
        godConn = hum.HealthChanged:Connect(function(h)
            if h < 300 then hum.Health = 300 end
        end)
    else
        if godConn then godConn:Disconnect() end
        hum.MaxHealth = 100
    end
end)

-- Infinite Jump
local jumpConnection
createToggle(lpTab, "Infinite Jump", 100, function(state)
    if state then
        jumpConnection = UIS.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    elseif jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
end)

-- Camera Zoom
createToggle(lpTab, "Unlock Camera Zoom", 140, function(state)
    if state then
        player.CameraMaxZoomDistance = 1000
    else
        player.CameraMaxZoomDistance = 128
    end
end)

-- Unlock Mouse
createToggle(lpTab, "Unlock Mouse", 180, function(state)
    player.DevEnableMouseLock = state
end)

-- FullBright
local defBrightness, defShadows, defAmbient = Lighting.Brightness, Lighting.GlobalShadows, Lighting.Ambient
createToggle(lpTab, "FullBright", 220, function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1,1,1)
    else
        Lighting.Brightness = defBrightness
        Lighting.GlobalShadows = defShadows
        Lighting.Ambient = defAmbient
    end
end)

-- Noclip
local noclipRunning = false
createToggle(lpTab, "Noclip", 260, function(state)
    noclipRunning = state
end)
RS.Stepped:Connect(function()
    if noclipRunning and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Teleport to Mouse
local teleportBtn = Instance.new("TextButton", lpTab)
teleportBtn.Size = UDim2.new(0, 400, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 300)
teleportBtn.Text = "Teleport to Mouse"
teleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.MouseButton1Click:Connect(function()
    if mouse.Target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 5, 0)
    end
end)

--== Chat Alerts ==--
local ChatRemote = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")

local Alerts = {
    Rush = {"Rush","RushMoving"},
    Ambush = {"Ambush"},
    Bliz = {"Bliz"},
    Suge = {"Suge"},
    Monument = {"Monument"},
    A60 = {"A-60"},
    A120 = {"A-120"}
}

workspace.DescendantAdded:Connect(function(obj)
    for alertName, patterns in pairs(Alerts) do
        for _, nm in ipairs(patterns) do
            if obj.Name == nm or obj.Name:lower():find(nm:lower()) then
                pcall(function()
                    ChatRemote:FireServer(alertName.." is coming!", "All")
                end)
            end
        end
    end
end)
