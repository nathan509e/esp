local v1 = game:GetService("Players")
local v2 = game:GetService("RunService")
local v3 = game:GetService("UserInputService")
local v4 = game:GetService("Workspace")

local v5 = v1.LocalPlayer
local v6 = v5:WaitForChild("PlayerGui")
local v7 = v4.CurrentCamera

local v8 = {
  enabled = true,
  names = true,
  visibleHue = 0.33,
  hiddenHue = 0,
  allyHue = 0.58,
  fill = 0.35,
  outline = 0,
  distance = 1200,
  interval = 0.06,
}

local v9 = {}
local v10 = {}
local v11 = 0

local v12 = v6:FindFirstChild("ESPSettings")
if v12 then
  v12:Destroy()
end

local v13 = RaycastParams.new()
v13.FilterType = Enum.RaycastFilterType.Exclude
v13.IgnoreWater = true

local function f1(p1)
  if not p1 or p1 == v5 then
    return true
  end

  return v5.Team ~= nil
    and p1.Team ~= nil
    and p1.Team == v5.Team
end

local function f2()
  local p2 = {}

  if v5.Character then
    table.insert(p2, v5.Character)
  end

  v13.FilterDescendantsInstances = p2
end

local function f3(p3)
  local p4 = p3 and p3.Character
  if not p4 then
    return nil
  end

  local p5 = p4:FindFirstChildOfClass("Humanoid")
  if not p5 or p5.Health <= 0 then
    return nil
  end

  local p6 = p4:FindFirstChild("Head")
  if not p6 then
    return nil
  end

  return p4, p5, p6
end

local function f4(p7)
  if not v7 then
    return false
  end

  local p8, _, p9 = f3(p7)
  if not p8 then
    return false
  end

  local p10 = v7.CFrame.Position
  local p11 = p9.Position - p10
  local p12 = v4:Raycast(p10, p11, v13)

  if not p12 then
    return true
  end

  return p12.Instance:IsDescendantOf(p8)
end

local function f5(p13)
  return Color3.fromHSV(p13, 1, 1)
end

local function f6(p14)
  if p14 == v5 then
    return
  end

  local function f7(p15)
    if v9[p14] then
      v9[p14]:Destroy()
      v9[p14] = nil
    end

    if v10[p14] then
      v10[p14]:Destroy()
      v10[p14] = nil
    end

    local p16 = Instance.new("Highlight")
    p16.Name = "PlayerESP"
    p16.Adornee = p15
    p16.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    p16.FillTransparency = 1 - v8.fill
    p16.OutlineTransparency = v8.outline
    p16.Enabled = false
    p16.Parent = p15

    v9[p14] = p16

    task.spawn(function()
      local p17 = p15:FindFirstChild("Head")

      if not p17 then
        p17 = p15:WaitForChild("Head", 5)
      end

      if not p17 or p14.Character ~= p15 then
        return
      end

      if v10[p14] then
        v10[p14]:Destroy()
        v10[p14] = nil
      end

      local p18 = Instance.new("BillboardGui")
      p18.Name = "PlayerNameESP"
      p18.Adornee = p17
      p18.Size = UDim2.fromOffset(220, 40)
      p18.StudsOffset = Vector3.new(0, 2.2, 0)
      p18.AlwaysOnTop = true
      p18.MaxDistance = v8.distance
      p18.Enabled = false
      p18.Parent = v6

      local p19 = Instance.new("TextLabel")
      p19.Size = UDim2.fromScale(1, 1)
      p19.BackgroundTransparency = 1
      p19.Text = p14.Name
      p19.TextColor3 = Color3.new(1, 1, 1)
      p19.TextStrokeColor3 = Color3.new(0, 0, 0)
      p19.TextStrokeTransparency = 0
      p19.Font = Enum.Font.GothamBold
      p19.TextSize = 14
      p19.Parent = p18

      v10[p14] = p18
    end)
  end

  if p14.Character then
    f7(p14.Character)
  end

  p14.CharacterAdded:Connect(f7)
end

local function f8(p20)
  if v9[p20] then
    v9[p20]:Destroy()
    v9[p20] = nil
  end

  if v10[p20] then
    v10[p20]:Destroy()
    v10[p20] = nil
  end
end

local function f9()
  v7 = v4.CurrentCamera or v7

  if not v7 then
    return
  end

  local p21 = f5(v8.visibleHue)
  local p22 = f5(v8.hiddenHue)
  local p23 = v5.Character
  local p24 = p23 and p23:FindFirstChild("HumanoidRootPart")

  for p25, p26 in pairs(v9) do
    if not p26.Parent then
      continue
    end

    local p27 = f1(p25)
    local p28, _, p29 = f3(p25)

    if not p28 then
      p26.Enabled = false

      local p30 = v10[p25]
      if p30 then
        p30.Enabled = false
      end

      continue
    end

    local p31 = p28:FindFirstChild("HumanoidRootPart") or p29
    local p32 = math.huge

    if p24 and p31 then
      p32 = (p31.Position - p24.Position).Magnitude
    elseif p31 then
      p32 = (p31.Position - v7.CFrame.Position).Magnitude
    end

    local p33 = v8.enabled and p32 <= v8.distance

    p26.Enabled = p33
    p26.FillTransparency = 1 - v8.fill
    p26.OutlineTransparency = v8.outline

    if p33 then
      local p34 = f4(p25)
      local p35

      if p27 then
        p35 = f5(v8.allyHue)
      else
        p35 = p34 and p21 or p22
      end

      p26.FillColor = p35
      p26.OutlineColor = p35
    end

    local p36 = v10[p25]

    if p36 then
      p36.Enabled = p33 and v8.names
      p36.MaxDistance = v8.distance
    end
  end
end

f2()

v5.CharacterAdded:Connect(function()
  task.defer(f2)
end)

local v14 = Instance.new("ScreenGui")
v14.Name = "ESPSettings"
v14.ResetOnSpawn = false
v14.IgnoreGuiInset = true
v14.Parent = v6

local v15 = Instance.new("Frame")
v15.Size = UDim2.fromOffset(360, 385)
v15.Position = UDim2.new(0.5, -180, 0.5, -192)
v15.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
v15.BorderSizePixel = 0
v15.Visible = false
v15.Parent = v14

local v16 = Instance.new("UICorner")
v16.CornerRadius = UDim.new(0, 10)
v16.Parent = v15

local v17 = Instance.new("TextLabel")
v17.Size = UDim2.new(1, -20, 0, 35)
v17.Position = UDim2.fromOffset(10, 5)
v17.BackgroundTransparency = 1
v17.Text = "ESP"
v17.TextColor3 = Color3.new(1, 1, 1)
v17.TextSize = 18
v17.Font = Enum.Font.GothamBold
v17.TextXAlignment = Enum.TextXAlignment.Left
v17.Parent = v15

local function f10(p38, p39, p40, p41)
  local p42 = Instance.new("TextButton")
  p42.Size = UDim2.fromOffset(145, 32)
  p42.Position = UDim2.fromOffset(p39, 50)
  p42.BorderSizePixel = 0
  p42.Font = Enum.Font.GothamBold
  p42.TextSize = 14
  p42.TextColor3 = Color3.new(1, 1, 1)
  p42.Parent = v15

  local p43 = Instance.new("UICorner")
  p43.CornerRadius = UDim.new(0, 6)
  p43.Parent = p42

  local p44 = p40

  local function f11()
    p42.Text = p38 .. (p44 and ": ON" or ": OFF")
    p42.BackgroundColor3 = p44
      and Color3.fromRGB(40, 150, 80)
      or Color3.fromRGB(150, 50, 50)
  end

  p42.MouseButton1Click:Connect(function()
    p44 = not p44
    p41(p44)
    f11()
  end)

  f11()
end

f10("ESP", 20, v8.enabled, function(p45)
  v8.enabled = p45
end)

f10("NAMES", 195, v8.names, function(p46)
  v8.names = p46
end)

local function f12(p47, p48)
  local p49 = Instance.new("TextLabel")
  p49.Size = UDim2.new(1, -40, 0, 22)
  p49.Position = UDim2.fromOffset(20, p48)
  p49.BackgroundTransparency = 1
  p49.Text = p47
  p49.TextColor3 = Color3.fromRGB(220, 220, 220)
  p49.Font = Enum.Font.Gotham
  p49.TextSize = 13
  p49.TextXAlignment = Enum.TextXAlignment.Left
  p49.Parent = v15
  return p49
end

local function f13(p50, p51, p52)
  local p53 = Instance.new("Frame")
  p53.Size = UDim2.new(1, -40, 0, 18)
  p53.Position = UDim2.fromOffset(20, p50)
  p53.BorderSizePixel = 0
  p53.Parent = v15

  local p54 = Instance.new("UIGradient")
  p54.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
    ColorSequenceKeypoint.new(0.166, Color3.fromHSV(0.166, 1, 1)),
    ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
    ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
    ColorSequenceKeypoint.new(0.666, Color3.fromHSV(0.666, 1, 1)),
    ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
  })
  p54.Parent = p53

  local p55 = Instance.new("Frame")
  p55.Size = UDim2.fromOffset(3, 26)
  p55.AnchorPoint = Vector2.new(0.5, 0.5)
  p55.Position = UDim2.new(p51, 0, 0.5, 0)
  p55.BackgroundColor3 = Color3.new(1, 1, 1)
  p55.BorderSizePixel = 0
  p55.Parent = p53

  local p56 = false

  local function f14(p57)
    local p58 = p57.Position.X - p53.AbsolutePosition.X
    local p59 = math.clamp(p58 / p53.AbsoluteSize.X, 0, 1)
    p55.Position = UDim2.new(p59, 0, 0.5, 0)
    p52(p59)
  end

  p53.InputBegan:Connect(function(p60)
    if p60.UserInputType == Enum.UserInputType.MouseButton1 then
      p56 = true
      f14(p60)
    end
  end)

  v3.InputChanged:Connect(function(p61)
    if p56 and p61.UserInputType == Enum.UserInputType.MouseMovement then
      f14(p61)
    end
  end)

  v3.InputEnded:Connect(function(p62)
    if p62.UserInputType == Enum.UserInputType.MouseButton1 then
      p56 = false
    end
  end)
end

f12("Cor - jogador visível", 105)
f13(132, v8.visibleHue, function(p63)
  v8.visibleHue = p63
end)

f12("Cor - atrás da parede", 170)
f13(197, v8.hiddenHue, function(p64)
  v8.hiddenHue = p64
end)

f12("Cor - aliados", 235)
f13(262, v8.allyHue, function(p65)
  v8.allyHue = p65
end)

f12("INSERT = menu", 315)

v3.InputBegan:Connect(function(p66)
  if p66.KeyCode == Enum.KeyCode.Insert then
    v15.Visible = not v15.Visible
  end
end)

local v18 = false
local v19
local v20

v17.InputBegan:Connect(function(p66)
  if p66.UserInputType == Enum.UserInputType.MouseButton1 then
    v18 = true
    v19 = p66.Position
    v20 = v15.Position
  end
end)

v3.InputChanged:Connect(function(p67)
  if v18 and p67.UserInputType == Enum.UserInputType.MouseMovement then
    local p68 = p67.Position - v19

    v15.Position = UDim2.new(
      v20.X.Scale,
      v20.X.Offset + p68.X,
      v20.Y.Scale,
      v20.Y.Offset + p68.Y
    )
  end
end)

v3.InputEnded:Connect(function(p69)
  if p69.UserInputType == Enum.UserInputType.MouseButton1 then
    v18 = false
  end
end)

v1.PlayerAdded:Connect(f6)
v1.PlayerRemoving:Connect(f8)

task.spawn(function()
  for _, p37 in ipairs(v1:GetPlayers()) do
    task.spawn(f6, p37)
  end
end)

v2.RenderStepped:Connect(function(p70)
  v11 += p70

  if v11 >= v8.interval then
    v11 = 0
    f9()
  end
end)
