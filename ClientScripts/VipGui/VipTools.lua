--[[
    Description: LocalScript attached to an item toggle button (e.g., Dev/Admin tools).
    Fires a RemoteEvent with the target state to request items from the server, 
    updates button UI state, and handles state resets on character respawn.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local button = script.Parent
local player = Players.LocalPlayer
local remoteEvent = ReplicatedStorage:WaitForChild("DarItensEvent")

local ativado = false
local emCooldown = false

local function atualizarInterface()
	if ativado then
		button.Text = "Itens: LIGADO"
		button.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
	else
		button.Text = "Itens: DESLIGADO"
		button.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
	end
end

local function alternarItens()
	if emCooldown then return end
	emCooldown = true

	ativado = not ativado

	-- Envia o estado explicitamente (true = Entregar, false = Remover)
	remoteEvent:FireServer(ativado)

	atualizarInterface()

	task.wait(0.5) -- Cooldown curto para evitar spam no servidor
	emCooldown = false
end

-- Reseta o estado quando o jogador morre/renasce
player.CharacterAdded:Connect(function()
	ativado = false
	atualizarInterface()
end)

-- Conexão universal (PC, Mobile, Console)
button.Activated:Connect(alternarItens)
