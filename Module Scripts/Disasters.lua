--[[
    Description: Shared ModuleScript that handles disaster management and VIP priority queues.
    Processes player-purchased disaster requests, manages queuing with memory cleanup on player disconnect,
    broadcasts disaster alerts via RemoteEvent, and handles random fallback selections.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local DesastresService = {}

-- Gerador de aleatoriedade moderno
local rng = Random.new()

------------------------------------------------
-- CONFIGURAÇÃO DOS DESASTRES
------------------------------------------------
local Desastres = {
	{
		Nome = "Meteors",
		NomeModelo = "Meteoros",
		SpawnPosicao = CFrame.new(-27.019, 14084.276, 452.891),
	},
	{
		Nome = "Tsunami",
		NomeModelo = "Tsunami",
		SpawnPosicao = CFrame.lookAt(
			Vector3.new(-9.519, 13818.13, 1400.891),
			Vector3.new(-35, 13836.275, 443)
		) * CFrame.Angles(0, math.rad(180), 0),
	},
	{
		Nome = "Killers",
		NomeModelo = "AssasinosSpawn",
		SpawnPosicao = CFrame.new(-41.384, 13974.376, 421.686),
	},
	{
		Nome = "Zombies",
		NomeModelo = "SpawnZumbies",
		SpawnPosicao = CFrame.new(-23.519, 14076.276, 442.891),
	},
	{
		Nome = "Rain",
		NomeModelo = "ChuvaHitBox",
		SpawnPosicao = CFrame.new(-32.953, 14140.109, 457.569),
	},
	{
		Nome = "Fire",
		NomeModelo = "LocalDasChamas",
		SpawnPosicao = CFrame.new(-29, 13976.776, 452),
	},
	{
		Nome = "Tornado",
		NomeModelo = "Tornado",
		SpawnPosicao = CFrame.new(976.801, 13883.04, 461.479),
	},
}

------------------------------------------------
-- TAREFAS / FILAS
------------------------------------------------
DesastresService.FilaDesastres = {}
DesastresService.PodeEscolher = {}

------------------------------------------------
-- SERVIÇOS E RECURSOS DO ROBLOX
------------------------------------------------
local PastaDesastres = ReplicatedStorage:WaitForChild("Desastres", 10)
local AvisoDesastre = ReplicatedStorage:WaitForChild("AvisoDesastre", 10)

------------------------------------------------
-- LIMPEZA AUTOMÁTICA DE MEMÓRIA (PLAYER SAINDO)
------------------------------------------------
Players.PlayerRemoving:Connect(function(playerLeaving)
	-- Clean up permissions
	DesastresService.PodeEscolher[playerLeaving.UserId] = nil

	-- Clean up pending requests in queue
	for i = #DesastresService.FilaDesastres, 1, -1 do
		if DesastresService.FilaDesastres[i].Player == playerLeaving then
			table.remove(DesastresService.FilaDesastres, i)
		end
	end
end)

------------------------------------------------
-- DAR PERMISSÃO DE ESCOLHA
------------------------------------------------
function DesastresService.LiberarEscolha(player)
	if not player then return end
	DesastresService.PodeEscolher[player.UserId] = true
	print("[DESASTRES] Compra liberada para:", player.Name)
end

------------------------------------------------
-- ADICIONAR NA FILA
------------------------------------------------
function DesastresService.AdicionarFila(player, nome)
	if not player then return false end

	if not DesastresService.PodeEscolher[player.UserId] then
		warn("[DESASTRES] " .. player.Name .. " tentou escolher sem permissão/compra válida.")
		return false
	end

	local desastreEscolhido = nil
	for _, desastre in ipairs(Desastres) do
		if desastre.Nome == nome then
			desastreEscolhido = desastre
			break
		end
	end

	if not desastreEscolhido then
		warn("[DESASTRES] Desastre inexistente:", tostring(nome))
		return false
	end

	for _, dados in ipairs(DesastresService.FilaDesastres) do
		if dados.Player == player and dados.Desastre.Nome == nome then
			warn("[DESASTRES] " .. player.Name .. " já colocou '" .. nome .. "' na fila.")
			return false
		end
	end

	table.insert(DesastresService.FilaDesastres, {
		Player = player,
		Desastre = desastreEscolhido,
	})

	DesastresService.PodeEscolher[player.UserId] = nil
	print("[DESASTRES] " .. player.Name .. " entrou na fila com: " .. nome)

	return true
end

------------------------------------------------
-- PEGAR PRÓXIMO DESASTRE
------------------------------------------------
function DesastresService.EscolherDesastre()
	local desastreEscolhido

	-- 1. Prioriza os desastres da fila VIP
	if #DesastresService.FilaDesastres > 0 then
		local dados = table.remove(DesastresService.FilaDesastres, 1)
		desastreEscolhido = dados.Desastre
		print("[DESASTRES] Selecionado da FILA:", dados.Player.Name, "->", desastreEscolhido.Nome)
	else
		-- 2. Sorteio aleatório se a fila estiver vazia
		if #Desastres == 0 then
			warn("[DESASTRES] ERRO CRÍTICO: Tabela 'Desastres' está vazia!")
			return nil
		end

		local indiceAleatorio = rng:NextInteger(1, #Desastres)
		desastreEscolhido = Desastres[indiceAleatorio]
		print("[DESASTRES] Selecionado ALEATORIAMENTE:", desastreEscolhido.Nome)
	end

	-- 3. Validação do Modelo no ReplicatedStorage
	if not PastaDesastres then
		warn("[DESASTRES] Pasta ReplicatedStorage.Desastres não encontrada!")
		return nil
	end

	local modelo = PastaDesastres:WaitForChild(desastreEscolhido.NomeModelo, 5)
	if not modelo then
		warn("[DESASTRES] Modelo '" .. tostring(desastreEscolhido.NomeModelo) .. "' não encontrado!")
		return nil
	end

	-- 4. Notifica todos os clientes
	if AvisoDesastre then
		AvisoDesastre:FireAllClients(desastreEscolhido)
	end

	-- 5. Clona e posiciona o modelo no Workspace
	local clone = modelo:Clone()
	clone:PivotTo(desastreEscolhido.SpawnPosicao)
	clone.Parent = Workspace

	return clone
end

return DesastresService
