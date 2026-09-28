local v1 = game:GetService("Players")
local v2 = game:GetService("RunService")
local v3 = game:GetService("UserInputService")

local v4 = v1.LocalPlayer
local v5 = v4:WaitForChild("PlayerGui")
local v6 = workspace.CurrentCamera

local v7 = {
    ESPEnabled = true,
    NameESPEnabled = true,
    VisibleHue = 0.33,
    HiddenHue = 0,
    FillIntensity = 0.35,
    OutlineTransparency = 0,
    ESPUpdateInterval = 0.06,
}

local v8 = {}
local v9 = {}
local v10 = 0

local v11 = v5:FindFirstChild("ESPSettings")
if v11 then
    v11:Destroy()
end

local v12 = RaycastParams.new()
v12.FilterType = Enum.RaycastFilterType.Exclude
v12.IgnoreWater = true

local function f1(p1)
    if not p1 or p1 == v4 then
        return true
    end
    return v4.Team ~= nil and p1.Team ~= nil and p1.Team == v4.Team
end

local function f2()
    local p2 = {}
    if v4.Character then
        table.insert(p2, v4.Character)
    end
    v12.FilterDescendantsInstances = p2
end

local function f3()
    return Color3.fromHSV(v7.VisibleHue, 1, 1)
end

local function f4()
    return Color3.fromHSV(v7.HiddenHue, 1, 1)
end

local function f5(p3)
    local p4 = p3 and p3.Character
    if not p4 then return nil end

    local p5 = p4:FindFirstChildOfClass("Humanoid")
    if not p5 or p5.Health <= 0 then return nil end

    local p6 = p4:FindFirstChild("Head")
    if not p6 then return nil end

    return p4, p5, p6
end

local function f6(p7)
    if not v6 then return false end

    local p8, _, p9 = f5(p7)
    if not p8 then return false end

    local p10 = v6.CFrame.Position
    local p11 = p9.Position - p10
    local p12 = workspace:Raycast(p10, p11, v12)

    if not p12 then
        return true
    end

    return p12.Instance:IsDescendantOf(p8)
end

local function f7(p13, p14)
    if p13 == v4 then return end

    if v9[p13] then
        v9[p13]:Destroy()
        v9[p13] = nil
    end

    local p15 = p14:FindFirstChild("Head") or p14:WaitForChild("Head", 5)
    if not p15 then return end

    local p16 = Instance.new("BillboardGui")
    p16.Name = "PlayerNameESP"
    p16.Adornee = p15
    p16.Size = UDim2.fromOffset(220, 40)
    p16.StudsOffset = Vector3.new(0, 2.2, 0)
    p16.AlwaysOnTop = true
    p16.MaxDistance = 2000
    p16.Enabled = v7.NameESPEnabled and not f1(p13)
    p16.Parent = v5

    local p17 = Instance.new("TextLabel")
    p17.Size = UDim2.fromScale(1, 1)
    p17.BackgroundTransparency = 1
    p17.Text = p13.Name
    p17.TextColor3 = Color3.fromRGB(255, 255, 255)
    p17.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    p17.TextStrokeTransparency = 0
    p17.Font = Enum.Font.GothamBold
    p17.TextSize = 14
    p17.Parent = p16

    v9[p13] = p16
end

local function f8(p18)
    if p18 == v4 then return end

    local function f9(p19)
        if v8[p18] then
            v8[p18]:Destroy()
            v8[p18] = nil
        end

        local p20 = Instance.new("Highlight")
        p20.Name = "PlayerESP"
        p20.Adornee = p19
        p20.FillTransparency = 1 - v7.FillIntensity
        p20.OutlineTransparency = v7.OutlineTransparency
        p20.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        p20.Enabled = not f1(p18)
        p20.Parent = p19

        v8[p18] = p20
        f7(p18, p19)
    end

    if p18.Character then
        f9(p18.Character)
    end

    p18.CharacterAdded:Connect(f9)
end

local function f10(p21)
    if v8[p21] then
        v8[p21]:Destroy()
        v8[p21] = nil
    end

    if v9[p21] then
        v9[p21]:Destroy()
        v9[p21] = nil
    end
end

local function f11(p22, p23)
    local p24 = Instance.new("TextLabel")
    p24.Size = UDim2.new(1, -40, 0, 22)
    p24.Position = UDim2.fromOffset(20, p23)
    p24.BackgroundTransparency = 1
    p24.Text = p22
    p24.TextColor3 = Color3.fromRGB(220, 220, 220)
    p24.Font = Enum.Font.Gotham
    p24.TextSize = 13
    p24.TextXAlignment = Enum.TextXAlignment.Left
    p24.Parent = v14
    return p24
end

local function f12(p25, p26, p27, p28)
    local p29 = Instance.new("TextButton")
    p29.Size = UDim2.fromOffset(150, 32)
    p29.Position = UDim2.fromOffset(p26, 50)
    p29.BorderSizePixel = 0
    p29.Font = Enum.Font.GothamBold
    p29.TextSize = 14
    p29.TextColor3 = Color3.new(1, 1, 1)
    p29.Parent = v14

    local p30 = Instance.new("UICorner")
    p30.CornerRadius = UDim.new(0, 6)
    p30.Parent = p29

    local p31 = p27

    local function f13()
        p29.Text = p25 .. (p31 and ": ON" or ": OFF")
        p29.BackgroundColor3 = p31
            and Color3.fromRGB(40, 150, 80)
            or Color3.fromRGB(150, 50, 50)
    end

    p29.MouseButton1Click:Connect(function()
        p31 = not p31
        p28(p31)
        f13()
    end)

    f13()
    return p29
end

local function f14(p32, p33, p34)
    local p35 = Instance.new("Frame")
    p35.Size = UDim2.new(1, -40, 0, 18)
    p35.Position = UDim2.fromOffset(20, p32)
    p35.BorderSizePixel = 0
    p35.Parent = v14

    local p36 = Instance.new("UIGradient")
    p36.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.166, Color3.fromHSV(0.166, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.666, Color3.fromHSV(0.666, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
    })
    p36.Parent = p35

    local p37 = Instance.new("Frame")
    p37.Size = UDim2.fromOffset(3, 26)
    p37.AnchorPoint = Vector2.new(0.5, 0.5)
    p37.Position = UDim2.new(p33, 0, 0.5, 0)
    p37.BackgroundColor3 = Color3.new(1, 1, 1)
    p37.BorderSizePixel = 0
    p37.Parent = p35

    local p38 = false

    local function f15(p39)
        local p40 = p39.Position.X - p35.AbsolutePosition.X
        local p41 = math.clamp(p40 / p35.AbsoluteSize.X, 0, 1)
        p37.Position = UDim2.new(p41, 0, 0.5, 0)
        p34(p41)
    end

    p35.InputBegan:Connect(function(p42)
        if p42.UserInputType == Enum.UserInputType.MouseButton1 then
            p38 = true
            f15(p42)
        end
    end)

    v3.InputChanged:Connect(function(p43)
        if p38 and p43.UserInputType == Enum.UserInputType.MouseMovement then
            f15(p43)
        end
    end)

    v3.InputEnded:Connect(function(p44)
        if p44.UserInputType == Enum.UserInputType.MouseButton1 then
            p38 = false
        end
    end)
end

local function f16(p45, p46)
    local p47 = Instance.new("Frame")
    p47.Size = UDim2.new(1, -40, 0, 18)
    p47.Position = UDim2.fromOffset(20, p45)
    p47.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    p47.BorderSizePixel = 0
    p47.Parent = v14

    local p48 = Instance.new("Frame")
    p48.Size = UDim2.new(p46, 0, 1, 0)
    p48.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    p48.BorderSizePixel = 0
    p48.Parent = p47

    local p49 = Instance.new("Frame")
    p49.Size = UDim2.fromOffset(3, 26)
    p49.AnchorPoint = Vector2.new(0.5, 0.5)
    p49.Position = UDim2.new(p46, 0, 0.5, 0)
    p49.BackgroundColor3 = Color3.new(1, 1, 1)
    p49.BorderSizePixel = 0
    p49.Parent = p47

    local p50 = false

    local function f17(p51)
        local p52 = p51.Position.X - p47.AbsolutePosition.X
        local p53 = math.clamp(p52 / p47.AbsoluteSize.X, 0, 1)
        p48.Size = UDim2.new(p53, 0, 1, 0)
        p49.Position = UDim2.new(p53, 0, 0.5, 0)
        v7.FillIntensity = p53
    end

    p47.InputBegan:Connect(function(p54)
        if p54.UserInputType == Enum.UserInputType.MouseButton1 then
            p50 = true
            f17(p54)
        end
    end)

    v3.InputChanged:Connect(function(p55)
        if p50 and p55.UserInputType == Enum.UserInputType.MouseMovement then
            f17(p55)
        end
    end)

    v3.InputEnded:Connect(function(p56)
        if p56.UserInputType == Enum.UserInputType.MouseButton1 then
            p50 = false
        end
    end)
end

local function f18()
    local p57 = f3()
    local p58 = f4()

    for p59, p60 in pairs(v8) do
        if not p60.Parent then
            continue
        end

        local p61 = f1(p59)
        p60.Enabled = v7.ESPEnabled and not p61

        local p62 = v9[p59]
        if p62 and p62.Parent then
            p62.Enabled = v7.NameESPEnabled and not p61
        end

        if not v7.ESPEnabled or p61 then
            continue
        end

        p60.FillTransparency = 1 - v7.FillIntensity
        p60.OutlineTransparency = v7.OutlineTransparency

        if f6(p59) then
            p60.FillColor = p57
            p60.OutlineColor = p57
        else
            p60.FillColor = p58
            p60.OutlineColor = p58
        end
    end
end

f2()

v4.CharacterAdded:Connect(function()
    task.wait()
    f2()
end)

for _, p63 in ipairs(v1:GetPlayers()) do
    f8(p63)
end

v1.PlayerAdded:Connect(f8)
v1.PlayerRemoving:Connect(f10)

v13 = Instance.new("ScreenGui")
v13.Name = "ESPSettings"
v13.ResetOnSpawn = false
v13.IgnoreGuiInset = true
v13.Parent = v5

v14 = Instance.new("Frame")
v14.Size = UDim2.fromOffset(370, 390)
v14.Position = UDim2.new(0.5, -185, 0.5, -195)
v14.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
v14.BorderSizePixel = 0
v14.Parent = v13

local v15 = Instance.new("UICorner")
v15.CornerRadius = UDim.new(0, 10)
v15.Parent = v14

local v16 = Instance.new("TextLabel")
v16.Size = UDim2.new(1, -20, 0, 35)
v16.Position = UDim2.fromOffset(10, 5)
v16.BackgroundTransparency = 1
v16.Text = "Player ESP"
v16.TextColor3 = Color3.new(1, 1, 1)
v16.TextSize = 18
v16.Font = Enum.Font.GothamBold
v16.TextXAlignment = Enum.TextXAlignment.Left
v16.Parent = v14

f12("ESP", 20, v7.ESPEnabled, function(p64)
    v7.ESPEnabled = p64
end)

f12("NAMES", 200, v7.NameESPEnabled, function(p65)
    v7.NameESPEnabled = p65
end)

f11("Cor - jogador visível", 100)
f14(128, v7.VisibleHue, function(p66)
    v7.VisibleHue = p66
end)

f11("Cor - atrás da parede", 165)
f14(193, v7.HiddenHue, function(p67)
    v7.HiddenHue = p67
end)

f11("Preenchimento", 230)
f16(258, v7.FillIntensity)

local v17 = f11("INSERT = menu", 315)
v17.TextColor3 = Color3.fromRGB(140, 140, 150)

v14.Visible = false

v3.InputBegan:Connect(function(p68)
    if p68.KeyCode == Enum.KeyCode.Insert then
        v14.Visible = not v14.Visible
    end
end)

local v18 = false
local v19
local v20

v16.InputBegan:Connect(function(p69)
    if p69.UserInputType == Enum.UserInputType.MouseButton1 then
        v18 = true
        v19 = p69.Position
        v20 = v14.Position
    end
end)

v3.InputChanged:Connect(function(p70)
    if v18 and p70.UserInputType == Enum.UserInputType.MouseMovement then
        local p71 = p70.Position - v19
        v14.Position = UDim2.new(
            v20.X.Scale,
            v20.X.Offset + p71.X,
            v20.Y.Scale,
            v20.Y.Offset + p71.Y
        )
    end
end)

v3.InputEnded:Connect(function(p72)
    if p72.UserInputType == Enum.UserInputType.MouseButton1 then
        v18 = false
    end
end)

v2.RenderStepped:Connect(function(p73)
    v6 = workspace.CurrentCamera
    v10 += p73

    if v10 >= v7.ESPUpdateInterval then
        v10 = 0
        f18()
    end
end)
