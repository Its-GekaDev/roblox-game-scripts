--[[
    Description: Handles coin collection triggered by a client RemoteEvent. 
    Includes distance verification (anti-exploit) using Magnitude, adds currency 
    to the player's 'Money' leaderstats, and safely destroys the collected coin on the server.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventoColetarMoeda = ReplicatedStorage:WaitForChild("EventoColetarMoeda")

local VALOR_MOEDA = 5

EventoColetarMoeda.OnServerEvent:Connect(function(player, moeda)
	-- 1. Valida se a moeda ainda existe no workspace e se é uma BasePart
	if not moeda or not moeda:IsA("BasePart") or not moeda:IsDescendantOf(workspace) then 
		return 
	end

	-- 2. Anti-Exploit: Garante que o jogador está perto da moeda
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local distancia = (character.HumanoidRootPart.Position - moeda.Position).Magnitude
		if distancia > 15 then 
			return -- Muito longe? Ignora e impede o cheat.
		end
	else
		return
	end

	-- 3. TRAVA CRÍTICA: Destrói a moeda IMEDIATAMENTE para impedir duplo recebimento
	moeda:Destroy()

	-- 4. Dá o dinheiro de forma segura no Leaderstats ('Money')
	local leaderstats = player:FindFirstChild("leaderstats")
	local money = leaderstats and leaderstats:FindFirstChild("Money")

	if money then
		money.Value += VALOR_MOEDA
	end
end)
