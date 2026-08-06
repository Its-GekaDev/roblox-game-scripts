--[[
    Description: Server-side Script that validates and processes item purchases.
    Verifies item catalog metadata, validates player currency in leaderstats, 
    prevents duplicate inventory/character ownership, safely deducts currency, 
    and awards item tools from ServerStorage.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Referências de Comunicação e Armazenamento
local remoteComprar = ReplicatedStorage:WaitForChild("ComprarItemEvent")
local itensLoja = ServerStorage:WaitForChild("ItensLoja")

-- Fonte Única da Verdade (O mesmo módulo lido pelo Cliente)
local ConfigItem = require(ReplicatedStorage:WaitForChild("ConfigItem"))

local function processarCompra(player, itemName)
	-- 1. Obtém os dados do item diretamente do ModuleScript central
	local dadosItem = ConfigItem.PegarItem and ConfigItem.PegarItem(itemName) or ConfigItem[itemName]

	if not dadosItem then 
		warn("[LOJA SERVIDOR] Item não cadastrado nas configurações: " .. tostring(itemName))
		return 
	end

	-- 2. Valida a existência do leaderstats e da moeda do jogador
	local leaderstats = player:FindFirstChild("leaderstats")
	local dinheiro = leaderstats and leaderstats:FindFirstChild("Dinheiro")

	if not dinheiro then
		warn("[LOJA SERVIDOR] Leaderstats ou Dinheiro ausente para o jogador: " .. player.Name)
		return 
	end

	-- 3. Valida se o jogador tem saldo suficiente
	if dinheiro.Value < dadosItem.Preco then
		print("[LOJA] Saldo insuficiente para " .. player.Name .. " ao tentar comprar " .. itemName)
		return
	end

	-- 4. Valida se o modelo original do item existe no ServerStorage
	local modeloNome = dadosItem.ModeloName or itemName
	local itemOriginal = itensLoja:FindFirstChild(modeloNome)
	if not itemOriginal then
		warn("[LOJA SERVIDOR] O item '" .. tostring(modeloNome) .. "' não existe em ServerStorage.ItensLoja!")
		return
	end

	-- 5. Garante que a Backpack e o Character do jogador estão ativos (Evita erro ao morrer)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local character = player.Character

	if not backpack then
		warn("[LOJA SERVIDOR] Backpack indisponível no momento para " .. player.Name)
		return
	end

	-- 6. Valida se o jogador JÁ possui o item na mochila ou equipado
	local jaPossuiNaMochila = backpack:FindFirstChild(modeloNome)
	local jaPossuiEquipado = character and character:FindFirstChild(modeloNome)

	if jaPossuiNaMochila or jaPossuiEquipado then
		print("[LOJA] O jogador " .. player.Name .. " já possui o item: " .. modeloNome)
		return
	end

	-- 7. TRANSAÇÃO SEGURA: Transfere o item e só depois desconta o dinheiro
	local novoItem = itemOriginal:Clone()
	novoItem.Parent = backpack

	dinheiro.Value -= dadosItem.Preco
	print("[LOJA SUCESSO] " .. player.Name .. " comprou " .. modeloNome .. " por $" .. dadosItem.Preco)
end

-- Conexão do Evento do Servidor
remoteComprar.OnServerEvent:Connect(processarCompra)
