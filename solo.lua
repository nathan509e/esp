local players = game:GetService("Players")
local runService = game:GetService("RunService")
local workspaceService = game:GetService("Workspace")

local localPlayer = players.LocalPlayer
local currentCamera = workspaceService.CurrentCamera

local v3 = {
  active = true,
  esp = true,
  espBox = true,
  espCorner = false,
  espSkeleton = false,
  espChams = false,
  showNames = true,
  showDistance = true,
  showHealthBar = true,
  showWeapon = true,
  tracers = true,
  visibility = true,
  espDistance = 900,
  tracerDistance = 650,

  espColor = Color3.fromRGB(255, 84, 92),
  nameColor = Color3.fromRGB(238, 243, 252),
  skeletonColor = Color3.fromRGB(255, 255, 255),
  healthHigh = Color3.fromRGB(65, 224, 139),
  healthLow = Color3.fromRGB(236, 89, 98),
  tracerColor = Color3.fromRGB(255, 84, 92),
  chamsColor = Color3.fromRGB(255, 84, 92),
  weaponColor = Color3.fromRGB(157, 171, 194),
  boxOutlineColor = Color3.fromRGB(0, 0, 0),

  connections = {},
  drawings = {},
  playerDrawings = {},
}

local function f1(p1)
  local character = p1 and p1.Character
  local humanoid = character and character:FindFirstChildOfClass("Humanoid")

  if character and humanoid and humanoid.Health > 0 then
    return character, humanoid
  end

  return nil, nil
end

local function f2()
  local character = localPlayer.Character
  local root = character and character:FindFirstChild("HumanoidRootPart")
  return root and root.Position or (currentCamera and currentCamera.CFrame.Position) or Vector3.zero
end

local function f3(p2)
  if not p2 or p2 == localPlayer then
    return false
  end

  if localPlayer.Team ~= nil and p2.Team ~= nil and localPlayer.Team == p2.Team then
    return false
  end

  return f1(p2) ~= nil
end

local function f4(p3, p4)
  if not p3 then
    return false
  end

  local params = RaycastParams.new()
  params.FilterType = Enum.RaycastFilterType.Exclude

  local ignore = {}
  if localPlayer.Character then
    table.insert(ignore, localPlayer.Character)
  end

  params.FilterDescendantsInstances = ignore
  params.IgnoreWater = true

  local origin = p4 or (currentCamera and currentCamera.CFrame.Position)
  if not origin then
    return false
  end

  local result = workspaceService:Raycast(origin, p3.Position - origin, params)
  return result == nil or result.Instance:IsDescendantOf(p3.Parent)
end

local drawing = getgenv and getgenv().Drawing or rawget(_G, "Drawing") or nil
if not drawing and type(Drawing) == "table" then
  drawing = Drawing
end

local v4 = type(drawing) == "table" and type(drawing.new) == "function"

local function f5(p5, p6)
  if not v4 then
    return nil
  end

  local ok, object = pcall(drawing.new, p5)
  if not ok or not object then
    v4 = false
    return nil
  end

  for key, value in pairs(p6 or {}) do
    pcall(function()
      object[key] = value
    end)
  end

  table.insert(v3.drawings, object)
  return object
end

local v5 = {
  on = Color3.fromRGB(65, 224, 139),
  off = Color3.fromRGB(236, 89, 98),
  enemy = Color3.fromRGB(255, 84, 92),
  text = Color3.fromRGB(238, 243, 252),
  muted = Color3.fromRGB(157, 171, 194),
}

local v6 = {
  { "head", "chest" }, { "chest", "pelvis" }, { "chest", "leftUpperArm" },
  { "leftUpperArm", "leftLowerArm" }, { "leftLowerArm", "leftHand" },
  { "chest", "rightUpperArm" }, { "rightUpperArm", "rightLowerArm" },
  { "rightLowerArm", "rightHand" }, { "pelvis", "leftUpperLeg" },
  { "leftUpperLeg", "leftLowerLeg" }, { "leftLowerLeg", "leftFoot" },
  { "pelvis", "rightUpperLeg" }, { "rightUpperLeg", "rightLowerLeg" },
  { "rightLowerLeg", "rightFoot" },
}

local function f6(p7, p8)
  for _, name in ipairs(p8) do
    local part = p7:FindFirstChild(name) or p7:FindFirstChild(name, true)
    if part and part:IsA("BasePart") then
      return part.Position
    end
  end

  return nil
end

local function f7(p9)
  if not p9 then
    return nil
  end

  for _, child in ipairs(p9:GetChildren()) do
    if child:IsA("Tool") then
      return child.Name
    end
  end

  return nil
end

local function f8(p10)
  local head = f6(p10, { "Head" })
  local chest = f6(p10, { "UpperTorso", "Torso" })
  local pelvis = f6(p10, { "LowerTorso", "Torso", "HumanoidRootPart" })

  if not chest then
    chest = pelvis
  end

  if not pelvis then
    pelvis = chest
  end

  local function limb(a, b, c, legacy)
    local p1 = f6(p10, { a })
    local p2 = f6(p10, { b })
    local p3 = f6(p10, { c })
    local old = f6(p10, { legacy })

    if p1 and p2 and p3 then
      return p1, p2, p3
    end

    if old and chest then
      return chest, old, old
    end

    return p1, p2 or p1, p3 or p2 or p1
  end

  local lua, lla, lh = limb("LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm")
  local rua, rla, rh = limb("RightUpperArm", "RightLowerArm", "RightHand", "Right Arm")
  local lul, lll, lf = limb("LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg")
  local rul, rll, rf = limb("RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg")

  return {
    head = head,
    chest = chest,
    pelvis = pelvis,
    leftUpperArm = lua,
    leftLowerArm = lla,
    leftHand = lh,
    rightUpperArm = rua,
    rightLowerArm = rla,
    rightHand = rh,
    leftUpperLeg = lul,
    leftLowerLeg = lll,
    leftFoot = lf,
    rightUpperLeg = rul,
    rightLowerLeg = rll,
    rightFoot = rf,
  }
end

local function f9(p11)
  if not p11 then
    return
  end

  for i = 1, #v6 do
    local bone = p11["bone" .. i]
    if bone then bone.Visible = false end

    local cham = p11["cham" .. i]
    if cham then cham.Visible = false end
  end

  if p11.chamFill then
    p11.chamFill.Visible = false
  end
end

local function f10(p12, p13, p14, p15, p16, p17)
  local points = {}

  for key, worldPos in pairs(f8(p13)) do
    if worldPos then
      local pos = currentCamera:WorldToViewportPoint(worldPos)
      if pos.Z > 0 then
        points[key] = Vector2.new(pos.X, pos.Y)
      end
    end
  end

  for i, pair in ipairs(v6) do
    if p16 and not p12["bone" .. i] then
      p12["bone" .. i] = f5("Line", {
        Thickness = 1.5,
        Color = v3.skeletonColor,
        Transparency = 1,
        ZIndex = 11,
        Visible = false,
      })
    end

    if p17 and not p12["cham" .. i] then
      p12["cham" .. i] = f5("Line", {
        Thickness = 8,
        Color = v3.chamsColor,
        Transparency = 0.48,
        ZIndex = 9,
        Visible = false,
      })
    end

    local a = points[pair[1]]
    local b = points[pair[2]]
    local bone = p12["bone" .. i]
    local cham = p12["cham" .. i]
    local valid = a and b and (a - b).Magnitude > 0.08

    if valid then
      if bone then
        bone.From = a
        bone.To = b
        bone.Color = v3.skeletonColor or p14
        bone.Visible = p16
      end

      if cham then
        cham.From = a
        cham.To = b
        cham.Color = v3.chamsColor or p14
        cham.Thickness = math.clamp(p15 / 17, 5, 16)
        cham.Visible = p17
      end
    else
      if bone then bone.Visible = false end
      if cham then cham.Visible = false end
    end
  end
end

local function f11(p18)
  local existing = v3.playerDrawings[p18]
  if existing then
    return existing
  end

  local objects = {
    box = f5("Square", {
      Filled = false,
      Thickness = 1.5,
      Color = v5.enemy,
      ZIndex = 10,
      Visible = false,
    }),
    outline = f5("Square", {
      Filled = false,
      Thickness = 3.5,
      Color = Color3.new(0, 0, 0),
      ZIndex = 9,
      Visible = false,
    }),
    name = f5("Text", {
      Center = true,
      Size = 13,
      Font = 2,
      Color = v5.text,
      Outline = true,
      ZIndex = 11,
      Visible = false,
    }),
    weapon = f5("Text", {
      Center = true,
      Size = 12,
      Font = 2,
      Color = v5.muted,
      Outline = true,
      ZIndex = 11,
      Visible = false,
    }),
    tracer = f5("Line", {
      Thickness = 1.5,
      Color = v5.enemy,
      ZIndex = 10,
      Visible = false,
    }),
    hpBack = f5("Square", {
      Filled = true,
      Color = Color3.fromRGB(0, 0, 0),
      Transparency = 0.35,
      ZIndex = 10,
      Visible = false,
    }),
    hpFill = f5("Square", {
      Filled = true,
      Color = v5.on,
      Transparency = 0.15,
      ZIndex = 11,
      Visible = false,
    }),
  }

  v3.playerDrawings[p18] = objects
  return objects
end

local function f12(p19)
  if not p19 then
    return
  end

  for _, key in ipairs({ "box", "outline", "name", "weapon", "tracer", "hpBack", "hpFill", "chamFill" }) do
    local object = p19[key]
    if object then
      object.Visible = false
    end
  end

  if p19.corners then
    for _, corner in ipairs(p19.corners) do
      if corner then
        corner.Visible = false
      end
    end
  end

  f9(p19)
end

local function f13()
  currentCamera = workspaceService.CurrentCamera or currentCamera
  if not currentCamera then
    return
  end

  local viewport = currentCamera.ViewportSize
  local screenCenter = Vector2.new(viewport.X * 0.5, viewport.Y * 0.5)
  local screenBottom = Vector2.new(screenCenter.X, viewport.Y - 4)
  local origin = f2()

  for _, player in ipairs(players:GetPlayers()) do
    local draw = v3.playerDrawings[player]

    if not (v3.esp or v3.tracers) or not f3(player) then
      if draw then
        f12(draw)
      end
    else
      draw = draw or f11(player)

      local character = f1(player)
      local root = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChildWhichIsA("BasePart")
      )
      local head = character and (character:FindFirstChild("Head") or root)

      if not root or not head then
        f12(draw)
      else
        local rootPos = root.Position
        local distance = (rootPos - origin).Magnitude
        local rootScreen, onScreen = currentCamera:WorldToViewportPoint(rootPos)

        if rootScreen.Z <= 0 then
          f12(draw)
        else
          local top = currentCamera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
          local bottom = currentCamera:WorldToViewportPoint(rootPos - Vector3.new(0, 3, 0))

          local height = math.max(math.abs(bottom.Y - top.Y), 12)
          local width = height * 0.55
          local left = rootScreen.X - width * 0.5
          local y = top.Y
          local boxPosition = Vector2.new(left, y)
          local boxSize = Vector2.new(width, height)

          local inRange = distance <= v3.espDistance
          local visibleOnScreen = onScreen == true
          local showMain = v3.esp and inRange and visibleOnScreen
          local color = v3.espColor or v5.enemy

          draw.outline.Position = boxPosition
          draw.outline.Size = boxSize
          draw.outline.Color = v3.boxOutlineColor or Color3.new(0, 0, 0)
          draw.outline.Visible = showMain and v3.espBox

          draw.box.Position = boxPosition
          draw.box.Size = boxSize
          draw.box.Color = color
          draw.box.Visible = showMain and v3.espBox

          if v3.espCorner then
            if not draw.corners then
              draw.corners = {}
              for i = 1, 8 do
                draw.corners[i] = f5("Line", {
                  Thickness = 2,
                  Color = color,
                  ZIndex = 10,
                  Visible = false,
                })
              end
            end

            local segment = math.clamp(width * 0.25, 4, 14)
            local right = left + width
            local bottomY = y + height
            local corners = draw.corners

            local function c(i, a, b)
              local line = corners[i]
              if line then
                line.From = a
                line.To = b
                line.Color = color
                line.Visible = showMain
              end
            end

            c(1, Vector2.new(left, y), Vector2.new(left + segment, y))
            c(2, Vector2.new(left, y), Vector2.new(left, y + segment))
            c(3, Vector2.new(right, y), Vector2.new(right - segment, y))
            c(4, Vector2.new(right, y), Vector2.new(right, y + segment))
            c(5, Vector2.new(left, bottomY), Vector2.new(left + segment, bottomY))
            c(6, Vector2.new(left, bottomY), Vector2.new(left, bottomY - segment))
            c(7, Vector2.new(right, bottomY), Vector2.new(right - segment, bottomY))
            c(8, Vector2.new(right, bottomY), Vector2.new(right, bottomY - segment))
          elseif draw.corners then
            for _, corner in ipairs(draw.corners) do
              if corner then corner.Visible = false end
            end
          end

          if v3.espChams and showMain and not draw.chamFill then
            draw.chamFill = f5("Square", {
              Filled = true,
              Color = v3.chamsColor or color,
              Transparency = 0.2,
              ZIndex = 8,
              Visible = false,
            })
          end

          if draw.chamFill then
            if showMain and v3.espChams then
              draw.chamFill.Position = boxPosition
              draw.chamFill.Size = boxSize
              draw.chamFill.Color = v3.chamsColor or color
              draw.chamFill.Visible = true
            else
              draw.chamFill.Visible = false
            end
          end

          if showMain and (v3.espSkeleton or v3.espChams) then
            f10(draw, character, color, height, v3.espSkeleton, v3.espChams)
          else
            f9(draw)
          end

          local visible = true
          if v3.visibility then
            visible = f4(head, origin)
          end

          color = visible and (v3.espColor or v5.enemy) or (v3.espColor or v5.enemy)
          draw.box.Color = color

          if v3.showNames or v3.showDistance then
            local parts = {}

            if v3.showNames then
              parts[#parts + 1] = player.Name
            end

            if v3.showDistance then
              parts[#parts + 1] = string.format("[%dm]", math.floor(distance + 0.5))
            end

            draw.name.Position = Vector2.new(rootScreen.X, top.Y - 18)
            draw.name.Text = table.concat(parts, "  ")
            draw.name.Color = v3.nameColor or v5.text
            draw.name.Visible = showMain and #parts > 0
          else
            draw.name.Visible = false
          end

          if v3.showWeapon and showMain then
            local weapon = f7(character)
            draw.weapon.Position = Vector2.new(rootScreen.X, top.Y - (draw.name.Visible and 32 or 18))
            draw.weapon.Text = weapon or ""
            draw.weapon.Color = v3.weaponColor or v5.muted
            draw.weapon.Visible = weapon ~= nil
          else
            draw.weapon.Visible = false
          end

          if v3.showHealthBar and showMain then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local ratio = 1

            if humanoid and humanoid.MaxHealth > 0 then
              ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            end

            local x = left - 6
            local fillHeight = math.max(height * ratio, 0)

            draw.hpBack.Position = Vector2.new(x, y)
            draw.hpBack.Size = Vector2.new(3, height)
            draw.hpBack.Visible = true

            draw.hpFill.Position = Vector2.new(x, y + (height - fillHeight))
            draw.hpFill.Size = Vector2.new(3, fillHeight)
            draw.hpFill.Color = (v3.healthLow or v5.off):Lerp(v3.healthHigh or v5.on, ratio)
            draw.hpFill.Visible = true
          else
            draw.hpBack.Visible = false
            draw.hpFill.Visible = false
          end

          if v3.tracers and visibleOnScreen and distance <= v3.tracerDistance then
            draw.tracer.From = screenBottom
            draw.tracer.To = Vector2.new(
              math.clamp(rootScreen.X, 0, viewport.X),
              math.clamp(rootScreen.Y, 0, viewport.Y)
            )
            draw.tracer.Color = v3.tracerColor or color
            draw.tracer.Visible = true
          else
            draw.tracer.Visible = false
          end
        end
      end
    end
  end
end

local library = loadstring(game:HttpGet(
  "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
))()

local themeManager = loadstring(game:HttpGet(
  "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"
))()

local saveManager = loadstring(game:HttpGet(
  "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"
))()

local window = library:CreateWindow({
  Title = "ESP",
  Footer = "ESP only",
  Center = true,
  AutoShow = true,
})

local tabs = {
  Visuals = window:AddTab("Visuals", "eye"),
  Settings = window:AddTab("Settings", "settings"),
}

local esp = tabs.Visuals:AddLeftGroupbox("ESP")

esp:AddToggle("EspEnabled", {
  Text = "ESP",
  Default = v3.esp,
  Callback = function(value) v3.esp = value end,
})

esp:AddToggle("EspTracers", {
  Text = "Tracers",
  Default = v3.tracers,
  Callback = function(value) v3.tracers = value end,
})

esp:AddToggle("EspBox", {
  Text = "Style: Box",
  Default = v3.espBox,
  Callback = function(value) v3.espBox = value end,
})

esp:AddToggle("EspCorner", {
  Text = "Style: Corner",
  Default = v3.espCorner,
  Callback = function(value) v3.espCorner = value end,
})

esp:AddToggle("EspSkeleton", {
  Text = "Style: Skeleton",
  Default = v3.espSkeleton,
  Callback = function(value) v3.espSkeleton = value end,
})

esp:AddToggle("EspChams", {
  Text = "Style: Chams",
  Default = v3.espChams,
  Callback = function(value) v3.espChams = value end,
})

esp:AddToggle("EspShowNames", {
  Text = "Names",
  Default = v3.showNames,
  Callback = function(value) v3.showNames = value end,
})

esp:AddToggle("EspShowDistance", {
  Text = "Distance",
  Default = v3.showDistance,
  Callback = function(value) v3.showDistance = value end,
})

esp:AddToggle("EspShowHealthBar", {
  Text = "Health Bar",
  Default = v3.showHealthBar,
  Callback = function(value) v3.showHealthBar = value end,
})

esp:AddToggle("EspShowWeapon", {
  Text = "Weapon ESP",
  Default = v3.showWeapon,
  Callback = function(value) v3.showWeapon = value end,
})

esp:AddLabel("Enemy Color"):AddColorPicker("EspColor", {
  Default = v3.espColor,
  Title = "Enemy Color",
  Callback = function(value) v3.espColor = value end,
})

esp:AddLabel("Name Color"):AddColorPicker("NameColor", {
  Default = v3.nameColor,
  Title = "Name Color",
  Callback = function(value) v3.nameColor = value end,
})

esp:AddLabel("Weapon Color"):AddColorPicker("WeaponColor", {
  Default = v3.weaponColor,
  Title = "Weapon Color",
  Callback = function(value) v3.weaponColor = value end,
})

esp:AddLabel("Skeleton Color"):AddColorPicker("SkeletonColor", {
  Default = v3.skeletonColor,
  Title = "Skeleton Color",
  Callback = function(value) v3.skeletonColor = value end,
})

esp:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
  Default = v3.chamsColor,
  Title = "Chams Color",
  Callback = function(value) v3.chamsColor = value end,
})

esp:AddLabel("Tracer Color"):AddColorPicker("TracerColor", {
  Default = v3.tracerColor,
  Title = "Tracer Color",
  Callback = function(value) v3.tracerColor = value end,
})

esp:AddLabel("Box Outline"):AddColorPicker("BoxOutlineColor", {
  Default = v3.boxOutlineColor,
  Title = "Box Outline",
  Callback = function(value) v3.boxOutlineColor = value end,
})

esp:AddLabel("HP High"):AddColorPicker("HealthHigh", {
  Default = v3.healthHigh,
  Title = "HP High",
  Callback = function(value) v3.healthHigh = value end,
})

esp:AddLabel("HP Low"):AddColorPicker("HealthLow", {
  Default = v3.healthLow,
  Title = "HP Low",
  Callback = function(value) v3.healthLow = value end,
})

esp:AddSlider("EspDistance", {
  Text = "ESP Distance",
  Default = v3.espDistance,
  Min = 100,
  Max = 2000,
  Rounding = 0,
  Callback = function(value) v3.espDistance = value end,
})

esp:AddSlider("EspTracerDistance", {
  Text = "Tracer Distance",
  Default = v3.tracerDistance,
  Min = 100,
  Max = 1500,
  Rounding = 0,
  Callback = function(value) v3.tracerDistance = value end,
})

local menu = tabs.Settings:AddLeftGroupbox("Menu")
menu:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
  Default = "Delete",
  NoUI = true,
  Text = "Menu keybind",
  Mode = "Toggle",
})

library.ToggleKeybind = library.Options.MenuKeybind

local renderConnection = runService.RenderStepped:Connect(function()
  if v3.active then
    f13()
  end
end)

table.insert(v3.connections, renderConnection)

local removeConnection = players.PlayerRemoving:Connect(function(player)
  local draw = v3.playerDrawings[player]
  if draw then
    f12(draw)
    v3.playerDrawings[player] = nil
  end
end)

table.insert(v3.connections, removeConnection)

function v3:Unload()
  if not self.active then
    return
  end

  self.active = false

  for _, connection in ipairs(self.connections) do
    pcall(function()
      connection:Disconnect()
    end)
  end

  for _, object in ipairs(self.drawings) do
    pcall(function()
      object:Remove()
    end)
  end

  self.drawings = {}
  self.playerDrawings = {}
end

themeManager:SetLibrary(library)
saveManager:SetLibrary(library)
saveManager:IgnoreThemeSettings()
saveManager:SetIgnoreIndexes({ "MenuKeybind" })

themeManager:SetFolder("ESPOnly")
saveManager:SetFolder("ESPOnly")
saveManager:BuildConfigSection(tabs.Settings)
themeManager:ApplyToTab(tabs.Settings)

library:OnUnload(function()
  v3:Unload()
end)
