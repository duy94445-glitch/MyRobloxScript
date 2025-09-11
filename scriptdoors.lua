-- Loadstring mẫu:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/duy94445-glitch/MyRobloxScript/refs/heads/main/script.lua"))()

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--== GUI ROOT ==--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UtilityGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0, 30, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255,255,255)
statusLabel.Text = "MiniHack ESP Loaded"

--== UI HELPERS ==--
local function createToggle(name, posY, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 320, 0, 28)
    btn.Position = UDim2.new(0, 15, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = name .. " [OFF]"
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        callback(state)
        statusLabel.Text = name .. (state and " bật" or " tắt")
    end)
end

local function createInput(name, posY, default, callback)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 120, 0, 28)
    label.Position = UDim2.new(0, 15, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = name

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0, 180, 0, 28)
    box.Position = UDim2.new(0, 150, 0, posY)
    box.BackgroundColor3 = Color3.fromRGB(40,40,40)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Text = tostring(default)
    box.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(box.Text)
            if val then callback(val) end
        end
    end)
end

--== ESP WHITELIST ==--
local EntityList = {
    Hotel = {
        Rush = {"Rush","RushMoving"},
        Ambush = {"Ambush"},
        Figure = {"Figure"},
        Seek = {"Seek","Seek_Arm","Seek_Eye"},
        Snare = {"Snare"},
        Window = {"WindowEntity"},
        Book = {"Book"},
        Pin = {"Pin"},
        Key = {"KeyObtain"}
    },
    Mines = {
        Giggle = {"Giggle"},
        Grumble = {"Grumble"},
        Gloombat = {"Gloombat"},
        Electric = {"ElectricalBox"},
        Machine = {"Generator"}
    },
    Backdoors = {
        Bliz = {"Bliz"},
        Lookman = {"Lookman"},
        Key = {"KeyObtain"},
        Lever = {"LeverSwitch"}
    },
    Outdoors = {
        Suge = {"Suge"},
        Mandrake = {"Mandrake"},
        Groundskeeper = {"Groundskeeper"},
        Eyestalk = {"Eyestalk"},
        Bramble = {"BramblePlant"},
        Lever = {"BrambleLever"}
    },
    Rooms = {
        A60 = {"A-60"},
        A120 = {"A-120"},
        A90 = {"A-90"}
    },
    Skip = {
        Screech = {"Screech"},
        Seek = {"Seek"},
        Halt = {"Halt"},
        Eyestalk = {"Eyestalk"},
        CorrectDoor = {"Door_Correct"}
    }
}

local function highlightObject(obj, color)
    if not obj or obj:FindFirstChildOfClass("Highlight") then return end
    local hl = Instance.new("Highlight")
    hl.Adornee = obj
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillColor = color
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.OutlineTransparency = 0
    hl.Parent = obj
end

local function enableESP(list, color)
    local function check(obj)
        for _, names in pairs(list) do
            for _, name in ipairs(names) do
                if obj.Name == name or obj.Name:find(name) then
                    highlightObject(obj, color)
                end
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do check(obj) end
    workspace.DescendantAdded:Connect(check)
end

--== LOCAL PLAYER FEATURES ==--
local active = {speed=16, jump=50, godMode=false, noclip=false, fullbright=false}
local Lighting = game:GetService("Lighting")
local oldLightingProps = {}

createInput("Speed", 30, 16, function(v) active.speed=v end)
createInput("JumpPower", 70, 50, function(v) active.jump=v end)

createToggle("God Mode", 110, function(state) active.godMode=state end)
createToggle("Noclip", 150, function(state) active.noclip=state end)
createToggle("FullBright", 190, function(state)
    active.fullbright=state
    if state then
        oldLightingProps.Brightness = Lighting.Brightness
        oldLightingProps.ClockTime = Lighting.ClockTime
        oldLightingProps.FogEnd = Lighting.FogEnd
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
    else
        for k,v in pairs(oldLightingProps) do Lighting[k]=v end
    end
end)
createToggle("Unlock Mouse", 230, function(state)
    UserInputService.MouseBehavior = state and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
end)
createToggle("Ẩn/Hiện GUI", 270, function(state) frame.Visible=not state end)

--== ESP TOGGLES ==--
createToggle("ESP Hotel", 310, function(state) if state then enableESP(EntityList.Hotel, Color3.fromRGB(255,0,0)) end end)
createToggle("ESP Mines", 350, function(state) if state then enableESP(EntityList.Mines, Color3.fromRGB(255,0,0)) end end)
createToggle("ESP Backdoors", 390, function(state) if state then enableESP(EntityList.Backdoors, Color3.fromRGB(255,0,0)) end end)
createToggle("ESP Outdoors", 430, function(state) if state then enableESP(EntityList.Outdoors, Color3.fromRGB(255,0,0)) end end)
createToggle("ESP Rooms", 470, function(state) if state then enableESP(EntityList.Rooms, Color3.fromRGB(255,0,0)) end end)

--== MAIN LOOP ==--
RunService.Stepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then
        hum.WalkSpeed = active.speed
        hum.JumpPower = active.jump
        if active.godMode and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
    if active.noclip and char then
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)
