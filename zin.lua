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
		500
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

local espButton =
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

local aimButton =
	createToggle(
		"AIMBOT",
		200,

		function(value)

			config.AimbotEnabled =
				value

			if not value then
				lockedTarget = nil
			end
		end
	)

--------------------------------------------------
-- SET DEFAULT ESP ON
--------------------------------------------------

config.ESPEnabled =
	true

espButton.Text =
	"ESP: ON"

espButton.BackgroundColor3 =
	Color3.fromRGB(
		40,
		150,
		80
	)

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
