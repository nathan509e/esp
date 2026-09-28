local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local workspaceService = game:GetService("Workspace")
local collectionService = game:GetService("CollectionService")
local v1 = getgenv and getgenv() or _G

if type(v1.__P13687899540_BALLISTICS_PROBE) == "table" then
end

local localPlayer = players.LocalPlayer

local function f1(p1)
  if type(table.clone) == "function" then
    return table.clone(p1)
  else
    local v2 = {}

    for key, value in pairs(p1) do
      v2[key] = value
    end

    return v2
  end
end

local currentCamera = workspaceService.CurrentCamera

local function f2(p2)
  if type(table.clear) == "function" then
    table.clear(p2)
    return
  end

  for key2 in pairs(p2) do
    p2[key2] = nil
  end
end

local v3 = {
  active = true,
  panelVisible = true,
  menuKeyCode = Enum.KeyCode.Delete,
  menuKeyName = "Delete",
  waitingMenuKey = false,
  activeTab = "combat",
  profile = "rage",
  rageSettings = nil,
  legitLockTarget = nil,
  legitLockSince = 0,
  legitDwell = 0.12,
  legitMaxAngle = 4,
  silentAim = false,
  noRecoil = true,
  _nrUntil = 0,
  _nrLook = nil,
  importBuffer = "",
  esp = true,
  espBox = true,
  espCorner = false,
  espSkeleton = false,
  espChams = false,
  showNames = true,
  showDistance = true,
  showHealthBar = true,
  showWeapon = true,
  espColor = Color3.fromRGB(255, 84, 92),
  espColorSelected = Color3.fromRGB(168, 85, 247),
  nameColor = Color3.fromRGB(238, 243, 252),
  skeletonColor = Color3.fromRGB(255, 255, 255),
  healthHigh = Color3.fromRGB(65, 224, 139),
  healthLow = Color3.fromRGB(236, 89, 98),
  tracerColor = Color3.fromRGB(255, 84, 92),
  fovColor = Color3.fromRGB(168, 85, 247),
  triggerFovColor = Color3.fromRGB(65, 224, 139),
  chamsColor = Color3.fromRGB(255, 84, 92),
  weaponColor = Color3.fromRGB(157, 171, 194),
  boxOutlineColor = Color3.fromRGB(0, 0, 0),
  autoDefense = false,
  defenseTarget = nil,
  defenseThreatScore = 0,
  defenseThreshold = 90,
  nextDefenseScanAt = 0,
  defenseSavedModes = nil,
  defenseSavedAutoRotate = nil,
  defenseRotationHumanoid = nil,
  tracers = true,
  showFov = false,
  triggerbot = false,
  visibility = true,
  prediction = true,
  smartTargeting = false,
  angleAudit = false,
  penetrationAudit = false,
  targetPart = "Torso",
  fovRadius = 180,
  aimDistance = 1200,
  espDistance = 900,
  tracerDistance = 650,
  triggerRadius = 180,
  triggerDelay = 0.065,
  nextTriggerAt = 0,
  firing = false,
  currentTarget = nil,
  currentPart = nil,
  redirectedShots = 0,
  triggerPulls = 0,
  penetrationShots = 0,
  penetrationPierces = 0,
  penetrationStops = 0,
  penetrationReached = 0,
  lastPenetrationLogAt = 0,
  vehicleSpeedEnabled = false,
  vehicleTargetSpeed = 110,
  vehicleFly = false,
  vehicleSpin = false,
  vehicleNoclip = false,
  vehicleNoclipVehicle = nil,
  vehicleNoclipOriginal = {},
  autoRoadkill = false,
  roadkillRadius = 60,
  roadkillTarget = nil,
  roadkillHumanoid = nil,
  roadkillPreviousHealth = nil,
  roadkillLastNearAt = 0,
  roadkillKillsObserved = 0,
  vehicleRoot = nil,
  vehicleLastWaitLogAt = 0,
  vehicleTestRoot = nil,
  vehicleTestMode = nil,
  vehicleTestStartPosition = nil,
  vehicleTestLogAt = 0,
  nextVehicleLookupAt = 0,
  cachedVehicle = nil,
  cachedVehicleRoot = nil,
  cachedVehicleSeat = nil,
  cachedVehicleIsDriver = false,
  authoritativeDamageObservations = 0,
  maxAcceptedAngle = 0,
  angleAuditPending = false,
  lastResult = "ready",
  connections = {},
  cleanups = {},
  drawings = {},
  playerDrawings = {},
  hookReady = false,
  buildingRayHookReady = false,
  assessedTarget = nil,
  visualShotReady = false,
  shotAssessment = nil,
  nextAssessmentAt = 0,
  nextVisualAt = 0,
  nextPanelAt = 0,
  nextBuildingRefreshAt = 0,
  frameMs = 16.7,
  perfVisualMs = 0,
  perfPanelMs = 0,
  perfTriggerMs = 0,
  perfDefenseMs = 0,
  nextVehicleNoclipScanAt = 0,
  nextVehicleNoclipApplyAt = 0,
  localBuildingsHidden = false,
  hiddenBuildingParts = {},
  lastVolleyTool = nil,
  lastMuzzleIndex = 1,
  lastBulletIndex = 1,
  weaponConfigCache = {},
  volleyRoute = nil,
  _warnedNoVolley = false,
}

function v3:Unload(p3)
end

v1.__P13687899540_BALLISTICS_PROBE = v3

local function f3(p4)
  v3.lastResult = tostring(p4)
end

local function f4(p5, p6, p7)
  local waitForChild = p5

  for index, value2 in ipairs(p6) do
    waitForChild = waitForChild and waitForChild:WaitForChild(value2, 12)
  end

  if not waitForChild then
    return nil
  else
    local v4, v5 = pcall(require, waitForChild)

    if not v4 then
      return nil
    end

    return v5
  end
end

local waitForChild2 = localPlayer:WaitForChild("PlayerScripts", 8)

local v6 = waitForChild2
    and f4(waitForChild2, { "BallisticsClient", "ClientFire" }, "ClientFire")
  or nil

local v7 = f4(
  replicatedStorage, { "Shared", "Ballistics", "Sources", "WeaponSource" }, "WeaponSource"
)

local v8 = f4(replicatedStorage, { "Shared", "WeaponConfigManager" }, "WeaponConfigManager")

local v9 = f4(
  replicatedStorage, { "Shared", "Vehicle", "DriverController" }, "DriverController"
)

local v10

if type(v6) == "table" then
  for index2, value3 in ipairs({ "tRa_ASYc_V", "fireVolley" }) do
    if type(v6[value3]) == "function" then
      v10 = value3
      break
    end
  end
end

if not v10 then
  v3._warnedNoVolley = true
  v10 = nil
end

v3.volleyRoute = v10
local waitForChild3 = replicatedStorage:WaitForChild("Inputs", 12)

local waitForChild4 = waitForChild3
waitForChild4 = waitForChild3 and waitForChild3:WaitForChild("WeaponContext", 12)

local waitForChild5 = waitForChild4 and waitForChild4:WaitForChild("Shoot", 12)
local pressed, released

if waitForChild5 then
  pcall(function() pressed = waitForChild5.Pressed end)
  pcall(function() released = waitForChild5.Released end)
end

local function f5(p8)
  local character = p8 and p8.Character
  local humanoid = character and character:FindFirstChildOfClass("Humanoid")

  if character and humanoid and humanoid.Health > 0 then
    return character, humanoid
  end

  return nil, nil
end

local function f6()
  local character2 = localPlayer.Character
  local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
  return humanoidRootPart and humanoidRootPart.Position or currentCamera.CFrame.Position
end

local function f7(p9)
  local v11 = f5(p9)

  if not v11 then
    return nil
  elseif v3.targetPart == "Head" then
    return v11:FindFirstChild("Head")
  else
    return v11:FindFirstChild("UpperTorso") or v11:FindFirstChild("Torso")
      or v11:FindFirstChild("HumanoidRootPart") or v11:FindFirstChild("Head")
  end
end

local function f8(p10)
  if p10 == localPlayer then
    return false
  end

  if localPlayer.Team ~= nil and p10.Team ~= nil and localPlayer.Team == p10.Team then
    return false
  end

  return f5(p10) ~= nil
end

local function f9()
  local character3 = localPlayer.Character

  if not character3 then
    return nil
  end

  for index3, value4 in ipairs(character3:GetChildren()) do
    if value4:IsA("Tool") and value4:GetAttribute("ToolType") == "Weapon" then
      return value4
    end
  end

  return nil
end

local function f10()
  local count = 0

  for key3, value5 in pairs(v3.hiddenBuildingParts) do
    local v12 = key3
    local localTransparencyModifier = value5

    if v12 and v12.Parent then
      if pcall(function() v12.LocalTransparencyModifier = localTransparencyModifier end) then
        count = count + 1
      end
    end
  end

  f2(v3.hiddenBuildingParts)
  v3.localBuildingsHidden = false
  return count
end

local function f11(p11, p12, p13)
  if not p11 then
    return nil
  else
    local lastMuzzleIndex = p12 or v3.lastVolleyTool == p11 and v3.lastMuzzleIndex or 1
    local lastBulletIndex = p13 or v3.lastVolleyTool == p11 and v3.lastBulletIndex or 1

    if type(v8) ~= "table" or type(v8.GetMuzzleConfig) ~= "function" then
      return nil
    else
      local v13 = p11.Name .. ":" .. tostring(lastMuzzleIndex) .. ":"
        .. tostring(lastBulletIndex)

      local v14 = v3.weaponConfigCache[v13]

      if not v14 then
        local v15, v16 = pcall(v8.GetMuzzleConfig, v8, p11.Name, lastMuzzleIndex)

        if not v15 or type(v16) ~= "table" or type(v16.BulletSettings) ~= "table" then
          return nil
        else
          local v17 = v16.BulletSettings[lastBulletIndex]

          if type(v17) ~= "table" then
            return nil
          end

          v14 = {
            speed = tonumber(v17.MuzzleVelocity) or 0,
            drag = tonumber(v17.Drag) or 0,
            spread = tonumber(v17.Spread) or 1,
            fireInterval = 60 / math.max(tonumber(v16.Firerate) or 600, 1),
          }

          v3.weaponConfigCache[v13] = v14
        end
      end

      return {
        tool = p11,
        muzzleIndex = lastMuzzleIndex,
        bulletIndex = lastBulletIndex,
        speed = v14.speed,
        drag = v14.drag,
        spread = v14.spread,
        fireInterval = v14.fireInterval,
        source = p13 and "native" or v3.lastVolleyTool == p11 and "recent" or "config",
      }
    end
  end
end

local function f12()
  local map = workspaceService:FindFirstChild("Map")
  local destructible = map and map:FindFirstChild("Destructible")
  local v18 = {}
  local buildings = destructible and destructible:FindFirstChild("Buildings")

  if buildings then
    table.insert(v18, buildings)
  end

  return v18
end

local f13

local function f14(p14, p15, p16, p17)
  currentCamera = workspaceService.CurrentCamera or currentCamera
  local v19

  if not currentCamera then
    return nil
  else
    local viewportSize = currentCamera.ViewportSize
    local vector = Vector2.new(viewportSize.X * 0.5, viewportSize.Y * 0.5)

    local v20 = p17
    v20 = p17 or f6()

    local v21 = nil
    local v22 = nil

    for index4, value6 in ipairs(players:GetPlayers()) do
      if f8(value6)
        and (not v3.autoDefense or not v3.defenseTarget or value6 == v3.defenseTarget) then
        local v23 = f7(value6)

        if v23 then
          local magnitude = (v23.Position - v20).Magnitude

          if magnitude <= p15 then
            local v24, v25 = currentCamera:WorldToViewportPoint(v23.Position)

            if v25 and v24.Z > 0 then
              local magnitude2 = (Vector2.new(v24.X, v24.Y) - vector).Magnitude

              if magnitude2 <= p14 then
                local v26 = f13(v23, v20)

                if not p16 or v26 then
                  local v27 = v23.Position - currentCamera.CFrame.Position
                  local v28 = 180

                  if v27.Magnitude > 0.001 then
                    local lookVector = currentCamera.CFrame.LookVector
                    v28 = math.deg(math.acos(math.clamp(lookVector:Dot(v27.Unit), -1, 1)))
                  end

                  local v29, v30 = f5(value6)
                  local v31 = v30 and v30.MaxHealth > 0 and v30.Health / v30.MaxHealth or 1

                  if v3.smartTargeting then
                    v19 = (v26 and 0 or 2000) + v31 * 500 + magnitude * 0.3 + v28 * 3
                  else
                    v19 = magnitude2
                  end

                  if not v21 or v19 < v21 then
                    v21 = v19

                    v22 = {
                      player = value6,
                      part = v23,
                      distance = magnitude,
                      screenDistance = magnitude2,
                      screen = v24,
                      visible = v26,
                      angle = v28,
                      score = v19,
                    }
                  end
                end
              end
            end
          end
        end
      end
    end

    return v22
  end
end

local function f15(p18, p19, p20, p21, p22)
  local position = p18.part.Position
  local v32

  if not v3.prediction then
    return position
  else
    local assemblyLinearVelocity = p18.part.AssemblyLinearVelocity

    if assemblyLinearVelocity.Magnitude > 100 then
      assemblyLinearVelocity = assemblyLinearVelocity.Unit * 100
    end

    local v33 = 0
    local count2 = 0

    while true do
      count2 = 1 + count2

      if not (3 >= count2) then
        break
      end

      local magnitude3 = (position + assemblyLinearVelocity * v33 - p19).Magnitude

      if p21 and p21 > 0.0001 and magnitude3 * p21 < p20 * 0.95 then
        v32 = -math.log(1 - magnitude3 * p21 / p20) / p21
      else
        v32 = magnitude3 / math.max(p20, 1)
      end

      v33 = math.clamp(v32, 0, 0.75)
    end

    return position + assemblyLinearVelocity * v33 + Vector3.new(0, 0.5 * p22 * v33 * v33, 0)
  end
end

local function f16(p23, p24, p25)
  if type(v8) ~= "table" or type(v8.GetMuzzleConfig) ~= "function" then
    return 0
  else
    local name = typeof(p23) == "Instance" and p23.Name or tostring(p23)
    local v34, v35 = pcall(v8.GetMuzzleConfig, v8, name, p24)

    if v34 and type(v35) == "table" and type(v35.BulletSettings) == "table" then
      local v36 = v35.BulletSettings[p25]

      if type(v36) == "table" and type(v36.Penetration) == "number" then
        return v36.Penetration
      end

      return 0
    end

    return 0
  end
end

local function f17()
  local v37 = f6()
  local v38, v39

  for index5, value7 in ipairs(players:GetPlayers()) do
    if f8(value7) then
      local v40 = f7(value7)

      if v40 then
        local v41 = not v38
        local magnitude4 = (v40.Position - v37).Magnitude

        if v41 or magnitude4 < v38 then
          v38 = magnitude4
          v39 = { player = value7, part = v40, distance = magnitude4 }
        end
      end
    end
  end

  return v39
end

local function f18()
  if not v3.localBuildingsHidden then
    return 0
  else
    local v42 = f12()

    if #v42 == 0 then
      return 0
    else
      local overlapParams = OverlapParams.new()
      overlapParams.FilterType = Enum.RaycastFilterType.Include
      overlapParams.FilterDescendantsInstances = v42
      overlapParams.MaxParts = 12000

      local v43, v44 = pcall(
        workspaceService.GetPartBoundsInRadius, workspaceService, f6(), 400, overlapParams
      )

      if not v43 then
        return 0
      else
        local count3 = 0

        for index6, value8 in ipairs(v44) do
          local v45 = value8
          local model = v45:FindFirstAncestorOfClass("Model")

          if v3.hiddenBuildingParts[v45] == nil
            and (not model or not model:FindFirstChildOfClass("Humanoid")) then
            local v46, v47 = pcall(function() return v45.LocalTransparencyModifier end)

            if v46 then
              v3.hiddenBuildingParts[v45] = v47
              pcall(function() v45.LocalTransparencyModifier = 1 end)
              count3 = count3 + 1
            end
          end
        end

        return count3
      end
    end
  end
end

local function f19(p26, p27)
  local v48 = p27.Position - p26

  if v48.Magnitude <= 0.001 then
    return nil
  else
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local v49 = {}

    if localPlayer.Character then
      table.insert(v49, localPlayer.Character)
    end

    local ignore = workspaceService:FindFirstChild("Ignore")

    if ignore then
      table.insert(v49, ignore)
    end

    raycastParams.FilterDescendantsInstances = v49
    raycastParams.IgnoreWater = false

    local raycast = workspaceService:Raycast(p26, v48, raycastParams)

    if not raycast or raycast.Instance:IsDescendantOf(p27.Parent) then
      return nil
    else
      local magnitude5 = nil

      local raycastParams2 = RaycastParams.new()
      raycastParams2.FilterType = Enum.RaycastFilterType.Include
      raycastParams2.FilterDescendantsInstances = { raycast.Instance }

      local unit = v48.Unit

      local raycast2 = workspaceService:Raycast(
        raycast.Position + unit * 64, -unit * 64, raycastParams2
      )

      if raycast2 then
        magnitude5 = (raycast2.Position - raycast.Position).Magnitude
      end

      return {
        instance = raycast.Instance,
        material = tostring(raycast.Material),
        thickness = magnitude5,
      }
    end
  end
end

local function f20(p28, p29, p30, p31)
  if v3.profile ~= "legit" then
    return true
  end

  if not p28 or not p29 or not p29.canFire then
    return false, "NO CLEAR SHOT"
  elseif not p28.visible then
    return false, "NO LINE OF SIGHT"
  elseif v3.legitLockTarget ~= p28.player or os.clock() - v3.legitLockSince < v3.legitDwell then
    return false, "ACQUIRING TARGET"
  else
    local point = p29.point and p29.point - p30

    if not point or point.Magnitude < 0.001 or typeof(p31) ~= "Vector3" or p31.Magnitude < 0.001 then
      return false, "AIM UNAVAILABLE"
    else
      local unit2 = p31.Unit
      local v50 = math.deg(math.acos(math.clamp(unit2:Dot(point.Unit), -1, 1)))

      if v50 > v3.legitMaxAngle then
        return false, string.format("AIM %.1f° > %.1f°", v50, v3.legitMaxAngle)
      end

      return true
    end
  end
end

local function f21()
  if v3.profile == "legit" and not v3.localBuildingsHidden then
    f3("Legit profile keeps building visibility and collision checks intact")
    return
  elseif v3.localBuildingsHidden then
    f3(string.format("local building visuals restored: %d parts", f10()))
    return
  elseif #f12() == 0 then
    f3("building test: static building folder unavailable")
    return
  else
    local v51 = f17()
    local v52 = v51 and f13(v51.part, f6())
    v3.localBuildingsHidden = true
    local v53 = f18()
    local v54 = v51 and f13(v51.part, f6())

    f3(string.format(
      "local buildings hidden: %d nearby parts; LOS %s -> %s; projectile ray filter %s.", v53,
      v52 == nil and "n/a" or tostring(v52), v54 == nil and "n/a" or tostring(v54),
      v3.buildingRayHookReady and "ON" or "unavailable"
    ))

    return
  end
end

function f13(p32, p33)
  local raycastParams3 = RaycastParams.new()
  raycastParams3.FilterType = Enum.RaycastFilterType.Exclude

  local character4 = localPlayer.Character and { localPlayer.Character } or {}

  if v3.localBuildingsHidden then
    for index7, value9 in ipairs(f12()) do
      table.insert(character4, value9)
    end
  end

  raycastParams3.FilterDescendantsInstances = character4
  raycastParams3.IgnoreWater = true

  local position2 = p33 or currentCamera.CFrame.Position
  local raycast3 = workspaceService:Raycast(position2, p32.Position - position2, raycastParams3)
  return raycast3 == nil or raycast3.Instance:IsDescendantOf(p32.Parent)
end

local function f22(p34)
  local handle = p34 and p34:FindFirstChild("Handle")
  return handle and handle:IsA("BasePart") and handle.Position or f6()
end

local function f23(p35, p36, p37, p38)
  local player = p35 and p35.player

  task.delay(1.5, function()
    if not v3.active then
      return
    end

    if not player or player.Parent ~= players then
      f3(string.format("INCONCLUSIVE: %s target left before observation", p37))

      if type(p38) == "function" then
        pcall(p38, false, 0)
      end

      return
    else
      local v55, v56 = f5(player)
      local health = v56 and v56.Health or 0

      if p36 and health < p36 then
        v3.authoritativeDamageObservations = v3.authoritativeDamageObservations + 1

        f3(string.format(
          "VULNERABLE CANDIDATE: %s caused server health %.1f -> %.1f", p37, p36, health
        ))

        if type(p38) == "function" then
          pcall(p38, true, p36 - health)
        end
      else
        f3(string.format("PROTECTED/NO EFFECT: %s produced no observed health loss", p37))

        if type(p38) == "function" then
          pcall(p38, false, 0)
        end
      end

      return
    end
  end)
end

local f24

local function f25(p39, p40, p41)
  local v57, v58 = pcall(f24, p39, p40, p41)

  if v57 and type(v58) == "table" then
    return v58
  end

  return { canFire = false, color = "bad", text = "ASSESSMENT UNAVAILABLE" }
end

function f24(p42, p43, p44)
  if not p42 or not p42.part or not p42.part.Parent then
    return { canFire = false, color = "bad", text = "TARGET LOST" }
  end

  local v59

  if not p42 or not p44 or p44.speed <= 0 then
    return { canFire = false, color = "bad", text = "NO WEAPON DATA" }
  else
    local v60 = f15(p42, p43, p44.speed, p44.drag, workspaceService.Gravity)
    local v61 = v60 - p43
    local magnitude6 = v61.Magnitude

    if magnitude6 < 0.01 then
      return { canFire = false, color = "bad", text = "NO TRAJECTORY" }
    end

    if p44.drag > 0.0001 and magnitude6 * p44.drag < p44.speed * 0.99 then
      v59 = -math.log(1 - magnitude6 * p44.drag / p44.speed) / p44.drag
    else
      v59 = magnitude6 / p44.speed
    end

    if v59 > 1.5 then
      return { canFire = false, color = "bad", text = "OUT OF BALLISTIC RANGE" }
    else
      local raycastParams4 = RaycastParams.new()
      raycastParams4.FilterType = Enum.RaycastFilterType.Exclude

      local v62 = {}

      if localPlayer.Character then
        table.insert(v62, localPlayer.Character)
      end

      table.insert(v62, p42.part.Parent)
      local ignore2 = workspaceService:FindFirstChild("Ignore")

      if ignore2 then
        table.insert(v62, ignore2)
      end

      if v3.localBuildingsHidden then
        for index8, value10 in ipairs(f12()) do
          table.insert(v62, value10)
        end
      end

      raycastParams4.FilterDescendantsInstances = v62
      raycastParams4.IgnoreWater = false

      local unit3 = v61.Unit
      local v63 = p43
      local v64 = v59 <= 0.25 and 3 or v59 <= 0.6 and 5 or 8
      local count4 = 0

      while true do
        count4 = 1 + count4

        if not (v64 >= count4) then
          break
        end

        local v65 = v59 * count4 / v64

        local v66 = p43
            + unit3
              * (p44.drag > 0.0001 and p44.speed / p44.drag * (1 - math.exp(-p44.drag * v65))
                or p44.speed * v65)
          - Vector3.new(0, workspaceService.Gravity * 0.5 * v65 * v65, 0)

        local raycast4 = workspaceService:Raycast(v63, v66 - v63, raycastParams4)

        if raycast4 then
          return {
            canFire = false,
            color = "bad",
            text = "BLOCKED: " .. raycast4.Instance.Name,
            point = v60,
          }
        end

        v63 = v66
      end

      local v67 = magnitude6 * math.tan(math.atan(p44.spread / 3570))
      local v68 = math.max(p42.part.Size.X, p42.part.Size.Y) * 0.5
      local v69 = v67 > v68

      local visible = not v69 and p42.visible and not v3.localBuildingsHidden
        and v67 <= v68 * 0.6 and p42.part.AssemblyLinearVelocity.Magnitude * v59 <= v68 * 2
        and v59 <= 0.35

      return {
        canFire = true,
        color = v69 and "caution" or "good",
        point = v60,
        highConfidence = visible,
        text = string.format(
          "%s%s | %s M%d/B%d (%s) | %.2fs | spread %.1f", v69 and "SPREAD RISK" or "CLEAR ARC",
          visible and " | HIGH CONFIDENCE" or "", p44.tool.Name, p44.muzzleIndex,
          p44.bulletIndex, p44.source, v59, v67
        ),
      }
    end
  end
end

local v70 = type(newcclosure) == "function" and newcclosure or function(p45) return p45 end

local v71 = type(hookfunction) == "function" and type(v6) == "table" and v10
  and type(v6[v10]) == "function"

local v72

if v71 then
  local v73, v74 = pcall(function()
    v72 = hookfunction(v6[v10], v70(function(p46, p47, p48, p49, p50, p51)
      local v75 = p51
      local v76 = p50

      v3.lastVolleyTool = p46
      v3.lastMuzzleIndex = p47
      v3.lastBulletIndex = p48

      if v3.active and v3.noRecoil and type(v76) == "table" and #v76 > 0 then
        local v77 = v76[1]

        if typeof(v77) == "Vector3" and v77.Magnitude > 0.001 then
          local unit4 = v77.Unit

          for i = 1, #v76 do
            v76[i] = unit4
          end
        elseif typeof(v77) == "Vector3" then
          for j = 1, #v76 do
            v76[j] = v77
          end
        end

        if type(v75) == "table" then
          v75 = f1(v75)

          for key4, value11 in pairs(v75) do
            local v78 = string.lower(tostring(key4))

            if string.find(v78, "recoil", 1, true) or string.find(v78, "spread", 1, true)
              or string.find(v78, "bloom", 1, true) or string.find(v78, "kick", 1, true)
              or string.find(v78, "dispersion", 1, true) then
              if type(value11) == "number" then
                v75[key4] = 0
              elseif typeof(value11) == "Vector3" then
                v75[key4] = Vector3.zero
              elseif typeof(value11) == "Vector2" then
                v75[key4] = Vector2.zero
              elseif type(value11) == "boolean" then
                v75[key4] = false
              end
            end
          end
        end

        currentCamera = workspaceService.CurrentCamera or currentCamera

        if currentCamera then
          v3._nrLook = currentCamera.CFrame.LookVector
          v3._nrUntil = os.clock() + 0.18
        end
      end

      local silentAim = v3.active and v3.silentAim and type(v76) == "table" and #v76 > 0
      local v79, v80, health2, v81, onImpact, character5

      if silentAim then
        local v82 = p49
        v82 = p49 or f6()

        v81 = f14(
          v3.fovRadius, v3.aimDistance,
          v3.profile == "legit" or v3.visibility and not v3.penetrationAudit, v82
        )

        if v81 then
          local v83 = f11(p46, p47, p48)
          local v84 = f25(v81, v82, v83)
          v3.shotAssessment = v84
          local v85, v86 = f20(v81, v84, v82, v76[1])

          if not v85 then
            v3.lastResult = "Legit held: " .. tostring(v86)
          end

          local point2 = v85
          point2 = v85 and v84.canFire and v84.point

          if not point2 and v3.penetrationAudit and v83 then
            point2 = f15(v81, v82, v83.speed, v83.drag, workspaceService.Gravity)
          end

          if point2 then
            local v87 = point2 - v82

            if v87.Magnitude > 0.001 then
              local v88 = v76[1]

              if typeof(v88) == "Vector3" and v88.Magnitude > 0.001 then
                local unit5 = v88.Unit
                v79 = math.deg(math.acos(math.clamp(unit5:Dot(v87.Unit), -1, 1)))
              end

              local v89 = f1(v76)
              local v90 = v87.Unit * math.max(v87.Magnitude, 1)
              v89[1] = v90

              if v3.noRecoil then
                local v91 = #v89
                local count5 = 0

                while true do
                  count5 = 1 + count5

                  if not (v91 >= count5) then
                    break
                  end

                  v89[count5] = v90
                end
              end

              v76 = v89

              if v3.noRecoil and type(v75) == "table" then
                local v92 = f1(v75)

                for index9, value12 in ipairs({
                  "Recoil", "recoil", "Spread", "spread", "Bloom", "bloom", "CameraKick",
                  "cameraKick",
                }) do
                  if v92[value12] ~= nil then
                    if type(v92[value12]) == "number" then
                      v92[value12] = 0
                    elseif typeof(v92[value12]) == "Vector3" then
                      v92[value12] = Vector3.zero
                    elseif typeof(v92[value12]) == "Vector2" then
                      v92[value12] = Vector2.zero
                    end
                  end
                end

                v75 = v92
              end

              v3.redirectedShots = v3.redirectedShots + 1
              v3.currentTarget = v81.player
              v3.currentPart = v81.part
              v3.lastResult = "native volley redirected to " .. v81.player.Name

              if v3.angleAudit and not v3.angleAuditPending then
                local v93, v94 = f5(v81.player)
                v80 = v81
                health2 = v94 and v94.Health
                v3.angleAuditPending = health2 ~= nil
              end

              if v3.penetrationAudit then
                v3.penetrationShots = v3.penetrationShots + 1
                local v95 = f19(v82, v81.part)
                local v96 = f16(p46, p47, p48)

                if v95 and os.clock() - v3.lastPenetrationLogAt >= 0.75 then
                  v3.lastPenetrationLogAt = os.clock()

                  f3(string.format("native penetration shot: power %.2f | %s | thickness %s", v96, v95.material, v95.thickness and string.format("%.2f", v95.thickness)
                    or "unknown"))
                end

                local v97 = type(v75) == "table" and v75 or {}
                local v98 = f1(v97)
                onImpact = v97.OnImpact
                character5 = v81.player.Character

                function v98.OnImpact(p52)
                  local instance = type(p52) == "table" and p52.Instance or nil
                  local outcome = type(p52) == "table" and p52.Outcome or nil

                  if instance and character5 and instance:IsDescendantOf(character5) then
                    v3.penetrationReached = v3.penetrationReached + 1

                    v3.lastResult = "native projectile reached " .. v81.player.Name
                      .. " after cover processing"
                  elseif outcome == "Pierce" then
                    v3.penetrationPierces = v3.penetrationPierces + 1
                  elseif outcome == "Stop" then
                    v3.penetrationStops = v3.penetrationStops + 1
                  end

                  if type(onImpact) == "function" then
                    onImpact(p52)
                  end
                end

                v75 = v98
              end
            end
          end
        end
      end

      local v99 = v72(p46, p47, p48, p49, v76, v75)
      local v100

      if v80 and health2 then
        v100 = v79 or 0

        f23(v80, health2, string.format("silent-angle %.1f degrees", v100), function(p53)
          v3.angleAuditPending = false

          if p53 then
            v3.maxAcceptedAngle = math.max(v3.maxAcceptedAngle, v100)

            f3(string.format(
              "angle audit accepted %.1f degrees; max accepted %.1f", v100, v3.maxAcceptedAngle
            ))
          end
        end)
      end

      return v99
    end))
  end)

  if not v73 then
    f3("native volley hook unavailable: " .. tostring(v74))
  end

  if type(v72) == "function" then
    v3.hookReady = true
    table.insert(v3.cleanups, function() pcall(hookfunction, v6[v10], v72) end)
  end
else
  f3("hookfunction unavailable; ESP works, shot redirection unavailable")
end

local v101 = type(hookfunction) == "function" and type(v7) == "table"
  and type(v7.toFireParams) == "function"

local v102

if v101 then
  v102 = nil

  local v103, v104 = pcall(function()
    v102 = hookfunction(v7.toFireParams, v70(function(p54)
      local v105 = p54

      if v3.active and v3.noRecoil and type(v105) == "table" then
        v105 = f1(v105)

        for index10, value13 in ipairs({
          "Spread", "spread", "Recoil", "recoil", "Bloom", "bloom",
        }) do
          if type(v105[value13]) == "number" then
            v105[value13] = 0
          end
        end
      end

      local v106 = v102(v105)

      if v3.active and v3.noRecoil and type(v106) == "table" then
        for index11, value14 in ipairs({
          "Spread", "spread", "Recoil", "recoil", "Bloom", "bloom",
        }) do
          if type(v106[value14]) == "number" then
            v106[value14] = 0
          end
        end
      end

      if v3.active and v3.localBuildingsHidden and v106 and v106.RaycastParams then
        local v107 = f1(v106.RaycastParams.FilterDescendantsInstances)

        for index12, value15 in ipairs(f12()) do
          table.insert(v107, value15)
        end

        v106.RaycastParams.FilterDescendantsInstances = v107
      end

      return v106
    end))
  end)

  if v103 and type(v102) == "function" then
    v3.buildingRayHookReady = true
    table.insert(v3.cleanups, function() pcall(hookfunction, v7.toFireParams, v102) end)
  else
    f3("building projectile filter unavailable: " .. tostring(v104))
  end
end

local f26

local function f27()
  if v3.firing then
    f26(released)
    v3.firing = false
  end
end

local function f28()
  local defenseTarget = v3.defenseTarget

  if not v3.active or not v3.autoDefense or not defenseTarget or not f8(defenseTarget) then
    return
  else
    local v108 = f7(defenseTarget)
    local v109, v110 = f5(localPlayer)
    local humanoidRootPart2 = v109 and v109:FindFirstChild("HumanoidRootPart")
    local currentCamera2 = workspaceService.CurrentCamera or currentCamera
    local v111 = not v108
    currentCamera = currentCamera2

    if v111 or not currentCamera then
      return
    else
      if humanoidRootPart2 and v110 and not v110.SeatPart then
        if v3.defenseRotationHumanoid ~= v110 then
          if v3.defenseRotationHumanoid then
            pcall(function()
              v3.defenseRotationHumanoid.AutoRotate = v3.defenseSavedAutoRotate
            end)
          end

          v3.defenseRotationHumanoid = v110
          v3.defenseSavedAutoRotate = v110.AutoRotate
        end

        if v110.AutoRotate then
          v110.AutoRotate = false
        end

        local vector2 = Vector3.new(
          v108.Position.X, humanoidRootPart2.Position.Y, v108.Position.Z
        )

        local v112 = vector2 - humanoidRootPart2.Position

        if v112.Magnitude > 0.01 and humanoidRootPart2.CFrame.LookVector:Dot(v112.Unit) < 0.9998 then
          humanoidRootPart2.CFrame = CFrame.lookAt(humanoidRootPart2.Position, vector2)
        end
      end

      local position3 = currentCamera.CFrame.Position
      local v113 = v108.Position - position3

      if v113.Magnitude > 0.01 and currentCamera.CFrame.LookVector:Dot(v113.Unit) < 0.99995 then
        currentCamera.CFrame = CFrame.lookAt(position3, v108.Position)
      end

      return
    end
  end
end

function f26(p55)
  if not p55 then
    return false
  end

  if type(firesignal) == "function" then
    if pcall(firesignal, p55) then
      return true
    end
  end

  if type(getconnections) == "function" then
    local v114, v115 = pcall(getconnections, p55)

    if v114 then
      local v116 = false

      for index13, value16 in ipairs(v115) do
        if type(value16.Fire) == "function" then
          v116 = pcall(value16.Fire, value16) or v116
        elseif type(value16.Function) == "function" then
          v116 = pcall(value16.Function) or v116
        end
      end

      if v116 then
        return true
      end

      return false
    end

    return false
  end

  return false
end

local function f29(p56, p57, p58)
  return p57 > 0.0001 and p56 / p57 * (1 - math.exp(-p57 * p58)) or p56 * p58
end

local function f30()
  if v3.firing then
    return
  end

  if not f26(pressed) then
    f3("native Shoot.Pressed signal could not be driven")
    v3.triggerbot = false
    return
  end

  v3.firing = true
  v3.triggerPulls = v3.triggerPulls + 1

  task.delay(0.045, function()
    if v3.active then
      f27()
    end
  end)
end

local function f31(p59)
  if type(v8) ~= "table" or type(v8.MuzzleConfigsOf) ~= "function" then
    return 0
  else
    local v117 = f5(p59)
    local v118 = not v117
    local v119 = f5(localPlayer)

    if v118 or not v119 then
      return 0
    else
      local upperTorso = v119:FindFirstChild("UpperTorso") or v119:FindFirstChild("Torso")
        or v119:FindFirstChild("HumanoidRootPart")

      if not upperTorso then
        return 0
      else
        local v120 = nil

        for index14, value17 in ipairs(v117:GetChildren()) do
          if value17:IsA("Tool") and value17:GetAttribute("ToolType") == "Weapon" then
            v120 = value17
            break
          end
        end

        if not v120 then
          return 0
        else
          local handle2 = v120:FindFirstChild("Handle")

          if not handle2 then
            return 0
          else
            local v121, v122 = pcall(v8.MuzzleConfigsOf, v8, v120.Name)

            if not v121 or type(v122) ~= "table" then
              return 0
            else
              local v123 = 0

              for index15, value18 in ipairs(v122) do
                local findFirstChild = handle2:FindFirstChild("Muzzle" .. index15)

                if findFirstChild and findFirstChild:IsA("Attachment")
                  and type(value18.BulletSettings) == "table" then
                  local worldPosition = findFirstChild.WorldPosition

                  local lookVector2 = (findFirstChild.WorldCFrame
                    * CFrame.Angles(math.rad(value18.DefaultAngle or 0), 0, 0)).LookVector

                  local magnitude7 = (upperTorso.Position - worldPosition).Magnitude

                  if magnitude7 <= v3.aimDistance and magnitude7 > 0.1 then
                    for index16, value19 in ipairs(value18.BulletSettings) do
                      local v124 = tonumber(value19.MuzzleVelocity) or 0
                      local v125 = tonumber(value19.Drag) or 0

                      if v124 > 0 and (v125 <= 0 or magnitude7 * v125 < v124 * 0.99) then
                        local v126 = v125 > 0.0001
                            and -math.log(1 - magnitude7 * v125 / v124) / v125
                          or magnitude7 / v124

                        if v126 <= 0.7 then
                          local assemblyLinearVelocity2 = upperTorso.AssemblyLinearVelocity

                          if assemblyLinearVelocity2.Magnitude > 80 then
                            assemblyLinearVelocity2 = assemblyLinearVelocity2.Unit * 80
                          end

                          local magnitude8 = (worldPosition + lookVector2 * f29(v124, v125, v126) - Vector3.new(
                            0, workspaceService.Gravity * 0.5 * v126 * v126, 0
                          ) - (upperTorso.Position + assemblyLinearVelocity2 * v126)).Magnitude

                          local v127 = math.max(
                            upperTorso.Size.X, upperTorso.Size.Y, upperTorso.Size.Z
                          ) * 0.5 + 0.7

                          local v128 = magnitude7
                            * math.tan(math.atan((tonumber(value19.Spread) or 1) / 3570))

                          if magnitude8 <= v127 + v128 then
                            local raycastParams5 = RaycastParams.new()
                            raycastParams5.FilterType = Enum.RaycastFilterType.Exclude

                            local v129 = { v117, v119 }
                            local ignore3 = workspaceService:FindFirstChild("Ignore")

                            if ignore3 then
                              table.insert(v129, ignore3)
                            end

                            raycastParams5.FilterDescendantsInstances = v129
                            raycastParams5.IgnoreWater = false

                            local v130 = worldPosition
                            local v131 = false
                            local v132 = v126 <= 0.25 and 3 or v126 <= 0.5 and 5 or 8
                            local count6 = 0

                            while true do
                              count6 = 1 + count6

                              if not (count6 <= v132) then
                                break
                              end

                              local v133 = v126 * count6 / v132

                              local v134 = worldPosition + lookVector2 * f29(v124, v125, v133) - Vector3.new(
                                0, workspaceService.Gravity * 0.5 * v133 * v133, 0
                              )

                              if workspaceService:Raycast(v130, v134 - v130, raycastParams5) then
                                v131 = true
                                break
                              end

                              v130 = v134
                            end

                            if not v131 then
                              local v135 = math.clamp(100 - magnitude8 / v127 * 15
                                - v128 / v127 * 7 - v126 * 3, 0, 100)

                              v123 = math.max(v123, math.floor(v135 + 0.5))
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end

              return v123
            end
          end
        end
      end
    end
  end
end

local f32

local function f33()
  if not v3.autoDefense then
    return
  end

  if v3.defenseTarget and not f8(v3.defenseTarget) then
    f32("target eliminated or left")
  end

  if v3.defenseTarget then
    local v136, v137 = pcall(f31, v3.defenseTarget)

    v3.defenseThreatScore = v136 and v137 or 0
    v3.silentAim = true
    v3.triggerbot = true
    v3.visibility = true
    v3.penetrationAudit = false

    return
  else
    local v138 = nil
    local v139 = nil

    for index17, value20 in ipairs(players:GetPlayers()) do
      if f8(value20) then
        local v140, v141 = pcall(f31, value20)

        if v140 and v141 >= v3.defenseThreshold and (not v138 or v141 > v138) then
          v138 = v141
          v139 = value20
        end
      end
    end

    if v139 then
      v3.defenseSavedModes = {
        silentAim = v3.silentAim,
        triggerbot = v3.triggerbot,
        visibility = v3.visibility,
        penetrationAudit = v3.penetrationAudit,
      }

      v3.defenseTarget = v139
      v3.defenseThreatScore = v138
      v3.silentAim = true
      v3.triggerbot = true
      v3.visibility = true
      v3.penetrationAudit = false
      v3.nextTriggerAt = 0

      f3(string.format("auto defense locked %s | modeled threat %d/100", v139.Name, v138))
    end

    return
  end
end

function f32(p60)
  if v3.defenseTarget then
    f3("auto defense released " .. v3.defenseTarget.Name .. (p60 and " (" .. p60 .. ")" or ""))
  end

  v3.defenseTarget = nil
  v3.defenseThreatScore = 0

  f27()

  if v3.defenseSavedModes then
    v3.silentAim = v3.defenseSavedModes.silentAim
    v3.triggerbot = v3.defenseSavedModes.triggerbot
    v3.visibility = v3.defenseSavedModes.visibility
    v3.penetrationAudit = v3.defenseSavedModes.penetrationAudit
    v3.defenseSavedModes = nil
  end

  if v3.defenseRotationHumanoid then
    pcall(function() v3.defenseRotationHumanoid.AutoRotate = v3.defenseSavedAutoRotate end)
    v3.defenseRotationHumanoid = nil
    v3.defenseSavedAutoRotate = nil
  end
end

local v142 = "BallisticsProbeAutoDefense_13687899540"

if pcall(function()
  runService:BindToRenderStep(v142, Enum.RenderPriority.Camera.Value + 1, function()
    if v3.active and v3.autoDefense and v3.defenseTarget then
      pcall(f28)
    end
  end)
end) then
  table.insert(v3.cleanups, function() runService:UnbindFromRenderStep(v142) end)
end

local function f34()
  local character6 = localPlayer.Character

  if type(v9) == "table" and type(v9.GetVehicle) == "function" then
    local v143, v144 = pcall(v9.GetVehicle)

    if v143 and v144 and v144:IsA("Model") then
      local rootPart = v144:FindFirstChild("RootPart") or v144.PrimaryPart
        or v144:FindFirstChildWhichIsA("BasePart")

      if rootPart and rootPart:IsA("BasePart") then
        local seats = v144:FindFirstChild("Seats")
        return v144, rootPart, seats and seats:FindFirstChild("DriverSeat", true), true
      end
    end
  end

  if character6 then
    for index18, value21 in ipairs(collectionService:GetTagged("FactoryVehicleSeat")) do
      local occupant = value21:FindFirstChild("Occupant")

      if occupant and occupant:IsA("ObjectValue") and occupant.Value == character6 then
        local parent = value21.Parent and value21.Parent.Parent

        if parent and parent:IsA("Model") then
          local rootPart2 = parent:FindFirstChild("RootPart") or parent.PrimaryPart
            or parent:FindFirstChildWhichIsA("BasePart")

          if rootPart2 and rootPart2:IsA("BasePart") then
            return parent, rootPart2, value21, value21.Name == "DriverSeat"
          end
        end
      end
    end
  end

  local humanoid2 = character6
  humanoid2 = character6 and character6:FindFirstChildOfClass("Humanoid")

  local seatPart = humanoid2
  seatPart = humanoid2 and humanoid2.SeatPart

  if not seatPart then
    return nil, nil
  else
    local parent2 = seatPart

    while parent2 and parent2 ~= workspaceService do
      if parent2:IsA("Model") then
        local rootPart3 = parent2:FindFirstChild("RootPart") or parent2.PrimaryPart
          or parent2:FindFirstChildWhichIsA("BasePart")

        if rootPart3 and rootPart3:IsA("BasePart") then
          return parent2, rootPart3, seatPart, seatPart.Name == "DriverSeat"
        end
      end

      parent2 = parent2.Parent
    end

    return nil, seatPart, seatPart, seatPart.Name == "DriverSeat"
  end
end

local function f35(p61)
  local v145, v146, v147, v148

  for index19, value22 in ipairs(players:GetPlayers()) do
    if f8(value22) then
      local v149, v150 = f5(value22)

      local humanoidRootPart3 = v149
      humanoidRootPart3 = v149 and v149:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart3 then
        local magnitude9 = (humanoidRootPart3.Position - p61).Magnitude

        if magnitude9 <= v3.roadkillRadius and (not v145 or magnitude9 < v145) then
          v145 = magnitude9
          v147 = humanoidRootPart3
          v146 = v150
          v148 = value22
        end
      end
    end
  end

  return v148, v147, v146, v145
end

local f36

local function f37(p62)
  currentCamera = workspaceService.CurrentCamera or currentCamera

  if not currentCamera then
    return
  else
    local v151 = currentCamera.CFrame.LookVector * (f36(Enum.KeyCode.W) - f36(Enum.KeyCode.S))
      + currentCamera.CFrame.RightVector * (f36(Enum.KeyCode.D) - f36(Enum.KeyCode.A))
      + Vector3.new(0, f36(Enum.KeyCode.Space) - f36(Enum.KeyCode.LeftControl), 0)

    if v151.Magnitude > 0.001 then
      p62.AssemblyLinearVelocity = v151.Unit * v3.vehicleTargetSpeed
    else
      p62.AssemblyLinearVelocity = Vector3.zero
    end

    p62.AssemblyAngularVelocity = Vector3.zero
    return
  end
end

function f36(p63)
  return userInputService:IsKeyDown(p63) and 1 or 0
end

local function f38(p64)
  if v3.roadkillHumanoid and v3.roadkillPreviousHealth and v3.roadkillPreviousHealth > 0
    and v3.roadkillHumanoid.Health <= 0 then
    if os.clock() - v3.roadkillLastNearAt <= 2.5 then
      v3.roadkillKillsObserved = v3.roadkillKillsObserved + 1

      f3("roadkill candidate killed "
        .. (v3.roadkillTarget and v3.roadkillTarget.Name or "target")
        .. "; confirm Roadkill in the authoritative death feed")
    end

    v3.roadkillTarget = nil
    v3.roadkillHumanoid = nil
    v3.roadkillPreviousHealth = nil
  end

  local v152, v153, v154, v155 = f35(p64.Position)

  if not v152 then
    if v3.roadkillTarget and os.clock() - v3.roadkillLastNearAt > 3 then
      v3.roadkillTarget = nil
      v3.roadkillHumanoid = nil
      v3.roadkillPreviousHealth = nil
    end

    return false
  else
    if v3.roadkillTarget ~= v152 then
      v3.roadkillTarget = v152
      v3.roadkillHumanoid = v154
      v3.roadkillPreviousHealth = v154.Health

      f3(string.format(
        "auto roadkill acquired %s at %.1f studs; server collision decides damage", v152.Name,
        v155
      ))
    end

    v3.roadkillLastNearAt = os.clock()
    v3.roadkillPreviousHealth = v154.Health

    local v156 = v153.Position - p64.Position
    local vector3 = Vector3.new(v156.X, 0, v156.Z)

    if vector3.Magnitude > 0.001 then
      p64.AssemblyLinearVelocity = vector3.Unit * v3.vehicleTargetSpeed
        + Vector3.new(0, p64.AssemblyLinearVelocity.Y, 0)

      return true
    end

    return false
  end
end

local f39

local function f40(p65)
  if not p65 then
    f39()
    return
  end

  if v3.vehicleNoclipVehicle ~= p65 then
    f39()

    v3.vehicleNoclipVehicle = p65
    v3.nextVehicleNoclipScanAt = 0
    v3.nextVehicleNoclipApplyAt = 0
  end

  if os.clock() >= v3.nextVehicleNoclipScanAt then
    v3.nextVehicleNoclipScanAt = os.clock() + 1

    for index20, value23 in ipairs(p65:GetDescendants()) do
      if value23:IsA("BasePart") and v3.vehicleNoclipOriginal[value23] == nil then
        v3.vehicleNoclipOriginal[value23] = value23.CanCollide
      end
    end
  end

  if os.clock() >= v3.nextVehicleNoclipApplyAt then
    v3.nextVehicleNoclipApplyAt = os.clock() + 0.1

    for key5 in pairs(v3.vehicleNoclipOriginal) do
      if key5.Parent then
        key5.CanCollide = false
      end
    end
  end
end

function f39()
  for key6, value24 in pairs(v3.vehicleNoclipOriginal) do
    local v157 = key6
    local canCollide = value24

    if v157 and v157.Parent then
      pcall(function() v157.CanCollide = canCollide end)
    end
  end

  v3.vehicleNoclipOriginal = {}
  v3.vehicleNoclipVehicle = nil
end

local drawing = getgenv and getgenv().Drawing or rawget(_G, "Drawing") or typeof and nil

if not drawing and type(Drawing) == "table" then
  drawing = Drawing
end

local v158 = type(drawing) == "table" and type(drawing.new) == "function"

local function f41(p66, p67)
  local v159

  if not v158 then
    return nil
  else
    local v160
    v160, v159 = pcall(drawing.new, p66)

    if not v160 or not v159 then
      v158 = false
      return nil
    end

    for key7, value25 in pairs(p67 or {}) do
      local v161 = key7
      local v162 = value25
      pcall(function() v159[v161] = v162 end)
    end

    table.insert(v3.drawings, v159)
    return v159
  end
end

local v163 = {
  on = Color3.fromRGB(65, 224, 139),
  off = Color3.fromRGB(236, 89, 98),
  accent = Color3.fromRGB(168, 85, 247),
  enemy = Color3.fromRGB(255, 84, 92),
  lock = Color3.fromRGB(145, 255, 20),
  text = Color3.fromRGB(238, 243, 252),
  muted = Color3.fromRGB(157, 171, 194),
}

local v164 = f41("Circle", {
  Radius = v3.fovRadius,
  NumSides = 64,
  Filled = false,
  Thickness = 1.5,
  Color = v163.accent,
  Transparency = 0.9,
  ZIndex = 8,
  Visible = false,
})

local v165 = f41("Circle", {
  Radius = v3.triggerRadius,
  NumSides = 48,
  Filled = false,
  Thickness = 1,
  Color = v163.on,
  Transparency = 0.8,
  ZIndex = 8,
  Visible = false,
})

local v166 = f41("Text", {
  Center = true,
  Size = 14,
  Font = 2,
  Color = v163.accent,
  Outline = true,
  ZIndex = 15,
  Visible = false,
})

local v167 = {}
local v168 = {}
local count7 = 0

while true do
  count7 = 1 + count7

  if not (3 >= count7) then
    break
  end

  local v169 = count7

  v168[v169] = f41("Line", {
    Thickness = 7,
    Color = v163.accent,
    Transparency = 0.35,
    Visible = false,
    ZIndex = 12,
  })

  v167[v169] = f41("Line", {
    Thickness = 2.5,
    Color = v163.accent,
    Visible = false,
    ZIndex = 13,
  })
end

local function f42(p68, visible2)
  if p68 then
    pcall(function() p68.Visible = visible2 end)
  end
end

local v170 = {
  { "head", "chest" }, { "chest", "pelvis" }, { "chest", "leftUpperArm" },
  { "leftUpperArm", "leftLowerArm" }, { "leftLowerArm", "leftHand" },
  { "chest", "rightUpperArm" }, { "rightUpperArm", "rightLowerArm" },
  { "rightLowerArm", "rightHand" }, { "pelvis", "leftUpperLeg" },
  { "leftUpperLeg", "leftLowerLeg" }, { "leftLowerLeg", "leftFoot" },
  { "pelvis", "rightUpperLeg" }, { "rightUpperLeg", "rightLowerLeg" },
  { "rightLowerLeg", "rightFoot" },
}

local function f43(p69, p70)
  for index21, value26 in ipairs(p70) do
    local findFirstChild2 = p69:FindFirstChild(value26)

    local findFirstChild3 = findFirstChild2
    findFirstChild3 = findFirstChild2 or p69:FindFirstChild(value26, true)

    if findFirstChild3 and findFirstChild3:IsA("BasePart") then
      return findFirstChild3.Position
    end
  end

  return nil
end

local function f44(p71)
  if not p71 then
    return nil
  end

  for index22, value27 in ipairs(p71:GetChildren()) do
    if value27:IsA("Tool") then
      return value27.Name
    end
  end

  return nil
end

local function f45(p72)
end

local f46

local function f47(p73, p74, p75, p76, p77, p78)
  local v171 = {}

  for key8, value28 in pairs((f46(p74))) do
    if value28 then
      local v172, v173 = currentCamera:WorldToViewportPoint(value28)

      if v172.Z > 0 then
        v171[key8] = Vector2.new(v172.X, v172.Y)
      end
    end
  end

  for index23, value29 in ipairs(v170) do
    if p77 and not p73["bone" .. index23] then
      local v174 = "bone" .. index23

      p73[v174] = f41("Line", {
        Thickness = 1.5,
        Color = v3.skeletonColor or v163.text,
        Transparency = 1,
        ZIndex = 11,
        Visible = false,
      })
    end

    if p78 and not p73["cham" .. index23] then
      p73["cham" .. index23] = f41("Line", {
        Thickness = 8,
        Color = v163.enemy,
        Transparency = 0.48,
        ZIndex = 9,
        Visible = false,
      })
    end

    local v175 = v171[value29[2]]
    local v176 = v171[value29[1]]
    local v177 = p73["cham" .. index23]
    local v178 = p73["bone" .. index23]

    local v179 = v176
    v179 = v176 and v175 and (v176 - v175).Magnitude > 0.08

    if v179 then
      if v178 then
        v178.From = v176
        v178.To = v175
        v178.Color = v3.skeletonColor or p75
        v178.Visible = p77
      end

      if v177 then
        v177.From = v176
        v177.To = v175
        v177.Color = v3.chamsColor or p75
        v177.Thickness = math.clamp(p76 / 17, 5, 16)
        v177.Visible = p78
      end
    end

    if not v179 then
      f42(v178, false)
      f42(v177, false)
    end
  end
end

function f46(p79)
  local head = f43(p79, { "Head" })
  local v180 = f43(p79, { "UpperTorso", "Torso" })
  local v181 = f43(p79, { "LowerTorso", "Torso" })
  local v182 = f43(p79, { "HumanoidRootPart", "Torso" })

  if not v180 and v182 then
    v180 = v182
  end

  if not v181 and v180 then
    v181 = v180
  end

  local function f48(p80, p81, p82, p83)
    local v183 = f43(p79, { p80 })
    local v184 = f43(p79, { p81 })
    local v185 = f43(p79, { p82 })
    local v186 = f43(p79, { p83 })

    if v183 and v184 and v185 then
      return v183, v184, v185
    end

    if v186 and v180 then
      return v180, v186, v186
    end

    return v183, v184 or v183, v185 or v184 or v183
  end

  local leftUpperArm, leftLowerArm, leftHand = f48(
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm"
  )

  local rightUpperArm, rightLowerArm, rightHand = f48(
    "RightUpperArm", "RightLowerArm", "RightHand", "Right Arm"
  )

  local leftUpperLeg, leftLowerLeg, leftFoot = f48(
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"
  )

  local rightUpperLeg, rightLowerLeg, rightFoot = f48(
    "RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"
  )

  return {
    head = head,
    chest = v180,
    pelvis = v181,
    leftUpperArm = leftUpperArm,
    leftLowerArm = leftLowerArm,
    leftHand = leftHand,
    rightUpperArm = rightUpperArm,
    rightLowerArm = rightLowerArm,
    rightHand = rightHand,
    leftUpperLeg = leftUpperLeg,
    leftLowerLeg = leftLowerLeg,
    leftFoot = leftFoot,
    rightUpperLeg = rightUpperLeg,
    rightLowerLeg = rightLowerLeg,
    rightFoot = rightFoot,
  }
end

local function f49(p84)
  local v187 = v3.playerDrawings[p84]

  if v187 then
    return v187
  else
    local v188 = {
      box = f41("Square", {
        Filled = false,
        Thickness = 1.5,
        Color = v163.enemy,
        ZIndex = 10,
      }),
      outline = f41("Square", {
        Filled = false,
        Thickness = 3.5,
        Color = Color3.new(0, 0, 0),
        ZIndex = 9,
      }),
      name = f41("Text", {
        Center = true,
        Size = 13,
        Font = 2,
        Color = v163.text,
        Outline = true,
        ZIndex = 11,
      }),
      weapon = f41("Text", {
        Center = true,
        Size = 12,
        Font = 2,
        Color = v163.muted,
        Outline = true,
        ZIndex = 11,
      }),
      tracer = f41("Line", { Thickness = 1.5, Color = v163.enemy, ZIndex = 10 }),
      hpBack = f41("Square", {
        Filled = true,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 0.35,
        ZIndex = 10,
      }),
      hpFill = f41("Square", {
        Filled = true,
        Color = v163.on,
        Transparency = 0.15,
        ZIndex = 11,
      }),
    }

    v3.playerDrawings[p84] = v188
    return v188
  end
end

local function f50(p85)
  if not p85 then
    return
  end

  for key9, value30 in pairs(p85) do
  end

  if f45 then
    f45(p85)
  end
end

local function f51()
  currentCamera = workspaceService.CurrentCamera or currentCamera

  if not currentCamera then
    return
  else
    local viewportSize2 = currentCamera.ViewportSize

    if v164 then
      v164.Position = Vector2.new(viewportSize2.X * 0.5, viewportSize2.Y * 0.5)
      v164.Radius = v3.fovRadius
      v164.Color = v3.fovColor or v163.accent
      v164.Visible = v3.active and v3.showFov and v3.silentAim
    end

    if v165 then
      v165.Position = Vector2.new(viewportSize2.X * 0.5, viewportSize2.Y * 0.5)
      v165.Radius = v3.triggerRadius
      v165.Color = v3.triggerFovColor or v163.on

      local active = v3.active

      local triggerbot = active
      triggerbot = active and v3.showFov and v3.triggerbot

      if v3.profile == "legit" and v3.silentAim then
        triggerbot = false
      end

      v165.Visible = triggerbot
    end

    local v189 = f14(v3.fovRadius, v3.aimDistance, false)

    v3.currentTarget = v189 and v189.player or nil
    v3.currentPart = v189 and v189.part or nil

    if v3.profile == "legit" and v189 and v189.visible then
      if v3.legitLockTarget ~= v189.player then
        v3.legitLockTarget = v189.player
        v3.legitLockSince = os.clock()
      end
    else
      v3.legitLockTarget = nil
      v3.legitLockSince = 0
    end

    if v189 and v166 then
      if os.clock() >= v3.nextAssessmentAt or v3.assessedTarget ~= v189.player then
        v3.nextAssessmentAt = os.clock() + 0.1
        v3.assessedTarget = v189.player

        local v190 = f9()
        local v191 = f11(v190)
        v3.shotAssessment = f25(v189, f22(v190), v191)
      end

      local shotAssessment = v3.shotAssessment
      v166.Position = Vector2.new(v189.screen.X, v189.screen.Y - 35)
      local text = shotAssessment and shotAssessment.text or "ASSESSING"

      local on = shotAssessment
          and (shotAssessment.color == "good" and v163.on
            or shotAssessment.color == "bad" and v163.off or v163.accent)
        or v163.accent

      v3.visualShotReady = shotAssessment and shotAssessment.canFire or false

      if v3.profile == "legit" and shotAssessment then
        local v192, v193 = f20(v189, shotAssessment, f22(f9()), currentCamera.CFrame.LookVector)
        v3.visualShotReady = v192

        if not v192 then
          text = "LEGIT HOLD: " .. tostring(v193)
          on = v163.accent
        end
      end

      v166.Text = text
      v166.Color = on
      v166.Visible = v3.active
    elseif v166 then
      v166.Visible = false

      v3.shotAssessment = nil
      v3.assessedTarget = nil
      v3.visualShotReady = false
    end

    for index24, value31 in ipairs(v167) do
    end

    for index25, value32 in ipairs(v168) do
    end

    local esp = v3.esp or v3.tracers

    for index26, value33 in ipairs(players:GetPlayers()) do
      local v194 = v3.playerDrawings[value33]

      if not esp or not f8(value33) then
        if v194 then
          f50(v194)
        end
      else
        v194 = v194 or f49(value33)
        local v195 = f5(value33)

        local humanoidRootPart4 = v195
          and (v195:FindFirstChild("HumanoidRootPart") or v195.PrimaryPart
            or v195:FindFirstChildWhichIsA("BasePart"))

        local head2 = v195
        head2 = v195 and (v195:FindFirstChild("Head") or humanoidRootPart4)

        if not humanoidRootPart4 or not head2 then
          f50(v194)
        else
          local magnitude10 = (humanoidRootPart4.Position - f6()).Magnitude
          local v196, v197 = currentCamera:WorldToViewportPoint(humanoidRootPart4.Position)

          local worldToViewportPoint = currentCamera:WorldToViewportPoint(head2.Position
            + Vector3.new(0, 0.5, 0))

          local worldToViewportPoint2 = currentCamera:WorldToViewportPoint(humanoidRootPart4.Position
            - Vector3.new(0, 3, 0))

          if v196.Z <= 0 then
            f50(v194)
          else
            local v198 = math.max(
              math.abs(worldToViewportPoint2.Y - worldToViewportPoint.Y), 12
            )

            local v199 = v198 * 0.55
            local v200 = v3.currentTarget == value33

            local lock = v200 and v3.assessedTarget == value33 and v3.visualShotReady
                and v3.shotAssessment and v3.shotAssessment.highConfidence and v163.lock
              or v200 and v163.accent
              or v163.enemy

            local v201 = magnitude10 <= v3.espDistance
            local v202 = v197 == true
            local esp2 = v3.esp

            local v203 = esp2
            v203 = esp2 and v201 and v202

            local v204 = v3.espBox == true
            local v205 = v3.espCorner == true
            local v206 = v3.espChams == true
            local v207 = v3.espSkeleton == true
            local v208 = v196.X - v199 * 0.5
            local y = worldToViewportPoint.Y

            v194.outline.Position = Vector2.new(v208, y)
            v194.outline.Size = Vector2.new(v199, v198)

            local outline = v194.outline
            outline.Visible = v203 and v204

            v194.box.Position = v194.outline.Position
            v194.box.Size = v194.outline.Size
            v194.box.Color = lock

            local outline2 = v194.outline
            outline2.Color = v3.boxOutlineColor or Color3.new(0, 0, 0)

            local box = v194.box
            box.Visible = v203 and v204

            if not v194.corners then
              v194.corners = {}

              for k = 1, 8 do
                v194.corners[k] = f41("Line", {
                  Thickness = 2,
                  Color = v163.enemy,
                  ZIndex = 10,
                  Visible = false,
                })
              end
            end

            local v209 = math.clamp(v199 * 0.25, 4, 14)

            local function f52(p86, from, to, visible3)
              local v210 = v194.corners[p86]

              if v210 then
                v210.From = from
                v210.To = to
                v210.Color = lock
                v210.Visible = visible3
              end
            end

            local v211 = v203 and v205

            f52(1, Vector2.new(v208, y), Vector2.new(v208 + v209, y), v211)
            f52(2, Vector2.new(v208, y), Vector2.new(v208, y + v209), v211)
            f52(3, Vector2.new(v208 + v199, y), Vector2.new(v208 + v199 - v209, y), v211)
            f52(4, Vector2.new(v208 + v199, y), Vector2.new(v208 + v199, y + v209), v211)
            f52(5, Vector2.new(v208, y + v198), Vector2.new(v208 + v209, y + v198), v211)
            f52(6, Vector2.new(v208, y + v198), Vector2.new(v208, y + v198 - v209), v211)

            f52(
              7, Vector2.new(v208 + v199, y + v198), Vector2.new(v208 + v199 - v209, y + v198),
              v211
            )

            f52(
              8, Vector2.new(v208 + v199, y + v198), Vector2.new(v208 + v199, y + v198 - v209),
              v211
            )

            if v206 and v203 and not v194.chamFill then
              v194.chamFill = f41("Square", {
                Filled = true,
                Color = v163.enemy,
                Transparency = 0.2,
                ZIndex = 8,
                Visible = false,
              })
            end

            if v194.chamFill then
              v194.chamFill.Position = v194.outline.Position
              v194.chamFill.Size = v194.outline.Size

              local chamFill = v194.chamFill
              chamFill.Color = v3.chamsColor or lock

              local chamFill2 = v194.chamFill
              chamFill2.Visible = v203 and v206
            end

            if v203 and (v207 or v206) then
              f47(v194, v195, lock, v198, v207, v206)
            else
              f45(v194)
            end

            local v212 = true

            if v3.visibility then
              v212 = f13(head2, f6())
            end

            lock = v200 and v212 and (v3.espColorSelected or v163.accent) or v3.espColor
              or v163.enemy

            v194.box.Color = lock
            v194.outline.Color = lock

            local v213 = {}

            if v3.showNames then
              v213[#v213 + 1] = value33.Name
            end

            if v3.showDistance then
              v213[#v213 + 1] = string.format("[%dm]", math.floor(magnitude10 + 0.5))
            end

            v194.name.Position = Vector2.new(v196.X, worldToViewportPoint.Y - 18)
            v194.name.Text = table.concat(v213, "  ")

            local name2 = v194.name
            name2.Color = v3.nameColor or v163.text

            local name3 = v194.name
            name3.Visible = v203 and #v213 > 0

            local showWeapon = v3.showWeapon and f44(v195) or nil

            if v194.weapon then
              v194.weapon.Position = Vector2.new(v196.X, worldToViewportPoint.Y
                - (v194.name.Visible and 32 or 18))

              local weapon = v194.weapon
              weapon.Text = showWeapon or ""

              local weapon2 = v194.weapon
              weapon2.Color = v3.weaponColor or v3.nameColor or v163.muted

              local weapon3 = v194.weapon
              weapon3.Visible = v203 and showWeapon ~= nil
            end

            local humanoid3 = v195:FindFirstChildOfClass("Humanoid")
            local v214 = 1

            if humanoid3 and humanoid3.MaxHealth > 0 then
              v214 = math.clamp(humanoid3.Health / humanoid3.MaxHealth, 0, 1)
            end

            if v194.hpBack and v194.hpFill then
              local v215 = v208 - 6

              v194.hpBack.Position = Vector2.new(v215, y)
              v194.hpBack.Size = Vector2.new(3, v198)

              local hpBack = v194.hpBack
              hpBack.Visible = v203 and v3.showHealthBar

              local v216 = math.max(v198 * v214, 0)

              v194.hpFill.Position = Vector2.new(v215, y + (v198 - v216))
              v194.hpFill.Size = Vector2.new(3, v216)

              local hpFill = v194.hpFill
              hpFill.Color = (v3.healthLow or v163.off):Lerp(v3.healthHigh or v163.on, v214)

              local hpFill2 = v194.hpFill
              hpFill2.Visible = v203 and v3.showHealthBar
            end

            local vector4 = Vector2.new(
              math.clamp(v196.X, 0, viewportSize2.X), math.clamp(v196.Y, 0, viewportSize2.Y)
            )

            v194.tracer.From = Vector2.new(viewportSize2.X * 0.5, viewportSize2.Y - 4)
            v194.tracer.To = vector4

            local tracer = v194.tracer
            tracer.Color = v3.tracerColor or lock

            local tracer2 = v194.tracer
            tracer2.Visible = v3.tracers and magnitude10 <= v3.tracerDistance
          end
        end
      end
    end

    return
  end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local themeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local saveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
local options = library.Options

library.ForceCheckbox = false
library.ShowToggleFrameInKeybinds = true

local obelusBallisticsWindow = library:CreateWindow({
  Title = "obelus · ballistics",
  Footer = "ballistics probe",
  NotifySide = "Right",
  ShowCustomCursor = true,
})

local v217 = {
  Legit = obelusBallisticsWindow:AddTab("Legit", "user"),
  Rage = obelusBallisticsWindow:AddTab("Rage", "crosshair"),
  Misc = obelusBallisticsWindow:AddTab("Misc", "car"),
  Visuals = obelusBallisticsWindow:AddTab("Visuals", "eye"),
  Settings = obelusBallisticsWindow:AddTab("Settings", "settings"),
}

local targetSelection = v217.Legit:AddLeftGroupbox("Target Selection")

targetSelection:AddToggle("LegitEnabled", {
  Text = "Enabled",
  Default = v3.silentAim,
  Callback = function(value34) v3.silentAim = value34 end,
})

targetSelection:AddToggle("LegitVisibility", {
  Text = "Visibility Check",
  Default = v3.visibility,
  Callback = function(value35) v3.visibility = value35 end,
})

targetSelection:AddToggle("LegitSmartTargeting", {
  Text = "Smart Targeting",
  Default = v3.smartTargeting,
  Callback = function(value36) v3.smartTargeting = value36 end,
})

targetSelection:AddDropdown("LegitOrigin", {
  Values = { "Camera", "Mouse" },
  Default = "Camera",
  Text = "Origin",
})

targetSelection:AddSlider("LegitFovRadius", {
  Text = "FOV",
  Default = v3.fovRadius,
  Min = 90,
  Max = 360,
  Rounding = 0,
  Suffix = "°",
  Callback = function(value37) v3.fovRadius = value37 end,
})

targetSelection:AddSlider("LegitTriggerRadius", {
  Text = "Trigger FOV",
  Default = v3.triggerRadius,
  Min = 10,
  Max = 360,
  Rounding = 0,
  Suffix = "px",
  Callback = function(value38) v3.triggerRadius = value38 end,
})

targetSelection:AddSlider("LegitAimDistance", {
  Text = "Aim Distance",
  Default = v3.aimDistance,
  Min = 100,
  Max = 2000,
  Rounding = 0,
  Callback = function(value39) v3.aimDistance = value39 end,
})

local silentAim2 = v217.Legit:AddRightGroupbox("Silent Aim")

silentAim2:AddToggle("LegitSilentAim", {
  Text = "Enabled",
  Default = v3.silentAim,
  Callback = function(value40) v3.silentAim = value40 end,
})

silentAim2:AddToggle("LegitNoRecoil", {
  Text = "No Recoil",
  Default = v3.noRecoil,
  Callback = function(value41) v3.noRecoil = value41 end,
})

silentAim2:AddToggle("LegitTriggerbot", {
  Text = "Auto Shoot",
  Default = v3.triggerbot,
  Callback = function(value42) v3.triggerbot = value42 end,
})

silentAim2:AddToggle("LegitPrediction", {
  Text = "Prediction",
  Default = v3.prediction,
  Callback = function(value43) v3.prediction = value43 end,
})

silentAim2:AddDropdown("LegitTargetPart", {
  Values = { "Torso", "Head" },
  Default = v3.targetPart,
  Text = "Aim Bone",
  Callback = function(value44) v3.targetPart = value44 end,
})

silentAim2:AddDropdown("LegitProfile", {
  Values = { "rage", "legit" },
  Default = v3.profile,
  Text = "Profile",
  Callback = function(value45) v3.profile = value45 end,
})

local aimAssist = v217.Legit:AddRightGroupbox("Aim Assist")

aimAssist:AddToggle("LegitAutoDefense", {
  Text = "Auto Defense",
  Default = v3.autoDefense,
  Callback = function(value46)
    v3.autoDefense = value46

    if not value46 then
      f32("toggle off")
    end
  end,
})

aimAssist:AddToggle("LegitAngleAudit", {
  Text = "Angle Audit",
  Default = v3.angleAudit,
  Callback = function(value47) v3.angleAudit = value47 end,
})

aimAssist:AddToggle("LegitPenetrationAudit", {
  Text = "Penetration Audit",
  Default = v3.penetrationAudit,
  Callback = function(value48) v3.penetrationAudit = value48 end,
})

local rage = v217.Rage:AddLeftGroupbox("Rage")

rage:AddToggle("RageSilentAim", {
  Text = "Silent Aim",
  Default = v3.silentAim,
  Callback = function(value49) v3.silentAim = value49 end,
})

rage:AddToggle("RageTriggerbot", {
  Text = "Triggerbot",
  Default = v3.triggerbot,
  Callback = function(value50) v3.triggerbot = value50 end,
})

rage:AddToggle("RageIgnoreVisibility", {
  Text = "Ignore Visibility",
  Default = not v3.visibility,
  Callback = function(value51) v3.visibility = not value51 end,
})

rage:AddSlider("RageFov", {
  Text = "FOV",
  Default = v3.fovRadius,
  Min = 90,
  Max = 360,
  Rounding = 0,
  Suffix = "°",
  Callback = function(value52) v3.fovRadius = value52 end,
})

local vehicle = v217.Misc:AddLeftGroupbox("Vehicle")

vehicle:AddToggle("VehicleSpeed", {
  Text = "Vehicle Speed",
  Default = v3.vehicleSpeedEnabled,
  Callback = function(value53)
    v3.vehicleSpeedEnabled = value53
    v3.vehicleRoot = nil
  end,
})

vehicle:AddToggle("VehicleFly", {
  Text = "Vehicle Fly",
  Default = v3.vehicleFly,
  Callback = function(value54) v3.vehicleFly = value54 end,
})

vehicle:AddToggle("VehicleSpin", {
  Text = "Vehicle Spin",
  Default = v3.vehicleSpin,
  Callback = function(value55) v3.vehicleSpin = value55 end,
})

vehicle:AddToggle("VehicleNoclip", {
  Text = "Building Noclip",
  Default = v3.vehicleNoclip,
  Callback = function(value56)
    v3.vehicleNoclip = value56

    if not value56 then
      f39()
    end
  end,
})

vehicle:AddToggle("AutoRoadkill", {
  Text = "Auto Roadkill",
  Default = v3.autoRoadkill,
  Callback = function(value57) v3.autoRoadkill = value57 end,
})

vehicle:AddSlider("VehicleTargetSpeed", {
  Text = "Speed Cap",
  Default = v3.vehicleTargetSpeed,
  Min = 20,
  Max = 110,
  Rounding = 0,
  Suffix = " studs/s",
  Callback = function(value58) v3.vehicleTargetSpeed = value58 end,
})

v217.Misc:AddRightGroupbox("Other"):AddButton({
  Text = "Hide / Restore Buildings",
  Func = function() f21() end,
  Tooltip = "Toggle local building visibility",
})

local esp3 = v217.Visuals:AddLeftGroupbox("ESP")

esp3:AddToggle("EspEnabled", {
  Text = "ESP",
  Default = v3.esp,
  Callback = function(value59) v3.esp = value59 end,
})

esp3:AddToggle("EspTracers", {
  Text = "Tracers",
  Default = v3.tracers,
  Callback = function(value60) v3.tracers = value60 end,
})

esp3:AddToggle("EspShowFov", {
  Text = "Show FOV",
  Default = v3.showFov,
  Callback = function(value61) v3.showFov = value61 end,
})

esp3:AddToggle("EspBox", {
  Text = "Style: Box",
  Default = v3.espBox,
  Callback = function(value62) v3.espBox = value62 end,
})

esp3:AddToggle("EspCorner", {
  Text = "Style: Corner",
  Default = v3.espCorner,
  Callback = function(value63) v3.espCorner = value63 end,
})

esp3:AddToggle("EspSkeleton", {
  Text = "Style: Skeleton",
  Default = v3.espSkeleton,
  Callback = function(value64) v3.espSkeleton = value64 end,
})

esp3:AddToggle("EspChams", {
  Text = "Style: Chams",
  Default = v3.espChams,
  Callback = function(value65) v3.espChams = value65 end,
})

esp3:AddToggle("EspShowNames", {
  Text = "Names",
  Default = v3.showNames,
  Callback = function(value66) v3.showNames = value66 end,
})

esp3:AddToggle("EspShowDistance", {
  Text = "Distance",
  Default = v3.showDistance,
  Callback = function(value67) v3.showDistance = value67 end,
})

esp3:AddToggle("EspShowHealthBar", {
  Text = "Health Bar",
  Default = v3.showHealthBar,
  Callback = function(value68) v3.showHealthBar = value68 end,
})

esp3:AddToggle("EspShowWeapon", {
  Text = "Weapon ESP",
  Default = v3.showWeapon,
  Callback = function(value69) v3.showWeapon = value69 end,
})

esp3:AddLabel("Enemy Color"):AddColorPicker("EspColor", {
  Default = v3.espColor,
  Title = "Enemy Color",
  Callback = function(value70) v3.espColor = value70 end,
})

esp3:AddLabel("Selected Color"):AddColorPicker("EspColorSelected", {
  Default = v3.espColorSelected,
  Title = "Selected Color",
  Callback = function(value71) v3.espColorSelected = value71 end,
})

esp3:AddLabel("Name Color"):AddColorPicker("NameColor", {
  Default = v3.nameColor,
  Title = "Name Color",
  Callback = function(value72) v3.nameColor = value72 end,
})

esp3:AddLabel("Weapon Color"):AddColorPicker("WeaponColor", {
  Default = v3.weaponColor,
  Title = "Weapon Color",
  Callback = function(value73) v3.weaponColor = value73 end,
})

esp3:AddLabel("Skeleton Color"):AddColorPicker("SkeletonColor", {
  Default = v3.skeletonColor,
  Title = "Skeleton Color",
  Callback = function(value74) v3.skeletonColor = value74 end,
})

esp3:AddLabel("Chams Color"):AddColorPicker("ChamsColor", {
  Default = v3.chamsColor,
  Title = "Chams Color",
  Callback = function(value75) v3.chamsColor = value75 end,
})

esp3:AddLabel("Tracer Color"):AddColorPicker("TracerColor", {
  Default = v3.tracerColor,
  Title = "Tracer Color",
  Callback = function(value76) v3.tracerColor = value76 end,
})

esp3:AddLabel("Box Outline"):AddColorPicker("BoxOutlineColor", {
  Default = v3.boxOutlineColor,
  Title = "Box Outline",
  Callback = function(value77) v3.boxOutlineColor = value77 end,
})

esp3:AddLabel("FOV Color"):AddColorPicker("FovColor", {
  Default = v3.fovColor,
  Title = "FOV Color",
  Callback = function(value78) v3.fovColor = value78 end,
})

esp3:AddLabel("Trigger FOV Color"):AddColorPicker("TriggerFovColor", {
  Default = v3.triggerFovColor,
  Title = "Trigger FOV Color",
  Callback = function(value79) v3.triggerFovColor = value79 end,
})

esp3:AddLabel("HP High"):AddColorPicker("HealthHigh", {
  Default = v3.healthHigh,
  Title = "HP High",
  Callback = function(value80) v3.healthHigh = value80 end,
})

esp3:AddLabel("HP Low"):AddColorPicker("HealthLow", {
  Default = v3.healthLow,
  Title = "HP Low",
  Callback = function(value81) v3.healthLow = value81 end,
})

esp3:AddSlider("EspDistance", {
  Text = "ESP Distance",
  Default = v3.espDistance,
  Min = 100,
  Max = 2000,
  Rounding = 0,
  Callback = function(value82) v3.espDistance = value82 end,
})

esp3:AddSlider("EspTracerDistance", {
  Text = "Tracer Distance",
  Default = v3.tracerDistance,
  Min = 100,
  Max = 1500,
  Rounding = 0,
  Callback = function(value83) v3.tracerDistance = value83 end,
})

local configs = v217.Settings:AddLeftGroupbox("Configs")
configs:AddLabel("Config export uses the CW1 payload format")

configs:AddInput("ImportBox", {
  Default = "",
  Text = "Import text (CW1 config)",
  Placeholder = "Paste CW1 config here",
  Finished = false,
  ClearTextOnFocus = false,
  Callback = function(value84) v3.importBuffer = value84 end,
})

configs:AddButton({ Text = "Export Config", Func = function() exportConfig() end })

configs:AddButton({
  Text = "Import Config (clipboard/box)",
  Func = function()
    local importBuffer = readClipboard()

    if not importBuffer or #importBuffer < 4 then
      importBuffer = v3.importBuffer
    end

    if importBuffer and #importBuffer > 3 then
      if importConfig(importBuffer) then
        v3.importBuffer = ""

        if options.ImportBox then
          options.ImportBox:SetValue("")
        end
      end
    else
      v3.lastResult = "clipboard empty — paste into box"
    end
  end,
})

configs:AddButton({
  Text = "Unload Script",
  Func = function()
    if v3.Unload then
      v3:Unload("operator")
    end

    library:Unload()
  end,
})

v217.Settings:AddRightGroupbox("Menu"):AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind", {
  Default = "Delete",
  NoUI = true,
  Text = "Menu keybind",
  Mode = "Toggle",
})

library.ToggleKeybind = options.MenuKeybind
local renderStepped = runService.RenderStepped

table.insert(v3.connections, renderStepped:Connect(function(p87)
  if not v3.active then
    return
  else
    v3.frameMs = v3.frameMs * 0.9 + math.min(p87 * 1000, 100) * 0.1

    if v3.noRecoil and v3._nrLook and os.clock() < (v3._nrUntil or 0) then
      currentCamera = workspaceService.CurrentCamera or currentCamera

      if currentCamera then
        local position4 = currentCamera.CFrame.Position
        local lerp = currentCamera.CFrame.LookVector:Lerp(v3._nrLook, 0.65)

        if lerp.Magnitude > 0.001 then
          currentCamera.CFrame = CFrame.new(position4, position4 + lerp.Unit)
        end
      end
    end

    if v164 then
      pcall(function()
        currentCamera = workspaceService.CurrentCamera or currentCamera

        if currentCamera then
          local viewportSize3 = currentCamera.ViewportSize

          v164.Position = Vector2.new(viewportSize3.X * 0.5, viewportSize3.Y * 0.5)
          v164.Radius = v3.fovRadius
          v164.Color = v3.fovColor or v163.accent
          v164.Visible = v3.showFov and v3.silentAim
        end
      end)
    end

    if v165 then
      pcall(function()
        currentCamera = workspaceService.CurrentCamera or currentCamera

        if currentCamera then
          local viewportSize4 = currentCamera.ViewportSize

          v165.Position = Vector2.new(viewportSize4.X * 0.5, viewportSize4.Y * 0.5)
          v165.Radius = v3.triggerRadius
          v165.Color = v3.triggerFovColor or v163.on

          local triggerbot2 = v3.showFov and v3.triggerbot

          if v3.profile == "legit" and v3.silentAim then
            triggerbot2 = false
          end

          v165.Visible = triggerbot2
        end
      end)
    end

    if v3.localBuildingsHidden and os.clock() >= v3.nextBuildingRefreshAt then
      v3.nextBuildingRefreshAt = os.clock() + 1.5
      f18()
    end

    local v218 = false

    if v3.autoDefense and os.clock() >= v3.nextDefenseScanAt then
      v3.nextDefenseScanAt = os.clock() + 0.18
      local v219 = os.clock()
      f33()
      v3.perfDefenseMs = v3.perfDefenseMs * 0.7 + (os.clock() - v219) * 300
      v218 = true
    end

    if v3.autoDefense and v3.defenseTarget and not v218 then
      f28()
    end

    local triggerbot3 = v3.triggerbot

    local v220 = triggerbot3
    v220 = triggerbot3 and os.clock() >= v3.nextTriggerAt

    if v3.esp or v3.tracers or v3.silentAim or v3.triggerbot then
      local v221 = os.clock()

      if f51 then
        f51()
      end

      v3.perfVisualMs = v3.perfVisualMs * 0.7 + (os.clock() - v221) * 300
    elseif v164 then
      pcall(function() v164.Visible = false end)

      if v165 then
        pcall(function() v165.Visible = false end)
      end
    end

    if v220 then
      local v222 = os.clock()

      local v223 = f14(
        v3.triggerRadius, v3.aimDistance,
        v3.profile == "legit" or v3.visibility and not v3.penetrationAudit
      )

      if v223 then
        v3.currentTarget = v223.player
        v3.currentPart = v223.part

        local v224 = f9()
        local v225 = f11(v224)
        local v226 = f25(v223, f22(v224), v225)

        v3.shotAssessment = v226

        v3.nextTriggerAt = os.clock() + math.max(
          v3.triggerDelay, v225 and math.min(0.15, v225.fireInterval * 0.5) or v3.triggerDelay
        )

        local v227 = f20(v223, v226, f22(v224), currentCamera.CFrame.LookVector)

        if v226.canFire and v227 then
          f30()
        end
      else
        v3.nextTriggerAt = os.clock() + v3.triggerDelay
      end

      v3.perfTriggerMs = v3.perfTriggerMs * 0.7 + (os.clock() - v222) * 300
    end

    local cachedVehicleRoot = nil
    local cachedVehicle = nil

    if v3.vehicleSpeedEnabled or v3.vehicleFly or v3.vehicleSpin or v3.vehicleNoclip
      or v3.autoRoadkill then
      if os.clock() >= v3.nextVehicleLookupAt then
        v3.nextVehicleLookupAt = os.clock() + 0.05
        local cachedVehicle2, cachedVehicleRoot2, cachedVehicleSeat, cachedVehicleIsDriver = f34()

        v3.cachedVehicle = cachedVehicle2
        v3.cachedVehicleRoot = cachedVehicleRoot2
        v3.cachedVehicleSeat = cachedVehicleSeat
        v3.cachedVehicleIsDriver = cachedVehicleIsDriver
      end

      cachedVehicle = v3.cachedVehicle
      cachedVehicleRoot = v3.cachedVehicleRoot
    end

    if v3.vehicleNoclip then
      f40(cachedVehicle)
    elseif v3.vehicleNoclipVehicle then
      f39()
    end

    if v3.vehicleSpeedEnabled or v3.vehicleFly or v3.vehicleSpin or v3.autoRoadkill then
      if cachedVehicle and cachedVehicleRoot then
        v3.vehicleRoot = cachedVehicleRoot

        if v3.autoRoadkill then
          f38(cachedVehicleRoot)
        elseif v3.vehicleFly then
          f37(cachedVehicleRoot)
        elseif v3.vehicleSpeedEnabled then
          local assemblyLinearVelocity3 = cachedVehicleRoot.AssemblyLinearVelocity
          local vector5 = Vector3.new(assemblyLinearVelocity3.X, 0, assemblyLinearVelocity3.Z)

          if vector5.Magnitude >= 3 then
            cachedVehicleRoot.AssemblyLinearVelocity = vector5.Unit * v3.vehicleTargetSpeed + Vector3.new(
              0, assemblyLinearVelocity3.Y, 0
            )
          end
        end

        if v3.vehicleSpin then
          cachedVehicleRoot.AssemblyAngularVelocity = Vector3.new(0, math.rad(3600), 0)
        end
      end
    end

    return
  end
end))

local playerRemoving = players.PlayerRemoving

table.insert(v3.connections, playerRemoving:Connect(function(p88)
  if v3.defenseTarget == p88 then
    f32("target left")
  end

  local v228 = v3.playerDrawings[p88]

  if v228 then
    for key10, value85 in pairs(v228) do
    end

    v3.playerDrawings[p88] = nil
  end
end))

function v3:Unload(p89)
  if not self.active then
    return
  end

  self.autoDefense = false
  f32("unload")
  self.active = false
  f27()
  f39()
  f10()

  for index27, value86 in ipairs(self.connections) do
    local v229 = value86
    pcall(function() v229:Disconnect() end)
  end

  for index28, value87 in ipairs(self.cleanups) do
  end

  for index29, value88 in ipairs(self.drawings) do
  end

  self.drawings = {}
  v3.lastResult = "unloaded"
end

themeManager:SetLibrary(library)

saveManager:SetLibrary(library)
saveManager:IgnoreThemeSettings()
saveManager:SetIgnoreIndexes({ "MenuKeybind" })

themeManager:SetFolder("ObelusBallistics")

saveManager:SetFolder("ObelusBallistics")
saveManager:BuildConfigSection(v217.Settings)

themeManager:ApplyToTab(v217.Settings)

library:OnUnload(function()
  if v3.Unload then
    v3:Unload("library unload")
  end
end)

v3.lastResult = "ready"
