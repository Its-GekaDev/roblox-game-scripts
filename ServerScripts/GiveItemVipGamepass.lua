--Description: When this script receives a RemoteEvent from ReplicatedStorage, it gives three items (Boombox, Sign, and Apple) to the player. The event fires when a player who owns the Gamepass toggles the item activation button in the GUI.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local remoteEvent = ReplicatedStorage:WaitForChild("DarItensEvent")
local pastaItens = ServerStorage:WaitForChild("ItensGamepass")

-- Lista com os nomes exatos dos itens
local nomesDosItens = {"Apple", "BoomBox", "Placa"}

-- Tabela para guardar o estado (ativado/desativado) de cada jogador
local jogadoresComItens = {}

remoteEvent.OnServerEvent:Connect(function(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	local character = player.Character

	if not backpack then return end

	-- Inverte o estado do jogador
	jogadoresComItens[player] = not jogadoresComItens[player]
	local ativado = jogadoresComItens[player]

	if ativado then
		-- ENTREGA OS ITENS
		for _, nomeItem in ipairs(nomesDosItens) do
			local itemOriginal = pastaItens:FindFirstChild(nomeItem)
			if itemOriginal then
				-- Clona o item para o jogador
				local itemClonado = itemOriginal:Clone()
				itemClonado.Parent = backpack
			else
				warn("Item não encontrado no ServerStorage: " .. nomeItem)
			end
		end
	else
		-- REMOVE OS ITENS (da Mochila e da Mão se estiver equipado)
		for _, nomeItem in ipairs(nomesDosItens) do
			-- Procura na mochila
			local itemMochila = backpack:FindFirstChild(nomeItem)
			if itemMochila then
				itemMochila:Destroy()
			end

			-- Procura na mão do personagem
			if character then
				local itemMao = character:FindFirstChild(nomeItem)
				if itemMao then
					itemMao:Destroy()
				end
			end
		end
	end
end)

-- Limpa a memória quando o jogador sai do jogo
game.Players.PlayerRemoving:Connect(function(player)
	jogadoresComItens[player] = nil
end)
