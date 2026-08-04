--Description: When this script receives a RemoteEvent from ReplicatedStorage, it gives three items (Boombox, Sign, and Apple) to the player. The event fires when a player who owns the Gamepass toggles the item activation button in the GUI.
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local GamePassID = 1918191848 -- Altere para o ID do seu Game Pass

-- Função isolada para aplicar os poderes no personagem
local function darPoderes(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.WalkSpeed = 48
	end
end

-- Função para checar se o jogador tem o passe (com pcall de segurança)
local function checarGamePass(player)
	local success, hasGamePass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GamePassID)
	end)
	return success and hasGamePass
end

-- Evento 1: Quando o jogador entra e o personagem nasce
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if checarGamePass(player) then
			darPoderes(character)
		end
	end)
end)

-- Evento 2: Quando o jogador compra o Game Pass DENTRO do jogo
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, purchasedPassId, purchaseSuccess)
	-- Verifica se a compra foi concluída com sucesso e se é o Game Pass correto
	if purchaseSuccess and purchasedPassId == GamePassID then
		if player.Character then
			darPoderes(player.Character)
		end
	end
end)
