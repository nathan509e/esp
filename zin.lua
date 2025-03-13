local players = game:GetService("Players")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

-- Criar uma tabela para armazenar os ESPs
local espBoxes = {}

-- Função para criar um ESP para um jogador
local function createESP(player)
    if player == localPlayer then return end -- Ignorar o próprio jogador

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 0)  -- Vermelho
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    espBoxes[player] = box
end

-- Criar ESP para todos os jogadores
for _, player in pairs(players:GetPlayers()) do
    createESP(player)
end

-- Atualizar ESP em tempo real
game:GetService("RunService").RenderStepped:Connect(function()
    for player, box in pairs(espBoxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                box.Size = Vector2.new(50, 100)  -- Ajuste o tamanho da caixa
                box.Position = Vector2.new(screenPosition.X - 25, screenPosition.Y - 50)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)

-- Atualizar quando um jogador entra no jogo
players.PlayerAdded:Connect(createESP)
