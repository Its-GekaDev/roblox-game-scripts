--[[
    Description: Checks if a player owns the Jump Power Gamepass via MarketplaceService.
    Forces UseJumpPower to true and applies the jump boost upon character spawning or instantly upon in-game purchase.
--]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local GAMEPASS_ID = 1918695838 
local FORCA_PULO = 80

-- Função interna para aplicar o super pulo no personagem
local function aplicarPulo(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if humanoid then
		humanoid.UseJumpPower = true 
		humanoid.JumpPower = FORCA_PULO
	end
end

-- Função que verifica se o jogador tem o passe ao nascer
local function verificarEIntervir(player, character)
	local success, hasPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)

	if success and hasPass then
		aplicarPulo(character)
	end
end

-- 1. MONITORAMENTO AO ENTRAR/RENASCER
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		verificarEIntervir(player, character)
	end)
	
	-- Garante a checagem caso o personagem tenha carregado antes da conexão
	if player.Character then
		verificarEIntervir(player, player.Character)
	end
end)

-- 2. COMPRA EM TEMPO REAL
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if purchased and passId == GAMEPASS_ID then
		if player.Character then
			aplicarPulo(player.Character)
			print(player.Name .. " comprou a gamepass de Super Pulo e o recebeu imediatamente!")
		end
	end
end)
