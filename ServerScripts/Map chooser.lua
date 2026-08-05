--[[
    Description: Core map management loop. Loads and clones a random map from ReplicatedStorage via a ModuleScript,
    fires UI and teleport signals to clients, handles the map duration, and destroys the map after the disaster ends.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local MapService = require(ReplicatedStorage:WaitForChild("ModuleMapas"))
local PodeTeleportarParaMapa = ServerStorage:WaitForChild("PodeTeleportarParaMapa")
local DesastreFinalizado = ServerStorage:WaitForChild("DesastreFinalizado")
local PodeComecarDesastre = ServerStorage:WaitForChild("PodeComecarDesastre")
local MapaCriadoGui = ReplicatedStorage:WaitForChild("MapaCriadoGui")

local TEMPO_ENTRE_RODADAS = 10
local TEMPO_TELEPORTE = 15

while true do
	-- 1. Intervalo de descanso na Lobby entre rodadas
	task.wait(TEMPO_ENTRE_RODADAS)

	-- 2. Escolhe e carrega o mapa no Workspace
	local mapaAtual, posicaoSpawn = MapService.EscolherMapa()

	if mapaAtual then
		print("Mapa criado com sucesso!")
		
		-- Avisa as interfaces dos jogadores que o mapa está pronto
		MapaCriadoGui:FireAllClients()

		-- Libera o teleporte e avisa o script de desastres para começar a contagem
		PodeTeleportarParaMapa:Fire(true)
		PodeComecarDesastre:Fire(true)

		-- Tempo para os jogadores entrarem no teleporte/mapa
		task.wait(TEMPO_TELEPORTE)
		PodeTeleportarParaMapa:Fire(false)

		-- 3. SINCRONIA PERFEITA: Em vez de usar task.wait(50), espera o evento de fim de desastre disparar!
		DesastreFinalizado.Event:Wait()

		-- 4. Limpeza do mapa após o término do desastre
		if mapaAtual and mapaAtual.Parent then
			mapaAtual:Destroy()
			mapaAtual = nil
			print("Mapa antigo destruído com sucesso!")
		end
	else
		warn("FALHA: O módulo MapService não conseguiu criar um mapa!")
	end
end
