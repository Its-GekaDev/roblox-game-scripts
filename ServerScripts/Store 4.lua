--[[
    Description: Handles in-game item purchases triggered by RemoteEvents. 
    Validates item pricing against player leaderstats ('Money'), checks inventory to prevent duplicates, 
    deducts currency on the server, and clones the item tool from ServerStorage to the player's Backpack.
    this script is the 4th store script
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Remote = ReplicatedStorage:WaitForChild("ComprarItemEvent")
local itensLoja = ServerStorage:WaitForChild("ItensLoja")

-- Usamos as chaves com os mesmos nomes enviados pelo Remote para facilitar a busca
local catalogo = {
	Item1 = { Preco = 150, ModeloName = "Apple" },
	Item2 = { Preco = 1000, ModeloName = "EquipamentoDeMergulho" },
	Item3 = { Preco = 500, ModeloName = "Jetpack" },
	Item4 = { Preco = 50, ModeloName = "Placa" }
}

Remote.OnServerEvent:Connect(function(player, itemName)
	local dadosItem = catalogo[itemName]

	-- 1. Valida se o item existe no catálogo
	if not dadosItem then 
		warn("Item não encontrado no catálogo: " .. tostring(itemName))
		return 
	end

	-- 2. Valida se o jogador tem o líderstats/dinheiro
	local leaderstats = player:FindFirstChild("leaderstats")
	local dinheiro = leaderstats and leaderstats:FindFirstChild("Dinheiro")

	if not dinheiro then return end

	if dinheiro.Value < dadosItem.Preco then
		print("Você não tem dinheiro suficiente para comprar " .. itemName .. ", caro jogador " .. player.Name)
		return
	end

	-- 3. Valida se o item existe no ServerStorage
	local itemOriginal = itensLoja:FindFirstChild(dadosItem.ModeloName)
	if not itemOriginal then
		warn("O item " .. dadosItem.ModeloName .. " não existe no ServerStorage.ItensLoja!")
		return
	end

	-- 4. Valida se o jogador JÁ possui o item (na Backpack ou equipado no Character)
	local jaPossuiNaMochila = player.Backpack:FindFirstChild(dadosItem.ModeloName)
	local jaPossuiEquipado = player.Character and player.Character:FindFirstChild(dadosItem.ModeloName)

	if jaPossuiNaMochila or jaPossuiEquipado then
		print("O jogador " .. player.Name .. " já tem o item " .. dadosItem.ModeloName)
		return
	end

	-- 5. Processa a compra (Desconta dinheiro e Entrega o item)
	dinheiro.Value -= dadosItem.Preco

	local novoItem = itemOriginal:Clone()
	novoItem.Parent = player.Backpack

	print("Compra de " .. dadosItem.ModeloName .. " feita com sucesso por " .. player.Name)
end)

--Esse script serve para pegar o nome do item, e o preço dele, e o item dele também.
--Ele reconhece o RemoteEvent Disparado do localScript faz a verificação se o jogador tem dinheiro para comprar
--e se ele tiver ele recebe o dinheiro e o item
--e Diminui a grana do jogador pelo leaderstats
