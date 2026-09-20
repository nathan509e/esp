local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local highlights = {}

local function createGlow(player)
	if player == localPlayer then
		return
	end

	local function apply(character)
		if highlights[player] then
			highlights[player]:Destroy()
			highlights[player] = nil
		end

		local highlight = Instance.new("Highlight")

		highlight.Name = "PlayerGlow"
		highlight.Adornee = character
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

		-- Quanto menor, mais sólido fica o interior.
		highlight.FillTransparency = 0.7

		-- 0 = contorno totalmente visível
		highlight.OutlineTransparency = 0

		-- Permite visualizar mesmo através de objetos.
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		highlight.Parent = character

		highlights[player] = highlight
	end

	if player.Character then
		apply(player.Character)
	end

	player.CharacterAdded:Connect(function(character)
		apply(character)
	end)
end

local function removeGlow(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	createGlow(player)
end

Players.PlayerAdded:Connect(createGlow)

Players.PlayerRemoving:Connect(removeGlow)
