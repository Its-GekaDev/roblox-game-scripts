--[[
    Description: LocalScript attached to a Dev/GamePass Turbo toggle button.
    Toggles character movement properties (WalkSpeed and JumpHeight) with visual button feedback.
    Includes state restoration on character respawn.
--]]

local Players = game:GetService("Players")

local button = script.Parent
local player = Players.LocalPlayer

-- Configurações de movimento
local VELOCIDADE_PADRAO = 16 -- Padrão nativo do Roblox (Ajuste se o seu jogo usar 25)
local PULO_PADRAO = 50

local VELOCIDADE_TURBO = 50
local PULO_TURBO = 80

-- Controle de estado
local ativado = false

-- Aplica a interface visual e os atributos no Humanoid atual
local function aplicarEstado(humanoid)
	if ativado then
		humanoid.WalkSpeed = VELOCIDADE_TURBO
		humanoid.JumpHeight = PULO_TURBO
		button.Text = "Turbo: LIGADO"
		button.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
	else
		humanoid.WalkSpeed = VELOCIDADE_PADRAO
		humanoid.JumpHeight = PULO_PADRAO
		button.Text = "Turbo: DESLIGADO"
		button.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
	end
end

local function alternarTurbo()
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	ativado = not ativado
	aplicarEstado(humanoid)
end

-- Reseta o estado quando o jogador renasce
player.CharacterAdded:Connect(function(newCharacter)
	ativado = false
	local humanoid = newCharacter:WaitForChild("Humanoid")
	aplicarEstado(humanoid)
end)

-- Conexão universal de entrada (PC, Mobile, Console)
button.Activated:Connect(alternarTurbo)
