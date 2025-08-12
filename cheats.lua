local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Случайные имена для антидетекта
local randomPrefix = tostring(math.random(1000, 9999))
local guiName = "UI_" .. randomPrefix
local flyForceName = "BF_" .. randomPrefix
local highlightName = "HL_" .. randomPrefix
local boxName = "BX_" .. randomPrefix

-- Оптимизация: кэшируем сервисы
local CoreGui = game:GetService("CoreGui")

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 0)
MainFrame.Position = UDim2.new(0.5, -200, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- ... (остальная часть создания GUI без изменений до функции CreateButton) ...

-- Улучшенная функция создания кнопок с защитой от детекта
local function CreateButton(parent, text)
    -- Контейнер для кнопки и подсветки
    local Container = Instance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 44)
    Container.ClipsDescendants = false
    Container.Parent = parent
    
    -- Основная кнопка
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Position = UDim2.new(0, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.AutoButtonColor = false
    Button.Parent = Container
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.PaddingTop = UDim.new(0, 5)
    ButtonPadding.PaddingBottom = UDim.new(0, 5)
    ButtonPadding.PaddingLeft = UDim.new(0, 10)
    ButtonPadding.PaddingRight = UDim.new(0, 10)
    ButtonPadding.Parent = Button
    
    -- Подсветка ПОД кнопкой
    local Highlight = Instance.new("Frame")
    Highlight.Size = UDim2.new(1, 0, 0, 4)
    Highlight.Position = UDim2.new(0, 0, 1, 0)
    Highlight.AnchorPoint = Vector2.new(0, 1)
    Highlight.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Highlight.Visible = false
    Highlight.Parent = Container
    
    -- Уголки для подсветки (только снизу)
    local HighlightCorner = Instance.new("UICorner")
    HighlightCorner.CornerRadius = UDim.new(0, 0, 0, 4)
    HighlightCorner.Parent = Highlight
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 140)
        Highlight.Visible = true
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        Highlight.Visible = false
    end)
    
    return Button
end

-- ... (остальная часть кода без изменений до раздела полета) ...

-- Улучшенный полет с BodyVelocity и BodyGyro для антидетекта
local FlyActive = false
local FlyBodyVelocity, FlyBodyGyro
local FlyConnection
FlyBtn.MouseButton1Click:Connect(function()
    FlyActive = not FlyActive
    FlyBtn.Text = "FLY: " .. (FlyActive and "ON" or "OFF")
    
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
        FlyBodyGyro = nil
    end
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if FlyActive and Player.Character then
        local root = Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Используем BodyVelocity + BodyGyro для лучшего контроля
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Name = flyForceName
        FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
        FlyBodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
        FlyBodyVelocity.Parent = root
        
        FlyBodyGyro = Instance.new("BodyGyro")
        FlyBodyGyro.Name = flyForceName .. "_Gyro"
        FlyBodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        FlyBodyGyro.CFrame = root.CFrame
        FlyBodyGyro.Parent = root
        
        local function updateFly()
            if not FlyActive or not FlyBodyVelocity or not FlyBodyGyro then return end
            local cam = Camera.CFrame
            local moveVec = Vector3.new()
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0,1,0) end
            
            local flySpeed = FlySpeedSlider:GetValue()
            FlyBodyVelocity.Velocity = moveVec * flySpeed
            FlyBodyGyro.CFrame = cam
        end
        
        FlyConnection = RunService.Stepped:Connect(updateFly)
    end
end)

-- Улучшенная невидимость с псевдо-физикой
local InvisibleActive = false
InvisBtn.MouseButton1Click:Connect(function()
    InvisibleActive = not InvisibleActive
    InvisBtn.Text = "INVISIBLE: " .. (InvisibleActive and "ON" or "OFF")
    
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = InvisibleActive and 1 or 0
                part.CastShadow = not InvisibleActive
                
                -- Добавляем ложные свойства для антидетекта
                if InvisibleActive then
                    part.Material = Enum.Material.Glass
                    part.Reflectance = 0.2
                else
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                end
            end
        end
    end
end)

-- Улучшенные чамы с рандомными цветами
local ChamsActive = false
local ChamsCache = {}
local ChamsConnections = {}

local function ApplyChams(player)
    if player == Player then return end
    
    local function applyToCharacter(character)
        if not character then return end
        
        if ChamsCache[player] then
            ChamsCache[player]:Destroy()
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = highlightName
        highlight.FillColor = Color3.new(math.random(), math.random(), math.random())
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Color3.fromRGB(255, 80, 80)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        ChamsCache[player] = highlight
    end
    
    if player.Character then
        applyToCharacter(player.Character)
    end
    
    if ChamsConnections[player] then
        ChamsConnections[player]:Disconnect()
    end
    ChamsConnections[player] = player.CharacterAdded:Connect(applyToCharacter)
end

-- Улучшенные боксы с рандомными размерами
local function ApplyBox(player)
    if player == Player then return end
    
    local function applyToCharacter(character)
        if not character then return end
        
        if BoxesCache[player] then
            BoxesCache[player]:Destroy()
        end
        
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if root then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = boxName
            box.Adornee = root
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(3 + math.random() * 2, 5 + math.random(), 1.5 + math.random())
            box.Transparency = 0.4 + math.random() * 0.1
            box.Color3 = Color3.fromRGB(255, 50 + math.random(50), 50 + math.random(50))
            box.Parent = character
            
            BoxesCache[player] = box
        end
    end
    
    if player.Character then
        applyToCharacter(player.Character)
    end
    
    if BoxesConnections[player] then
        BoxesConnections[player]:Disconnect()
    end
    BoxesConnections[player] = player.CharacterAdded:Connect(applyToCharacter)
end

-- Улучшенный аимбот с FOV ограничением
local AimBotActive = false
local AimBotConnection
local FOV = 100 -- Максимальный угол обзора для цели

local function CanSeeTarget(targetPosition)
    if not Player.Character then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPosition - origin).Unit
    
    -- Проверка угла обзора
    local viewDirection = Camera.CFrame.LookVector
    local dotProduct = viewDirection:Dot(direction)
    local angle = math.deg(math.acos(dotProduct))
    if angle > FOV then return false end
    
    -- Raycast проверка
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {Player.Character}
    raycastParams.IgnoreWater = true
    
    local ray = workspace:Raycast(
        origin, 
        direction * (targetPosition - origin).Magnitude,
        raycastParams
    )
    
    return ray == nil
end

-- Улучшенный ноклип с оптимизацией
local NoclipActive = false
local NoclipConnection
NoclipBtn.MouseButton1Click:Connect(function()
    NoclipActive = not NoclipActive
    NoclipBtn.Text = "NOCLIP: " .. (NoclipActive and "ON" or "OFF")
    
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    if NoclipActive then
        -- Оптимизация: обновляем только при изменении позиции
        local lastPosition = Player.Character.HumanoidRootPart.Position
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                local rootPart = Player.Character.HumanoidRootPart
                if (rootPart.Position - lastPosition).Magnitude > 0.1 then
                    for _, part in ipairs(Player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    lastPosition = rootPart.Position
                end
            end
        end)
    end
end)

-- Анти-анализ защита
local function AntiAnalysis()
    -- Ложные соединения
    for i = 1, 5 do
        spawn(function()
            while true do
                wait(math.random(5, 15))
                -- Ложные сетевые запросы
                pcall(function()
                    game:GetService("HttpService"):GetAsync("https://google.com", true)
                end)
            end
        end)
    end
    
    -- Ложные объекты
    local fakeParts = {}
    for i = 1, 3 do
        local part = Instance.new("Part")
        part.Transparency = 1
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        part.Name = "DebugPart_" .. math.random(1000,9999)
        table.insert(fakeParts, part)
    end
    
    -- Периодическое изменение свойств
    spawn(function()
        while true do
            wait(math.random(10, 30))
            for _, part in ipairs(fakeParts) do
                pcall(function()
                    part.Position = Vector3.new(math.random(-100,100), math.random(10,50), math.random(-100,100))
                end)
            end
        end
    end)
end

-- Запускаем анти-анализ
AntiAnalysis()

-- Функция для скрытия GUI при скриншотах
local function HideGUI()
    ScreenGui.Enabled = false
    wait(0.5)
    ScreenGui.Enabled = true
end

-- Скрываем GUI при нажатии PrtScn
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Print then
        HideGUI()
    end
end)
