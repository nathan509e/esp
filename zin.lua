local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local camera = workspace.CurrentCamera

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local config = {

	-- ESP
	ESPEnabled = true,
	NameESPEnabled = true,
	NoclipEnabled = false,

	VisibleHue = 0.33,
	HiddenHue = 0,

	FillIntensity = 0.35,
	OutlineTransparency = 0,

	-- frequência de atualização do ESP
	-- menor = mais rápido
	ESPUpdateInterval = 0.06,

	--------------------------------------------------
	-- AIMBOT
	--------------------------------------------------

	AimbotEnabled = false,

	-- raio em pixels
	AimbotFOV = 220,

	-- velocidade de aproximação
	-- 20~30 = rápido
	AimSpeed = 26,

	ShowFOV = true
}

--------------------------------------------------
-- ESTADO
--------------------------------------------------

local highlights = {}
local nameTags = {}

local noclipConnection = nil
local originalCollision = {}

local rightMouseDown = false
local lockedTarget = nil

local espAccumulator = 0

--------------------------------------------------
-- LIMPEZA CASO EXECUTE NOVAMENTE
--------------------------------------------------

local oldGui = playerGui:FindFirstChild("ESPSettings")

if oldGui then
	oldGui:Destroy()
end

--------------------------------------------------
-- RAYCAST PARAMS REUTILIZÁVEL
--------------------------------------------------

local rayParams = RaycastParams.new()

rayParams.FilterType =
	Enum.RaycastFilterType.Exclude

rayParams.IgnoreWater = true

local function updateRaycastIgnore()

	local ignore = {}

	if localPlayer.Character then
		table.insert(
			ignore,
			localPlayer.Character
		)
	end

	rayParams.FilterDescendantsInstances =
		ignore
end

updateRaycastIgnore()

localPlayer.CharacterAdded:Connect(
	function()
		task.wait()

		updateRaycastIgnore()
	end
)

--------------------------------------------------
-- CORES
--------------------------------------------------

local function getVisibleColor()

	return Color3.fromHSV(
		config.VisibleHue,
		1,
		1
	)
end

local function getHiddenColor()

	return Color3.fromHSV(
		config.HiddenHue,
		1,
		1
	)
end

--------------------------------------------------
-- NOCLIP
--------------------------------------------------

local function applyNoclip()

	local character = localPlayer.Character

	if not character then
		return
	end

	for _, obj in ipairs(character:GetDescendants()) do

		if obj:IsA("BasePart") then

			if originalCollision[obj] == nil then
				originalCollision[obj] = obj.CanCollide
			end

			obj.CanCollide = false
		end
	end
end

local function restoreNoclip()

	for part, originalState in pairs(originalCollision) do

		if part and part.Parent then
			part.CanCollide = originalState
		end
	end

	table.clear(originalCollision)
end

local function setNoclip(value)

	config.NoclipEnabled = value

	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	if value then

		applyNoclip()

		noclipConnection =
			RunService.Stepped:Connect(function()

				if config.NoclipEnabled then
					applyNoclip()
				end
			end)

	else

		restoreNoclip()
	end
end

localPlayer.CharacterAdded:Connect(function()

	table.clear(originalCollision)

	if config.NoclipEnabled then
		task.wait(0.2)
		applyNoclip()
	end
end)

--------------------------------------------------
-- NAME ESP
--------------------------------------------------

local function createNameTag(player, character)

	if player == localPlayer then
		return
	end

	if nameTags[player] then
		nameTags[player]:Destroy()
		nameTags[player] = nil
	end

	local head =
		character:FindFirstChild("Head")
		or character:WaitForChild("Head", 5)

	if not head then
		return
	end

	local billboard =
		Instance.new("BillboardGui")

	billboard.Name =
		"PlayerNameESP"

	billboard.Adornee =
		head

	billboard.Size =
		UDim2.fromOffset(
			220,
			40
		)

	billboard.StudsOffset =
		Vector3.new(
			0,
			2.2,
			0
		)

	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 2000
	billboard.Enabled = config.NameESPEnabled
	billboard.Parent = playerGui

	local text =
		Instance.new("TextLabel")

	text.Size =
		UDim2.fromScale(1, 1)

	text.BackgroundTransparency = 1
	text.Text = player.Name

	text.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	text.TextStrokeColor3 =
		Color3.fromRGB(0, 0, 0)

	text.TextStrokeTransparency = 0
	text.Font = Enum.Font.GothamBold
	text.TextSize = 14
	text.Parent = billboard

	nameTags[player] = billboard
end

--------------------------------------------------
-- ESP
--------------------------------------------------

local function createHighlight(player)

	if player == localPlayer then
		return
	end

	local function apply(character)

		if highlights[player] then
			highlights[player]:Destroy()
		end

		local highlight =
			Instance.new("Highlight")

		highlight.Name =
			"PlayerESP"

		highlight.Adornee =
			character

		highlight.FillTransparency =
			1 - config.FillIntensity

		highlight.OutlineTransparency =
			config.OutlineTransparency

		highlight.DepthMode =
			Enum.HighlightDepthMode.AlwaysOnTop

		highlight.Parent =
			character

		highlights[player] =
			highlight

		createNameTag(
			player,
			character
		)
	end

	if player.Character then
		apply(player.Character)
	end

	player.CharacterAdded:Connect(
		apply
	)
end

local function removeHighlight(player)

	if highlights[player] then

		highlights[player]:Destroy()

		highlights[player] = nil
	end

	if nameTags[player] then

		nameTags[player]:Destroy()
		nameTags[player] = nil

	end

	if lockedTarget == player then
		lockedTarget = nil
	end
end

--------------------------------------------------
-- CHARACTER VALIDATION
--------------------------------------------------

local function getValidCharacter(player)

	local character =
		player.Character

	if not character then
		return nil
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	if not humanoid
		or humanoid.Health <= 0
	then
		return nil
	end

	local head =
		character:FindFirstChild(
			"Head"
		)

	if not head then
		return nil
	end

	return character, humanoid, head
end

--------------------------------------------------
-- LINE OF SIGHT
--------------------------------------------------

local function isPlayerVisible(player)

	if not camera then
		return false
	end

	local character, _, head =
		getValidCharacter(player)

	if not character then
		return false
	end

	local origin =
		camera.CFrame.Position

	local direction =
		head.Position - origin

	local result =
		workspace:Raycast(
			origin,
			direction,
			rayParams
		)

	if not result then
		return true
	end

	return result.Instance:IsDescendantOf(
		character
	)
end

--------------------------------------------------
-- DISTÂNCIA DO ALVO AO CENTRO DA TELA
--------------------------------------------------

local function getScreenDistance(head)

	local position,
		onScreen =
		camera:WorldToViewportPoint(
			head.Position
		)

	if not onScreen
		or position.Z <= 0
	then
		return nil
	end

	local center =
		Vector2.new(
			camera.ViewportSize.X / 2,
			camera.ViewportSize.Y / 2
		)

	local target =
		Vector2.new(
			position.X,
			position.Y
		)

	return (
		target - center
	).Magnitude
end

--------------------------------------------------
-- VALIDAR ALVO AIMBOT
--------------------------------------------------

local function isValidAimbotTarget(player)

	if not player
		or player == localPlayer
	then
		return false
	end

	local character, _, head =
		getValidCharacter(player)

	if not character then
		return false
	end

	local distance =
		getScreenDistance(head)

	if not distance
		or distance > config.AimbotFOV
	then
		return false
	end

	if not isPlayerVisible(player) then
		return false
	end

	return true
end

--------------------------------------------------
-- PEGAR MELHOR ALVO
--------------------------------------------------

local function findClosestTarget()

	local bestPlayer = nil
	local bestDistance =
		config.AimbotFOV

	for _, player in ipairs(
		Players:GetPlayers()
	) do

		if player ~= localPlayer then

			local character, _, head =
				getValidCharacter(player)

			if character then

				local distance =
					getScreenDistance(head)

				if distance
					and distance < bestDistance
					and isPlayerVisible(player)
				then

					bestDistance =
						distance

					bestPlayer =
						player
				end
			end
		end
	end

	return bestPlayer
end

--------------------------------------------------
-- AIMBOT
--------------------------------------------------

local function updateAimbot(dt, menuOpen)

	if not config.AimbotEnabled then
		lockedTarget = nil
		return
	end

	-- somente segurando RMB
	if not rightMouseDown then
		lockedTarget = nil
		return
	end

	-- não mexer enquanto configura menu
	if menuOpen then
		return
	end

	camera =
		workspace.CurrentCamera

	if not camera then
		return
	end

	--------------------------------------------------
	-- MANTER ALVO TRAVADO
	--------------------------------------------------

	if not isValidAimbotTarget(
		lockedTarget
	) then

		lockedTarget =
			findClosestTarget()
	end

	if not lockedTarget then
		return
	end

	local character, _, head =
		getValidCharacter(
			lockedTarget
		)

	if not character then
		lockedTarget = nil
		return
	end

	--------------------------------------------------
	-- CÂMERA
	--------------------------------------------------

	local current =
		camera.CFrame

	local target =
		CFrame.lookAt(
			current.Position,
			head.Position
		)

	--------------------------------------------------
	-- INTERPOLAÇÃO EXPONENCIAL
	--
	-- Muito mais consistente que um Lerp fixo.
	--------------------------------------------------

	local alpha =
		1 - math.exp(
			-config.AimSpeed * dt
		)

	camera.CFrame =
		current:Lerp(
			target,
			alpha
		)
end

--------------------------------------------------
-- PLAYERS
--------------------------------------------------

for _, player in ipairs(
	Players:GetPlayers()
) do

	createHighlight(player)
end

Players.PlayerAdded:Connect(
	createHighlight
)

Players.PlayerRemoving:Connect(
	removeHighlight
)

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui =
	Instance.new("ScreenGui")

gui.Name =
	"ESPSettings"

gui.ResetOnSpawn =
	false

gui.IgnoreGuiInset =
	true

gui.Parent =
	playerGui

--------------------------------------------------
-- MAIN
--------------------------------------------------

local main =
	Instance.new("Frame")

main.Size =
	UDim2.fromOffset(
		370,
		700
	)

main.Position =
	UDim2.new(
		0.5,
		-185,
		0.5,
		-250
	)

main.BackgroundColor3 =
	Color3.fromRGB(
		20,
		20,
		24
	)

main.BorderSizePixel = 0

main.Parent = gui

local corner =
	Instance.new("UICorner")

corner.CornerRadius =
	UDim.new(
		0,
		10
	)

corner.Parent =
	main

--------------------------------------------------
-- TITLE
--------------------------------------------------

local title =
	Instance.new("TextLabel")

title.Size =
	UDim2.new(
		1,
		-20,
		0,
		35
	)

title.Position =
	UDim2.fromOffset(
		10,
		5
	)

title.BackgroundTransparency =
	1

title.Text =
	"Player ESP"

title.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

title.TextSize =
	18

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent =
	main

--------------------------------------------------
-- LABEL
--------------------------------------------------

local function createLabel(
	text,
	y
)

	local object =
		Instance.new("TextLabel")

	object.Size =
		UDim2.new(
			1,
			-40,
			0,
			22
		)

	object.Position =
		UDim2.fromOffset(
			20,
			y
		)

	object.BackgroundTransparency =
		1

	object.Text =
		text

	object.TextColor3 =
		Color3.fromRGB(
			220,
			220,
			220
		)

	object.Font =
		Enum.Font.Gotham

	object.TextSize =
		13

	object.TextXAlignment =
		Enum.TextXAlignment.Left

	object.Parent =
		main

	return object
end

--------------------------------------------------
-- TOGGLE GENERATOR
--------------------------------------------------

local function createToggle(
	text,
	x,
	callback
)

	local button =
		Instance.new("TextButton")

	button.Size =
		UDim2.fromOffset(
			150,
			32
		)

	button.Position =
		UDim2.fromOffset(
			x,
			50
		)

	button.BorderSizePixel =
		0

	button.Font =
		Enum.Font.GothamBold

	button.TextSize =
		14

	button.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	button.Parent =
		main

	local c =
		Instance.new("UICorner")

	c.CornerRadius =
		UDim.new(
			0,
			6
		)

	c.Parent =
		button

	local enabled = false

	local function refresh()

		button.Text =
			text
			.. (
				enabled
				and ": ON"
				or ": OFF"
			)

		button.BackgroundColor3 =
			enabled
			and Color3.fromRGB(
				40,
				150,
				80
			)
			or Color3.fromRGB(
				150,
				50,
				50
			)
	end

	button.MouseButton1Click:Connect(
		function()

			enabled =
				not enabled

			callback(enabled)

			refresh()
		end
	)

	refresh()

	return button,
		function(value)

			enabled = value

			refresh()
		end
end

--------------------------------------------------
-- ESP TOGGLE
--------------------------------------------------

local espButton, setESPButton =
	createToggle(
		"ESP",
		20,

		function(value)
			config.ESPEnabled =
				value
		end
	)

--------------------------------------------------
-- AIMBOT TOGGLE
--------------------------------------------------

local aimButton, setAimButton =
	createToggle(
		"AIMBOT",
		132,

		function(value)

			config.AimbotEnabled =
				value

			if not value then
				lockedTarget = nil
			end
		end
	)

--------------------------------------------------
-- NAME ESP TOGGLE
--------------------------------------------------

local nameButton, setNameButton =
	createToggle(
		"NAMES",
		244,

		function(value)

			config.NameESPEnabled =
				value

			for _, billboard in pairs(nameTags) do

				if billboard and billboard.Parent then
					billboard.Enabled = value
				end
			end
		end
	)

--------------------------------------------------
-- AJUSTAR OS 3 BOTÕES NA MESMA LINHA
--------------------------------------------------

espButton.Size = UDim2.fromOffset(100, 32)
aimButton.Size = UDim2.fromOffset(100, 32)
nameButton.Size = UDim2.fromOffset(100, 32)

espButton.Position = UDim2.fromOffset(20, 50)
aimButton.Position = UDim2.fromOffset(132, 50)
nameButton.Position = UDim2.fromOffset(244, 50)

--------------------------------------------------
-- NOCLIP TOGGLE
--------------------------------------------------

local noclipButton =
	Instance.new("TextButton")

noclipButton.Size =
	UDim2.fromOffset(78, 26)

noclipButton.Position =
	UDim2.new(
		1,
		-88,
		0,
		8
	)

noclipButton.BorderSizePixel = 0
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 11
noclipButton.TextColor3 = Color3.new(1, 1, 1)
noclipButton.Parent = main

local noclipCorner =
	Instance.new("UICorner")

noclipCorner.CornerRadius =
	UDim.new(0, 6)

noclipCorner.Parent =
	noclipButton

local function updateNoclipButton()

	if config.NoclipEnabled then

		noclipButton.Text = "NOCLIP ON"

		noclipButton.BackgroundColor3 =
			Color3.fromRGB(
				40,
				150,
				80
			)

	else

		noclipButton.Text = "NOCLIP OFF"

		noclipButton.BackgroundColor3 =
			Color3.fromRGB(
				150,
				50,
				50
			)
	end
end

noclipButton.MouseButton1Click:Connect(function()

	setNoclip(
		not config.NoclipEnabled
	)

	updateNoclipButton()
end)

updateNoclipButton()

--------------------------------------------------
-- ESTADOS INICIAIS
--------------------------------------------------

config.ESPEnabled = true
config.NameESPEnabled = true
config.AimbotEnabled = false

setESPButton(true)
setAimButton(false)
setNameButton(true)

--------------------------------------------------
-- HUE SLIDER
--------------------------------------------------

local function createHueSlider(
	y,
	defaultHue,
	callback
)

	local bar =
		Instance.new("Frame")

	bar.Size =
		UDim2.new(
			1,
			-40,
			0,
			18
		)

	bar.Position =
		UDim2.fromOffset(
			20,
			y
		)

	bar.BorderSizePixel =
		0

	bar.Parent =
		main

	local gradient =
		Instance.new("UIGradient")

	gradient.Color =
		ColorSequence.new({

			ColorSequenceKeypoint.new(
				0,
				Color3.fromHSV(0,1,1)
			),

			ColorSequenceKeypoint.new(
				0.166,
				Color3.fromHSV(.166,1,1)
			),

			ColorSequenceKeypoint.new(
				0.333,
				Color3.fromHSV(.333,1,1)
			),

			ColorSequenceKeypoint.new(
				0.5,
				Color3.fromHSV(.5,1,1)
			),

			ColorSequenceKeypoint.new(
				0.666,
				Color3.fromHSV(.666,1,1)
			),

			ColorSequenceKeypoint.new(
				0.833,
				Color3.fromHSV(.833,1,1)
			),

			ColorSequenceKeypoint.new(
				1,
				Color3.fromHSV(1,1,1)
			)

		})

	gradient.Parent =
		bar

	local marker =
		Instance.new("Frame")

	marker.Size =
		UDim2.fromOffset(
			3,
			26
		)

	marker.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	marker.Position =
		UDim2.new(
			defaultHue,
			0,
			0.5,
			0
		)

	marker.BackgroundColor3 =
		Color3.new(
			1,
			1,
			1
		)

	marker.BorderSizePixel =
		0

	marker.Parent =
		bar

	local dragging =
		false

	local function update(input)

		local x =
			input.Position.X
			- bar.AbsolutePosition.X

		local value =
			math.clamp(
				x
				/ bar.AbsoluteSize.X,
				0,
				1
			)

		marker.Position =
			UDim2.new(
				value,
				0,
				0.5,
				0
			)

		callback(value)
	end

	bar.InputBegan:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			then

				dragging =
					true

				update(input)
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)

			if dragging
				and input.UserInputType ==
				Enum.UserInputType.MouseMovement
			then

				update(input)
			end
		end
	)

	UserInputService.InputEnded:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			then

				dragging =
					false
			end
		end
	)
end

--------------------------------------------------
-- VISIBLE COLOR
--------------------------------------------------

createLabel(
	"Cor - jogador visível",
	100
)

createHueSlider(
	128,
	config.VisibleHue,

	function(value)
		config.VisibleHue =
			value
	end
)

--------------------------------------------------
-- HIDDEN COLOR
--------------------------------------------------

createLabel(
	"Cor - atrás da parede",
	165
)

createHueSlider(
	193,
	config.HiddenHue,

	function(value)
		config.HiddenHue =
			value
	end
)

--------------------------------------------------
-- GENERIC SLIDER
--------------------------------------------------

local function createSlider(
	labelText,
	y,
	minValue,
	maxValue,
	defaultValue,
	callback,
	format
)

	local text =
		createLabel(
			"",
			y
		)

	local bar =
		Instance.new("Frame")

	bar.Size =
		UDim2.new(
			1,
			-40,
			0,
			18
		)

	bar.Position =
		UDim2.fromOffset(
			20,
			y + 28
		)

	bar.BackgroundColor3 =
		Color3.fromRGB(
			55,
			55,
			65
		)

	bar.BorderSizePixel =
		0

	bar.Parent =
		main

	local percentage =
		(defaultValue - minValue)
		/ (maxValue - minValue)

	local fill =
		Instance.new("Frame")

	fill.Size =
		UDim2.new(
			percentage,
			0,
			1,
			0
		)

	fill.BackgroundColor3 =
		Color3.fromRGB(
			200,
			200,
			200
		)

	fill.BorderSizePixel =
		0

	fill.Parent =
		bar

	local marker =
		Instance.new("Frame")

	marker.Size =
		UDim2.fromOffset(
			3,
			26
		)

	marker.AnchorPoint =
		Vector2.new(
			0.5,
			0.5
		)

	marker.Position =
		UDim2.new(
			percentage,
			0,
			0.5,
			0
		)

	marker.BackgroundColor3 =
		Color3.new(1,1,1)

	marker.BorderSizePixel =
		0

	marker.Parent =
		bar

	local dragging =
		false

	local function setValue(input)

		local x =
			input.Position.X
			- bar.AbsolutePosition.X

		local pct =
			math.clamp(
				x / bar.AbsoluteSize.X,
				0,
				1
			)

		local value =
			minValue
			+ (
				maxValue - minValue
			) * pct

		fill.Size =
			UDim2.new(
				pct,
				0,
				1,
				0
			)

		marker.Position =
			UDim2.new(
				pct,
				0,
				0.5,
				0
			)

		text.Text =
			labelText
			.. ": "
			.. format(value)

		callback(value)
	end

	text.Text =
		labelText
		.. ": "
		.. format(defaultValue)

	bar.InputBegan:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			then

				dragging = true

				setValue(input)
			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)

			if dragging
				and input.UserInputType ==
				Enum.UserInputType.MouseMovement
			then

				setValue(input)
			end
		end
	)

	UserInputService.InputEnded:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1
			then

				dragging = false
			end
		end
	)
end

--------------------------------------------------
-- FILL
--------------------------------------------------

createSlider(
	"Preenchimento",
	230,
	0,
	1,
	config.FillIntensity,

	function(value)
		config.FillIntensity =
			value
	end,

	function(value)
		return math.floor(
			value * 100
		) .. "%"
	end
)

--------------------------------------------------
-- FOV
--------------------------------------------------

createSlider(
	"FOV",
	295,
	50,
	500,
	config.AimbotFOV,

	function(value)

		config.AimbotFOV =
			math.floor(value)

	end,

	function(value)

		return tostring(
			math.floor(value)
		)

	end
)

--------------------------------------------------
-- AIM SPEED
--------------------------------------------------

createSlider(
	"Velocidade da mira",
	360,
	5,
	50,
	config.AimSpeed,

	function(value)

		config.AimSpeed =
			value

	end,

	function(value)

		return tostring(
			math.floor(value)
		)

	end
)

--------------------------------------------------
-- HINT
--------------------------------------------------

local hint =
	createLabel(
		"INSERT = menu | RMB = aimbot",
		435
	)

hint.TextColor3 =
	Color3.fromRGB(
		140,
		140,
		150
	)


--------------------------------------------------
-- SPECTATOR / TARGET CAMERA
--------------------------------------------------

local spectatorTargetIndex = 1
local spectatorTarget = nil
local spectatorEnabled = false
local spectatorFullscreen = true
local spectatorConnection = nil

local PIP_WORLD_RADIUS = 160
local PIP_MAX_PARTS = 300
local PIP_WORLD_REFRESH = 0.75

--------------------------------------------------
-- SPECTATOR UI - MESMO GUI
--------------------------------------------------

local spectatorSection =
	Instance.new("TextLabel")

spectatorSection.Size =
	UDim2.new(
		1,
		-40,
		0,
		22
	)

spectatorSection.Position =
	UDim2.fromOffset(
		20,
		470
	)

spectatorSection.BackgroundTransparency = 1
spectatorSection.Text = "SPECTATOR / TARGET CAMERA"
spectatorSection.TextColor3 = Color3.fromRGB(220, 220, 220)
spectatorSection.Font = Enum.Font.GothamBold
spectatorSection.TextSize = 13
spectatorSection.TextXAlignment = Enum.TextXAlignment.Left
spectatorSection.Parent = main

local spectatorTargetLabel =
	Instance.new("TextLabel")

spectatorTargetLabel.Size =
	UDim2.new(
		1,
		-40,
		0,
		28
	)

spectatorTargetLabel.Position =
	UDim2.fromOffset(
		20,
		495
	)

spectatorTargetLabel.BackgroundTransparency = 1
spectatorTargetLabel.Text = "Nenhum jogador"
spectatorTargetLabel.TextColor3 = Color3.fromRGB(200, 200, 205)
spectatorTargetLabel.Font = Enum.Font.GothamBold
spectatorTargetLabel.TextSize = 13
spectatorTargetLabel.Parent = main

local function createSpectatorButton(
	textValue,
	x,
	y,
	width,
	height
)

	local button =
		Instance.new("TextButton")

	button.Size =
		UDim2.fromOffset(
			width,
			height
		)

	button.Position =
		UDim2.fromOffset(
			x,
			y
		)

	button.BackgroundColor3 =
		Color3.fromRGB(
			45,
			45,
			55
		)

	button.BorderSizePixel = 0
	button.Text = textValue
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 12
	button.Parent = main

	local buttonCorner =
		Instance.new("UICorner")

	buttonCorner.CornerRadius =
		UDim.new(0, 6)

	buttonCorner.Parent =
		button

	return button
end

local spectatorPreviousButton =
	createSpectatorButton(
		"<",
		20,
		530,
		50,
		32
	)

local spectatorStartButton =
	createSpectatorButton(
		"SPECTATE",
		80,
		530,
		200,
		32
	)

local spectatorNextButton =
	createSpectatorButton(
		">",
		290,
		530,
		50,
		32
	)

local spectatorModeButton =
	createSpectatorButton(
		"MODO: TELA CHEIA",
		20,
		572,
		320,
		32
	)

local spectatorStopButton =
	createSpectatorButton(
		"STOP / VOLTAR",
		20,
		614,
		320,
		32
	)

spectatorStopButton.BackgroundColor3 =
	Color3.fromRGB(
		130,
		45,
		45
	)

--------------------------------------------------
-- PIP - MESMO SCREEN GUI
--------------------------------------------------

local spectatorPIP =
	Instance.new("Frame")

spectatorPIP.Name =
	"SpectatorPIP"

spectatorPIP.Size =
	UDim2.fromOffset(
		420,
		260
	)

spectatorPIP.Position =
	UDim2.new(
		1,
		-440,
		0.5,
		-130
	)

spectatorPIP.BackgroundColor3 =
	Color3.fromRGB(
		10,
		10,
		12
	)

spectatorPIP.BorderSizePixel = 0
spectatorPIP.Visible = false
spectatorPIP.Parent = gui

local spectatorPIPCorner =
	Instance.new("UICorner")

spectatorPIPCorner.CornerRadius =
	UDim.new(0, 8)

spectatorPIPCorner.Parent =
	spectatorPIP

local spectatorPIPTitle =
	Instance.new("TextLabel")

spectatorPIPTitle.Size =
	UDim2.new(
		1,
		-16,
		0,
		28
	)

spectatorPIPTitle.Position =
	UDim2.fromOffset(
		8,
		2
	)

spectatorPIPTitle.BackgroundTransparency = 1
spectatorPIPTitle.Text = "TARGET CAM"
spectatorPIPTitle.TextColor3 = Color3.new(1, 1, 1)
spectatorPIPTitle.Font = Enum.Font.GothamBold
spectatorPIPTitle.TextSize = 13
spectatorPIPTitle.TextXAlignment = Enum.TextXAlignment.Left
spectatorPIPTitle.Parent = spectatorPIP

local spectatorViewport =
	Instance.new("ViewportFrame")

spectatorViewport.Size =
	UDim2.new(
		1,
		-12,
		1,
		-40
	)

spectatorViewport.Position =
	UDim2.fromOffset(
		6,
		32
	)

spectatorViewport.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		18
	)

spectatorViewport.BorderSizePixel = 0
spectatorViewport.Ambient = Color3.fromRGB(180, 180, 180)
spectatorViewport.LightColor = Color3.new(1, 1, 1)
spectatorViewport.LightDirection = Vector3.new(-1, -1, -1)
spectatorViewport.Parent = spectatorPIP

local spectatorViewportCorner =
	Instance.new("UICorner")

spectatorViewportCorner.CornerRadius =
	UDim.new(0, 5)

spectatorViewportCorner.Parent =
	spectatorViewport

local spectatorWorld =
	Instance.new("WorldModel")

spectatorWorld.Name =
	"SpectatorWorld"

spectatorWorld.Parent =
	spectatorViewport

local spectatorWorldFolder =
	Instance.new("Folder")

spectatorWorldFolder.Name =
	"Environment"

spectatorWorldFolder.Parent =
	spectatorWorld

local spectatorPIPCamera =
	Instance.new("Camera")

spectatorPIPCamera.Name =
	"SpectatorCamera"

spectatorPIPCamera.FieldOfView = 70
spectatorPIPCamera.Parent = spectatorViewport

spectatorViewport.CurrentCamera =
	spectatorPIPCamera

--------------------------------------------------
-- TARGETS
--------------------------------------------------

local function getSpectatorTargets()

	local targets = {}

	for _, player in ipairs(
		Players:GetPlayers()
	) do

		if player ~= localPlayer then

			local character =
				player.Character

			if character then

				local humanoid =
					character:FindFirstChildOfClass(
						"Humanoid"
					)

				if humanoid
					and humanoid.Health > 0
				then

					table.insert(
						targets,
						player
					)
				end
			end
		end
	end

	table.sort(
		targets,
		function(a, b)
			return a.Name < b.Name
		end
	)

	return targets
end

local function restoreOwnCamera()

	local currentCamera =
		workspace.CurrentCamera

	local character =
		localPlayer.Character

	if not character then
		return
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	if humanoid then

		currentCamera.CameraType =
			Enum.CameraType.Custom

		currentCamera.CameraSubject =
			humanoid
	end
end

--------------------------------------------------
-- PIP WORLD
--------------------------------------------------

local pipOverlapParams =
	OverlapParams.new()

pipOverlapParams.FilterType =
	Enum.RaycastFilterType.Exclude

pipOverlapParams.MaxParts =
	PIP_MAX_PARTS

local function clearSpectatorWorld()

	for _, obj in ipairs(
		spectatorWorldFolder:GetChildren()
	) do

		obj:Destroy()
	end
end

local function cloneSpectatorPart(part)

	if not part:IsA("BasePart") then
		return
	end

	if part.Transparency >= 1 then
		return
	end

	local oldArchivable =
		part.Archivable

	part.Archivable =
		true

	local success, clone =
		pcall(function()
			return part:Clone()
		end)

	part.Archivable =
		oldArchivable

	if not success
		or not clone
	then

		return
	end

	for _, obj in ipairs(
		clone:GetDescendants()
	) do

		if obj:IsA("Script")
			or obj:IsA("LocalScript")
			or obj:IsA("Highlight")
		then

			obj:Destroy()
		end
	end

	clone.Anchored = true
	clone.CanCollide = false
	clone.CanTouch = false
	clone.CanQuery = false
	clone.Parent = spectatorWorldFolder
end

local function refreshSpectatorWorld()

	if not spectatorEnabled
		or spectatorFullscreen
		or not spectatorTarget
	then

		return
	end

	local character =
		spectatorTarget.Character

	if not character then
		return
	end

	local head =
		character:FindFirstChild(
			"Head"
		)

	if not head then
		return
	end

	clearSpectatorWorld()

	local exclude = {}

	for _, player in ipairs(
		Players:GetPlayers()
	) do

		if player.Character then

			table.insert(
				exclude,
				player.Character
			)
		end
	end

	pipOverlapParams.FilterDescendantsInstances =
		exclude

	local parts =
		workspace:GetPartBoundsInRadius(
			head.Position,
			PIP_WORLD_RADIUS,
			pipOverlapParams
		)

	local count = 0

	for _, part in ipairs(parts) do

		count += 1

		if count > PIP_MAX_PARTS then
			break
		end

		cloneSpectatorPart(
			part
		)
	end
end

--------------------------------------------------
-- STOP SPECTATOR
--------------------------------------------------

local function stopSpectator()

	spectatorEnabled = false

	if spectatorConnection then

		spectatorConnection:Disconnect()
		spectatorConnection = nil
	end

	spectatorPIP.Visible = false

	clearSpectatorWorld()

	restoreOwnCamera()

	spectatorStartButton.Text =
		"SPECTATE"

	spectatorStartButton.BackgroundColor3 =
		Color3.fromRGB(
			45,
			45,
			55
		)
end

--------------------------------------------------
-- START SPECTATOR
--------------------------------------------------

local function startSpectator(player)

	if not player then
		return false
	end

	local character =
		player.Character

	if not character then
		return false
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	local head =
		character:FindFirstChild(
			"Head"
		)

	if not humanoid
		or humanoid.Health <= 0
		or not head
	then

		return false
	end

	if spectatorConnection then

		spectatorConnection:Disconnect()
		spectatorConnection = nil
	end

	spectatorTarget =
		player

	spectatorEnabled =
		true

	spectatorPIPTitle.Text =
		"TARGET CAM - "
		.. player.DisplayName

	if spectatorFullscreen then

		spectatorPIP.Visible =
			false

	else

		restoreOwnCamera()

		spectatorPIP.Visible =
			true

		refreshSpectatorWorld()
	end

	local worldRefreshTimer = 0

	spectatorConnection =
		RunService.RenderStepped:Connect(
			function(dt)

				if not spectatorEnabled
					or not spectatorTarget
				then

					return
				end

				local targetCharacter =
					spectatorTarget.Character

				if not targetCharacter then

					stopSpectator()
					return
				end

				local targetHumanoid =
					targetCharacter:FindFirstChildOfClass(
						"Humanoid"
					)

				local targetHead =
					targetCharacter:FindFirstChild(
						"Head"
					)

				if not targetHumanoid
					or targetHumanoid.Health <= 0
					or not targetHead
				then

					stopSpectator()
					return
				end

				local forward =
					targetHead.CFrame.LookVector

				local cameraPosition =
					targetHead.Position
					+ forward * 0.8
					+ Vector3.new(
						0,
						0.15,
						0
					)

				local targetCameraCFrame =
					CFrame.lookAt(
						cameraPosition,
						cameraPosition + forward
					)

				if spectatorFullscreen then

					spectatorPIP.Visible =
						false

					local currentCamera =
						workspace.CurrentCamera

					currentCamera.CameraType =
						Enum.CameraType.Scriptable

					currentCamera.CFrame =
						targetCameraCFrame

				else

					spectatorPIP.Visible =
						true

					if workspace.CurrentCamera.CameraType ==
						Enum.CameraType.Scriptable
					then

						restoreOwnCamera()
					end

					spectatorPIPCamera.CFrame =
						targetCameraCFrame

					worldRefreshTimer += dt

					if worldRefreshTimer >=
						PIP_WORLD_REFRESH
					then

						worldRefreshTimer = 0
						refreshSpectatorWorld()
					end
				end
			end
		)

	return true
end

--------------------------------------------------
-- UPDATE SPECTATOR TARGET
--------------------------------------------------

local function updateSpectatorTarget()

	local targets =
		getSpectatorTargets()

	if #targets == 0 then

		spectatorTarget = nil
		spectatorTargetLabel.Text =
			"Nenhum jogador disponível"

		return
	end

	spectatorTargetIndex =
		math.clamp(
			spectatorTargetIndex,
			1,
			#targets
		)

	spectatorTarget =
		targets[
			spectatorTargetIndex
		]

	spectatorTargetLabel.Text =
		spectatorTarget.DisplayName
		.. "  (@"
		.. spectatorTarget.Name
		.. ")"

	if spectatorEnabled then

		startSpectator(
			spectatorTarget
		)
	end
end

--------------------------------------------------
-- SPECTATOR BUTTON EVENTS
--------------------------------------------------

spectatorPreviousButton.MouseButton1Click:Connect(
	function()

		local targets =
			getSpectatorTargets()

		if #targets == 0 then
			updateSpectatorTarget()
			return
		end

		spectatorTargetIndex -= 1

		if spectatorTargetIndex < 1 then

			spectatorTargetIndex =
				#targets
		end

		updateSpectatorTarget()
	end
)

spectatorNextButton.MouseButton1Click:Connect(
	function()

		local targets =
			getSpectatorTargets()

		if #targets == 0 then
			updateSpectatorTarget()
			return
		end

		spectatorTargetIndex += 1

		if spectatorTargetIndex >
			#targets
		then

			spectatorTargetIndex = 1
		end

		updateSpectatorTarget()
	end
)

spectatorStartButton.MouseButton1Click:Connect(
	function()

		if not spectatorTarget then
			updateSpectatorTarget()
		end

		if startSpectator(
			spectatorTarget
		) then

			spectatorStartButton.Text =
				"SPECTATING..."

			spectatorStartButton.BackgroundColor3 =
				Color3.fromRGB(
					40,
					140,
					75
				)
		end
	end
)

spectatorModeButton.MouseButton1Click:Connect(
	function()

		spectatorFullscreen =
			not spectatorFullscreen

		if spectatorFullscreen then

			spectatorModeButton.Text =
				"MODO: TELA CHEIA"

		else

			spectatorModeButton.Text =
				"MODO: JANELA"
		end

		if spectatorEnabled
			and spectatorTarget
		then

			startSpectator(
				spectatorTarget
			)
		end
	end
)

spectatorStopButton.MouseButton1Click:Connect(
	function()

		stopSpectator()
	end
)

Players.PlayerRemoving:Connect(
	function(player)

		if player ==
			spectatorTarget
		then

			stopSpectator()
			task.wait()
			updateSpectatorTarget()
		end
	end
)

updateSpectatorTarget()

--------------------------------------------------
-- FOV CIRCLE
--------------------------------------------------

local fovCircle =
	Instance.new("Frame")

fovCircle.Name =
	"FOVCircle"

fovCircle.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

fovCircle.BackgroundTransparency =
	1

fovCircle.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

fovCircle.ZIndex =
	100

fovCircle.Parent =
	gui

local fovCorner =
	Instance.new("UICorner")

fovCorner.CornerRadius =
	UDim.new(
		1,
		0
	)

fovCorner.Parent =
	fovCircle

local fovStroke =
	Instance.new("UIStroke")

fovStroke.Thickness =
	1

fovStroke.Transparency =
	0.35

fovStroke.Color =
	Color3.fromRGB(
		255,
		255,
		255
	)

fovStroke.Parent =
	fovCircle

--------------------------------------------------
-- INSERT
--------------------------------------------------

main.Visible =
	false

UserInputService.InputBegan:Connect(
	function(input, processed)

		if input.KeyCode ==
			Enum.KeyCode.Insert
		then

			main.Visible =
				not main.Visible
		end

		if not processed
			and input.KeyCode ==
				Enum.KeyCode.N
		then

			setNoclip(
				not config.NoclipEnabled
			)

			updateNoclipButton()
		end

		if input.UserInputType ==
			Enum.UserInputType.MouseButton2
		then

			rightMouseDown =
				true
		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton2
		then

			rightMouseDown =
				false

			lockedTarget =
				nil
		end
	end
)

--------------------------------------------------
-- DRAG WINDOW
--------------------------------------------------

local windowDragging =
	false

local dragStart
local startPosition

title.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
		then

			windowDragging =
				true

			dragStart =
				input.Position

			startPosition =
				main.Position
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if windowDragging
			and input.UserInputType ==
			Enum.UserInputType.MouseMovement
		then

			local delta =
				input.Position
				- dragStart

			main.Position =
				UDim2.new(

					startPosition.X.Scale,
					startPosition.X.Offset
						+ delta.X,

					startPosition.Y.Scale,
					startPosition.Y.Offset
						+ delta.Y
				)
		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
		then

			windowDragging =
				false
		end
	end
)

--------------------------------------------------
-- UPDATE ESP
--------------------------------------------------

local function updateESP()

	local visibleColor =
		getVisibleColor()

	local hiddenColor =
		getHiddenColor()

	for player, highlight in pairs(
		highlights
	) do

		if not highlight.Parent then
			continue
		end

		highlight.Enabled =
			config.ESPEnabled

		if not config.ESPEnabled then
			continue
		end

		highlight.FillTransparency =
			1 - config.FillIntensity

		highlight.OutlineTransparency =
			config.OutlineTransparency

		if isPlayerVisible(player) then

			highlight.FillColor =
				visibleColor

			highlight.OutlineColor =
				visibleColor

		else

			highlight.FillColor =
				hiddenColor

			highlight.OutlineColor =
				hiddenColor
		end
	end
end

--------------------------------------------------
-- MAIN LOOP
--------------------------------------------------

RunService.RenderStepped:Connect(
	function(dt)

		camera =
			workspace.CurrentCamera

		--------------------------------------------------
		-- FOV
		--------------------------------------------------

		local diameter =
			config.AimbotFOV * 2

		fovCircle.Size =
			UDim2.fromOffset(
				diameter,
				diameter
			)

		fovCircle.Visible =
			config.ShowFOV
			and config.AimbotEnabled

		--------------------------------------------------
		-- AIMBOT
		--------------------------------------------------

		updateAimbot(
			dt,
			main.Visible
		)

		--------------------------------------------------
		-- ESP COM THROTTLE
		--------------------------------------------------

		espAccumulator += dt

		if espAccumulator >=
			config.ESPUpdateInterval
		then

			espAccumulator = 0

			updateESP()
		end
	end
)
