local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--------------------------------------------------
-- CONFIGURAÇÕES
--------------------------------------------------

local config = {
	-- ESP
	Enabled = true,

	VisibleHue = 0.33, -- Verde
	HiddenHue = 0,     -- Vermelho

	FillIntensity = 0.35,
	OutlineTransparency = 0,

	-- AIMBOT
	AimbotEnabled = false,

	-- Quanto maior, mais rápido trava no alvo.
	-- 0 = instantâneo
	AimbotSmoothness = 0.18,

	-- Distância em pixels do centro da tela
	-- para selecionar um alvo
	AimbotFOV = 250
}

local highlights = {}

--------------------------------------------------
-- LIMPAR GUI ANTIGA CASO EXECUTE NOVAMENTE
--------------------------------------------------

local playerGui = localPlayer:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("ESPSettings")

if oldGui then
	oldGui:Destroy()
end

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
-- CRIAR HIGHLIGHT
--------------------------------------------------

local function createHighlight(player)

	if player == localPlayer then
		return
	end

	local function apply(character)

		if highlights[player] then
			highlights[player]:Destroy()
		end

		local highlight = Instance.new("Highlight")

		highlight.Name = "PlayerESP"
		highlight.Adornee = character

		highlight.FillTransparency =
			1 - config.FillIntensity

		highlight.OutlineTransparency =
			config.OutlineTransparency

		highlight.DepthMode =
			Enum.HighlightDepthMode.AlwaysOnTop

		highlight.Parent = character

		highlights[player] = highlight
	end

	if player.Character then
		apply(player.Character)
	end

	player.CharacterAdded:Connect(apply)
end

--------------------------------------------------
-- REMOVER HIGHLIGHT
--------------------------------------------------

local function removeHighlight(player)

	if highlights[player] then

		highlights[player]:Destroy()
		highlights[player] = nil

	end
end

--------------------------------------------------
-- VERIFICAR SE PLAYER ESTÁ VISÍVEL
--------------------------------------------------

local function isPlayerVisible(player)

	camera = workspace.CurrentCamera

	if not camera then
		return false
	end

	local character = player.Character

	if not character then
		return false
	end

	local targetPart =
		character:FindFirstChild("Head")
		or character:FindFirstChild("HumanoidRootPart")

	if not targetPart then
		return false
	end

	local origin =
		camera.CFrame.Position

	local direction =
		targetPart.Position - origin

	local params =
		RaycastParams.new()

	params.FilterType =
		Enum.RaycastFilterType.Exclude

	local ignoreList = {}

	if localPlayer.Character then

		table.insert(
			ignoreList,
			localPlayer.Character
		)

	end

	params.FilterDescendantsInstances =
		ignoreList

	params.IgnoreWater = true

	local result =
		workspace:Raycast(
			origin,
			direction,
			params
		)

	-- Não bateu em nada
	if not result then
		return true
	end

	-- Bateu no próprio player alvo
	if result.Instance:IsDescendantOf(character) then
		return true
	end

	-- Parede / objeto bloqueando
	return false
end

--------------------------------------------------
-- AIMBOT - ENCONTRAR PLAYER MAIS PRÓXIMO
-- DO CENTRO DA TELA
--------------------------------------------------

local function getClosestAimbotTarget()

	camera = workspace.CurrentCamera

	if not camera then
		return nil
	end

	local viewportSize =
		camera.ViewportSize

	local screenCenter =
		Vector2.new(
			viewportSize.X / 2,
			viewportSize.Y / 2
		)

	local closestHead = nil
	local closestDistance =
		config.AimbotFOV

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

				local head =
					character:FindFirstChild(
						"Head"
					)

				if humanoid
				and humanoid.Health > 0
				and head
				and isPlayerVisible(player)
				then

					local screenPosition,
						onScreen =
						camera:WorldToViewportPoint(
							head.Position
						)

					if onScreen
						and screenPosition.Z > 0
					then

						local position2D =
							Vector2.new(
								screenPosition.X,
								screenPosition.Y
							)

						local distance =
							(
								position2D
								- screenCenter
							).Magnitude

						if distance
							< closestDistance
						then

							closestDistance =
								distance

							closestHead =
								head

						end
					end
				end
			end
		end
	end

	return closestHead
end

--------------------------------------------------
-- GUI
--------------------------------------------------

local gui = Instance.new("ScreenGui")

gui.Name = "ESPSettings"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

gui.Parent = playerGui

--------------------------------------------------
-- JANELA PRINCIPAL
--------------------------------------------------

local main = Instance.new("Frame")

main.Name = "Main"

main.Size =
	UDim2.fromOffset(
		350,
		390
	)

main.Position =
	UDim2.new(
		0.5,
		-175,
		0.5,
		-195
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

corner.Parent = main

--------------------------------------------------
-- TÍTULO
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

title.BackgroundTransparency = 1

title.Text =
	"Player ESP + Aimbot"

title.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

title.TextSize = 18

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent = main

--------------------------------------------------
-- BOTÃO ESP
--------------------------------------------------

local toggle =
	Instance.new("TextButton")

toggle.Size =
	UDim2.fromOffset(
		130,
		32
	)

toggle.Position =
	UDim2.fromOffset(
		20,
		50
	)

toggle.BorderSizePixel = 0

toggle.Font =
	Enum.Font.GothamBold

toggle.TextSize = 14

toggle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

toggle.Parent = main

local toggleCorner =
	Instance.new("UICorner")

toggleCorner.CornerRadius =
	UDim.new(
		0,
		6
	)

toggleCorner.Parent = toggle

local function updateToggle()

	if config.Enabled then

		toggle.Text =
			"ESP: ON"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				40,
				150,
				80
			)

	else

		toggle.Text =
			"ESP: OFF"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				150,
				50,
				50
			)

	end
end

toggle.MouseButton1Click:Connect(
	function()

		config.Enabled =
			not config.Enabled

		updateToggle()

	end
)

updateToggle()

--------------------------------------------------
-- BOTÃO AIMBOT
--------------------------------------------------

local aimbotToggle =
	Instance.new("TextButton")

aimbotToggle.Size =
	UDim2.fromOffset(
		150,
		32
	)

aimbotToggle.Position =
	UDim2.fromOffset(
		180,
		50
	)

aimbotToggle.BorderSizePixel = 0

aimbotToggle.Font =
	Enum.Font.GothamBold

aimbotToggle.TextSize = 14

aimbotToggle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

aimbotToggle.Parent = main

local aimbotCorner =
	Instance.new("UICorner")

aimbotCorner.CornerRadius =
	UDim.new(
		0,
		6
	)

aimbotCorner.Parent =
	aimbotToggle

local function updateAimbotToggle()

	if config.AimbotEnabled then

		aimbotToggle.Text =
			"AIMBOT: ON"

		aimbotToggle.BackgroundColor3 =
			Color3.fromRGB(
				40,
				150,
				80
			)

	else

		aimbotToggle.Text =
			"AIMBOT: OFF"

		aimbotToggle.BackgroundColor3 =
			Color3.fromRGB(
				150,
				50,
				50
			)

	end
end

aimbotToggle.MouseButton1Click:Connect(
	function()

		config.AimbotEnabled =
			not config.AimbotEnabled

		updateAimbotToggle()

	end
)

updateAimbotToggle()

--------------------------------------------------
-- FUNÇÃO PARA CRIAR LABEL
--------------------------------------------------

local function createLabel(
	text,
	y
)

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.new(
			1,
			-40,
			0,
			22
		)

	label.Position =
		UDim2.fromOffset(
			20,
			y
		)

	label.BackgroundTransparency = 1

	label.Text =
		text

	label.TextColor3 =
		Color3.fromRGB(
			220,
			220,
			220
		)

	label.TextSize = 13

	label.Font =
		Enum.Font.Gotham

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.Parent = main

	return label
end

--------------------------------------------------
-- CRIAR BARRA DE COR
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

	bar.BorderSizePixel = 0

	bar.Parent = main

	local gradient =
		Instance.new("UIGradient")

	gradient.Color =
		ColorSequence.new({

			ColorSequenceKeypoint.new(
				0,
				Color3.fromHSV(
					0,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				0.166,
				Color3.fromHSV(
					0.166,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				0.333,
				Color3.fromHSV(
					0.333,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				0.5,
				Color3.fromHSV(
					0.5,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				0.666,
				Color3.fromHSV(
					0.666,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				0.833,
				Color3.fromHSV(
					0.833,
					1,
					1
				)
			),

			ColorSequenceKeypoint.new(
				1,
				Color3.fromHSV(
					1,
					1,
					1
				)
			)

		})

	gradient.Parent = bar

	--------------------------------------------------
	-- MARCADOR
	--------------------------------------------------

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
		Color3.fromRGB(
			255,
			255,
			255
		)

	marker.BorderSizePixel = 0

	marker.ZIndex = 5

	marker.Parent = bar

	--------------------------------------------------
	-- DRAG
	--------------------------------------------------

	local dragging = false

	local function update(input)

		local relative =
			input.Position.X
			- bar.AbsolutePosition.X

		local percentage =
			math.clamp(
				relative
				/ bar.AbsoluteSize.X,
				0,
				1
			)

		marker.Position =
			UDim2.new(
				percentage,
				0,
				0.5,
				0
			)

		callback(percentage)
	end

	bar.InputBegan:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1 then

				dragging = true

				update(input)

			end
		end
	)

	UserInputService.InputChanged:Connect(
		function(input)

			if dragging
				and input.UserInputType ==
				Enum.UserInputType.MouseMovement then

				update(input)

			end
		end
	)

	UserInputService.InputEnded:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1 then

				dragging = false

			end
		end
	)

	return bar
end

--------------------------------------------------
-- COR VISÍVEL
--------------------------------------------------

createLabel(
	"Cor quando VISÍVEL",
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
-- COR ATRÁS DE PAREDE
--------------------------------------------------

createLabel(
	"Cor atrás de PAREDE",
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
-- INTENSIDADE DO PREENCHIMENTO
--------------------------------------------------

local intensityLabel =
	createLabel(
		"Intensidade do preenchimento",
		230
	)

local intensityBar =
	Instance.new("Frame")

intensityBar.Size =
	UDim2.new(
		1,
		-40,
		0,
		18
	)

intensityBar.Position =
	UDim2.fromOffset(
		20,
		258
	)

intensityBar.BackgroundColor3 =
	Color3.fromRGB(
		55,
		55,
		65
	)

intensityBar.BorderSizePixel = 0

intensityBar.Parent = main

--------------------------------------------------
-- PREENCHIMENTO DA BARRA
--------------------------------------------------

local fill =
	Instance.new("Frame")

fill.Size =
	UDim2.new(
		config.FillIntensity,
		0,
		1,
		0
	)

fill.BackgroundColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

fill.BorderSizePixel = 0

fill.Parent = intensityBar

--------------------------------------------------
-- MARCADOR DA INTENSIDADE
--------------------------------------------------

local intensityMarker =
	Instance.new("Frame")

intensityMarker.Size =
	UDim2.fromOffset(
		3,
		26
	)

intensityMarker.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

intensityMarker.Position =
	UDim2.new(
		config.FillIntensity,
		0,
		0.5,
		0
	)

intensityMarker.BackgroundColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

intensityMarker.BorderSizePixel = 0

intensityMarker.Parent =
	intensityBar

local intensityDragging = false

local function updateIntensity(input)

	local relative =
		input.Position.X
		- intensityBar.AbsolutePosition.X

	local value =
		math.clamp(
			relative
				/ intensityBar.AbsoluteSize.X,
			0,
			1
		)

	config.FillIntensity =
		value

	fill.Size =
		UDim2.new(
			value,
			0,
			1,
			0
		)

	intensityMarker.Position =
		UDim2.new(
			value,
			0,
			0.5,
			0
		)

	intensityLabel.Text =
		"Intensidade do preenchimento: "
		.. math.floor(
			value * 100
		)
		.. "%"
end

intensityBar.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			intensityDragging = true

			updateIntensity(input)

		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if intensityDragging
			and input.UserInputType ==
			Enum.UserInputType.MouseMovement then

			updateIntensity(input)

		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			intensityDragging = false

		end
	end
)

intensityLabel.Text =
	"Intensidade do preenchimento: "
	.. math.floor(
		config.FillIntensity * 100
	)
	.. "%"

--------------------------------------------------
-- INFO AIMBOT
--------------------------------------------------

local aimbotInfo =
	createLabel(
		"Aimbot: cabeça | somente players visíveis",
		295
	)

aimbotInfo.TextColor3 =
	Color3.fromRGB(
		160,
		160,
		170
	)

--------------------------------------------------
-- TEXTO INSERT
--------------------------------------------------

local hint =
	Instance.new("TextLabel")

hint.Size =
	UDim2.new(
		1,
		-40,
		0,
		25
	)

hint.Position =
	UDim2.fromOffset(
		20,
		335
	)

hint.BackgroundTransparency = 1

hint.Text =
	"INSERT - Abrir / Fechar"

hint.TextColor3 =
	Color3.fromRGB(
		130,
		130,
		140
	)

hint.TextSize = 12

hint.Font =
	Enum.Font.Gotham

hint.Parent = main

--------------------------------------------------
-- MENU COMEÇA FECHADO
--------------------------------------------------

main.Visible = false

--------------------------------------------------
-- INSERT ABRE / FECHA
--------------------------------------------------

UserInputService.InputBegan:Connect(
	function(input, processed)

		if processed then
			return
		end

		if input.KeyCode ==
			Enum.KeyCode.Insert then

			main.Visible =
				not main.Visible

		end
	end
)

--------------------------------------------------
-- ARRASTAR JANELA
--------------------------------------------------

local draggingWindow = false
local dragStart
local startPosition

title.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			draggingWindow = true

			dragStart =
				input.Position

			startPosition =
				main.Position

		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if draggingWindow
			and input.UserInputType ==
			Enum.UserInputType.MouseMovement then

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
			Enum.UserInputType.MouseButton1 then

			draggingWindow = false

		end
	end
)

--------------------------------------------------
-- CRIAR ESP DOS PLAYERS EXISTENTES
--------------------------------------------------

for _, player in ipairs(
	Players:GetPlayers()
) do

	createHighlight(player)

end

--------------------------------------------------
-- NOVOS PLAYERS
--------------------------------------------------

Players.PlayerAdded:Connect(
	createHighlight
)

Players.PlayerRemoving:Connect(
	removeHighlight
)

--------------------------------------------------
-- ATUALIZAR AIMBOT
--------------------------------------------------

local function updateAimbot()

	if not config.AimbotEnabled then
		return
	end

	-- não mover a câmera enquanto mexe no menu
	if main.Visible then
		return
	end

	camera =
		workspace.CurrentCamera

	if not camera then
		return
	end

	local targetHead =
		getClosestAimbotTarget()

	if not targetHead then
		return
	end

	local cameraPosition =
		camera.CFrame.Position

	local targetCFrame =
		CFrame.lookAt(
			cameraPosition,
			targetHead.Position
		)

	--------------------------------------------------
	-- 0 = SNAP
	--------------------------------------------------

	if config.AimbotSmoothness <= 0 then

		camera.CFrame =
			targetCFrame

	else

		camera.CFrame =
			camera.CFrame:Lerp(
				targetCFrame,
				math.clamp(
					config.AimbotSmoothness,
					0,
					1
				)
			)

	end
end

--------------------------------------------------
-- LOOP PRINCIPAL
--------------------------------------------------

RunService.RenderStepped:Connect(
	function()

		camera =
			workspace.CurrentCamera

		--------------------------------------------------
		-- AIMBOT
		--------------------------------------------------

		updateAimbot()

		--------------------------------------------------
		-- ESP
		--------------------------------------------------

		for player, highlight
			in pairs(highlights)
		do

			if highlight
				and highlight.Parent
			then

				------------------------------------------
				-- ESP OFF
				------------------------------------------

				if not config.Enabled then

					highlight.Enabled =
						false

					continue

				end

				highlight.Enabled =
					true

				------------------------------------------
				-- INTENSIDADE
				------------------------------------------

				highlight.FillTransparency =
					1
					- config.FillIntensity

				highlight.OutlineTransparency =
					config.OutlineTransparency

				------------------------------------------
				-- COR
				------------------------------------------

				if isPlayerVisible(player) then

					local color =
						getVisibleColor()

					highlight.FillColor =
						color

					highlight.OutlineColor =
						color

				else

					local color =
						getHiddenColor()

					highlight.FillColor =
						color

					highlight.OutlineColor =
						color

				end
			end
		end
	end
)
