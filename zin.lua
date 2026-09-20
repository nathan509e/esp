local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local highlights = {}

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

		highlight.FillTransparency = 0.65
		highlight.OutlineTransparency = 0

		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = character

		highlights[player] = highlight
	end

	if player.Character then
		apply(player.Character)
	end

	player.CharacterAdded:Connect(apply)
end

local function removeHighlight(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

local function isPlayerVisible(player)
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

	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local ignoreList = {}

	if localPlayer.Character then
		table.insert(ignoreList, localPlayer.Character)
	end

	params.FilterDescendantsInstances = ignoreList
	params.IgnoreWater = true

	local result = workspace:Raycast(
		origin,
		direction,
		params
	)

	-- Não bateu em nada antes do alvo
	if not result then
		return true
	end

	-- O primeiro objeto atingido pertence ao personagem alvo
	if result.Instance:IsDescendantOf(character) then
		return true
	end

	-- Existe alguma coisa bloqueando
	return false
end

for _, player in ipairs(Players:GetPlayers()) do
	createHighlight(player)
end

Players.PlayerAdded:Connect(createHighlight)
Players.PlayerRemoving:Connect(removeHighlight)

RunService.RenderStepped:Connect(function()
	camera = workspace.CurrentCamera

	for player, highlight in pairs(highlights) do
		if player.Character and highlight.Parent then
			if isPlayerVisible(player) then
				-- VISÍVEL = VERDE
				highlight.FillColor = Color3.fromRGB(0, 255, 0)
				highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
			else
				-- ATRÁS DE PAREDE = VERMELHO
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
			end
		end
	end
end)
