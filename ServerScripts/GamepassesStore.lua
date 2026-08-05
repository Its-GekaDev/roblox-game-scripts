--[[
    Description: Main gamepass reward manager. Map gamepass IDs to ServerStorage tools via a dictionary table.
    Caches ownership checks on player join to save API requests and automatically grants corresponding items 
    to the player's Backpack upon spawning or instantly after an in-game purchase.
--]]
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- A pasta agora está protegida no servidor
local PastaItens = ServerStorage:WaitForChild("ItensGamepass")

-- Dicionário das Gamepasses: [ID_DA_GAMEPASS] = "NomeDoItemNaPasta"
-- Isso evita que você tenha que escrever dezenas de "if/else".
local Gamepasses = {
	[1918989086] = "EquipamentoDeMergulho",
	[1919265379] = "Apple",
	[1917771825] = "Placa",
	[1918167876] = "Lemonade",
	[1917603947] = "Glider",
	[1919631815] = "Jetpack"
	 -- Adicione os outros IDs e itens aqui
}

-- Função central para dar o item e evitar falhas
local function darItem(player, nomeDoItem)
	local itemOriginal = PastaItens:FindFirstChild(nomeDoItem)

	if not itemOriginal then
		warn("FALHA: O item '" .. nomeDoItem .. "' não foi encontrado na pasta ItensGamepass no ServerStorage!")
		return
	end

	-- Trava de segurança: Verifica se o jogador já tem o item na mochila ou equipado na mão
	local naMochila = player.Backpack:FindFirstChild(nomeDoItem)
	local naMao = player.Character and player.Character:FindFirstChild(nomeDoItem)

	if naMochila or naMao then
		return -- Interrompe se ele já tiver o item para não duplicar
	end

	-- Clona e entrega
	local clone = itemOriginal:Clone()
	clone.Parent = player.Backpack
end

-- 1. Verifica quem já tem o passe ao entrar na partida
Players.PlayerAdded:Connect(function(player)
	-- Usamos CharacterAdded para garantir que o jogador receba o item toda vez que renascer
	player.CharacterAdded:Connect(function(character)

		-- Varre a tabela de Gamepasses para ver quais o jogador possui
		for passId, nomeDoItem in pairs(Gamepasses) do
			-- pcall impede que o script quebre se os servidores do Roblox estiverem lentos
			local sucesso, possui = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
			end)

			if sucesso and possui then
				darItem(player, nomeDoItem)
			end
		end

	end)
end)

-- 2. Monitora se alguém comprar um passe DURANTE a partida
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, compraAprovada)
	if compraAprovada then
		-- Verifica se o ID comprado está na nossa lista de Gamepasses
		local nomeDoItem = Gamepasses[passId]
		if nomeDoItem then
			darItem(player, nomeDoItem)
			print(player.Name .. " comprou a gamepass e recebeu " .. nomeDoItem)
		end
	end
end)
