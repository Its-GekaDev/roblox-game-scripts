--[[
    Description: LocalScript attached to a teleport confirmation modal button ("Sim").
    Validates player health, safely fetches the target destination CFrame, 
    teleports the character model using PivotTo, and handles UI visibility with cooldown protection.
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local confirmButton = script.Parent
local mainInterface = confirmButton.Parent

local localPlayer = Players.LocalPlayer
local isCooldown = false

-- Função para localizar o destino com segurança no Workspace
local function obterDestinoTeleporte()
	local torre = Workspace:FindFirstChild("Torre")
	if not torre then return nil end

	local principal = torre:FindFirstChild("TeleporteMapaPrincipal")
	if not principal then return nil end

	return principal:FindFirstChild("TeleporteMapa")
end

local function realizarTeleporte()
	if isCooldown then return end

	local character = localPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	-- Valida se o personagem está ativo e vivo
	if humanoid and humanoid.Health > 0 and rootPart then
		local destino = obterDestinoTeleporte()

		if not destino then
			warn("[TELEPORTE] Ponto de destino não encontrado no Workspace no momento!")
			return
		end

		isCooldown = true

		-- Oculta a interface imediatamente ao confirmar
		mainInterface.Visible = false

		-- Teleporta o modelo do personagem com segurança
		local destinoCFrame = destino.CFrame + Vector3.new(0, 5, 0)
		character:PivotTo(destinoCFrame)

		task.wait(1)
		isCooldown = false
	end
end

-- Usa Activated para suporte universal (PC, Mobile, Console)
confirmButton.Activated:Connect(realizarTeleporte)
