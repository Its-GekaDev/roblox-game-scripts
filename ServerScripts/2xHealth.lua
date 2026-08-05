--[[
    Description: Checks if a player owns the Health Gamepass using MarketplaceService. 
    If owned, increases their MaxHealth and Health to 200 upon spawning or instantly when purchased in-game.
--]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- SUBST_AQUI: Troque o número 0 pelo ID real da sua Gamepass
local GAMEPASS_ID = 1919205755
local MAX_HEALTH_BONUS = 200

-- Função interna para aplicar os 200 de vida no personagem
local function applyHealth(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.MaxHealth = MAX_HEALTH_BONUS
		humanoid.Health = MAX_HEALTH_BONUS
	end
end

-- Função que verifica se o jogador tem o passe ao nascer
local function checkAndApplyHealth(player, character)
	local success, hasPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)

	if success and hasPass then
		applyHealth(character)
	end
end

-- 1. MONITORAMENTO AO ENTRAR/RENASCER
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		checkAndApplyHealth(player, character)
	end)
end)

-- 2. COMPRA EM TEMPO REAL (Se ele comprar pelo botão da GUI)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	-- Se a compra foi um sucesso e foi a gamepass da vida
	if purchased and passId == GAMEPASS_ID then
		if player.Character then
			applyHealth(player.Character)
			print(player.Name .. " comprou a gamepass e recebeu 200 de vida imediatamente!")
		end
	end
end)
