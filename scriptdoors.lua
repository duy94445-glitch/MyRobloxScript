--== FULL GUI + ESP + LOCAL PLAYER + CHAT ALERTS ==--

local player = game.Players.LocalPlayer
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

local function highlightObject(obj, color)
    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = color
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.OutlineTransparency = 0
    hl.Parent = obj
end

local function createESP(parent, name, posY, findFunc, color)
    local running = false
    createToggle(parent, name, posY, function(state)
        running = state
        if running then
            task.spawn(function()
                while running do
                    for _, obj in ipairs(findFunc()) do
                        if not obj:FindFirstChildOfClass("Highlight") then
                            highlightObject(obj, color)
                        end
                    end
                    task.wait(2)
                end
            end)
        else
            for _, obj in ipairs(findFunc()) do
                local hl = obj:FindFirstChildOfClass("Highlight")
                if hl then hl:Destroy() end
            end
        end
    end)
end

local function addESPEntities(tabName, entities, startY, color)
    local posY = startY or 10
    for _, entityName in ipairs(entities) do
        createESP(tabFrames[tabName], "ESP "..entityName, posY, function()
            local foundObjects = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:lower():find(entityName:lower()) then
                    table.insert(foundObjects, obj)
                end
            end
            return foundObjects
        end, color)
        posY = posY + 40
    end
end

--== ESP ==--

-- Hotel
addESPEntities("Hotel", {"Rush","Ambush","Figure","Seek","Snare","Window"}, 10, Color3.fromRGB(255,0,0))
createESP(tabFrames["Hotel"], "ESP Pin", 250, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Pin" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(0,255,255))
createESP(tabFrames["Hotel"], "ESP Sách", 290, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Book" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(0,200,255))
createESP(tabFrames["Hotel"], "ESP Key", 330, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Key" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(255,215,0))

-- Mines
addESPEntities("The Mine", {"Rush","Ambush","Figure","Seek","Giggle","Grumble","Gloombat"}, 10, Color3.fromRGB(255,0,0))
createESP(tabFrames["The Mine"], "ESP Điện", 250, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Electric" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(0,255,100))
createESP(tabFrames["The Mine"], "ESP Máy", 290, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Machine" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(0,100,255))

-- Backdoors
addESPEntities("The Backdoors", {"Bliz","Lookman","Lever Timer"}, 10, Color3.fromRGB(255,0,0))
createESP(tabFrames["The Backdoors"], "ESP Key", 250, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Key" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(255,215,0))

-- Outdoors
addESPEntities("The Outdoors", {"Suge","Mandrake","Groundskeeper","Eyestalk","Bramble","Monument"}, 10, Color3.fromRGB(255,0,0))
createESP(tabFrames["The Outdoors"], "ESP Cần gạt", 290, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Lever" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(200,200,0))

-- Rooms
addESPEntities("The Rooms", {"A-60","A-120"}, 10, Color3.fromRGB(255,0,0))

-- Skip
addESPEntities("Skip", {"Bypass Screech","Bypass A-90","Bypass Seek","Bypass Halt","Bypass Eyestalk"}, 10, Color3.fromRGB(255,0,0))
createESP(tabFrames["Skip"], "ESP Cửa đúng", 250, function()
    local t = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "CorrectDoor" then table.insert(t, obj) end
    end
    return t
end, Color3.fromRGB(255,0,255))

--== Local Player ==--
local lpTab = tabFrames["Local Player"]

-- Speed
local speedBox = Instance.new("TextBox", lpTab)
speedBox.Size = UDim2.new(0, 150, 0, 30)
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
    if state then
        godConn = player.Character.Humanoid.HealthChanged:Connect(function(health)
            if health < 200 then
                player.Character.Humanoid.MaxHealth = 300
                player.Character.Humanoid.Health = 300
            end
        end)
    else
        if godConn then godConn:Disconnect() end
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.MaxHealth = 100 end
    end
end)

-- Infinite Jump
local jumpConnection
createToggle(lpTab, "Infinite Jump", 100, function(state)
    if state then
        jumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
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
local defaultBrightness = game.Lighting.Brightness
local defaultGlobalShadows = game.Lighting.GlobalShadows
local defaultAmbient = game.Lighting.Ambient
createToggle(lpTab, "FullBright", 220, function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.GlobalShadows = false
        game.Lighting.Ambient = Color3.new(1,1,1)
    else
        game.Lighting.Brightness = defaultBrightness
        game.Lighting.GlobalShadows = defaultGlobalShadows
        game.Lighting.Ambient = defaultAmbient
    end
end)

-- Noclip
local noclipParts = {}
createToggle(lpTab, "Noclip", 260, function(state)
    if state then
        task.spawn(function()
            while state do
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            noclipParts[part] = true
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        for part, _ in pairs(noclipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
            noclipParts[part] = nil
        end
    end
end)

-- Teleport to Mouse
local mouse = player:GetMouse()
local teleportBtn = Instance.new("TextButton", lpTab)
teleportBtn.Size = UDim2.new(0, 400, 0, 30)
teleportBtn.Position = UDim2.new(0, 10, 0, 300)
teleportBtn.Text = "Teleport to Mouse"
teleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.MouseButton1Click:Connect(function()
    if mouse.Target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = mouse.Hit.p
        player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos) + Vector3.new(0, 5, 0)
    end
end)

--== CHAT ALERTS ==--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local function sendChat(msg)
    pcall(function()
        ChatRemote:FireServer(msg, "All")
    end)
end

workspace.DescendantAdded:Connect(function(obj)
    for alertName, patterns in pairs(Alerts) do
        for _, name in ipairs(patterns) do
            if obj.Name == name or obj.Name:find(name) then
                sendChat(alertName .. " is coming!")
            end
        end
    end
end)
