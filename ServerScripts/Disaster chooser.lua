--[[
    Description: Core disaster manager loop triggered via ServerStorage BindableEvents. 
    Requires a ReplicatedStorage ModuleScript to select, spawn, and clean up environmental 
    disasters on a fixed timer before notifying the game flow that the round has ended.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local DesastresService = require(ReplicatedStorage:WaitForChild("ModuleDesastres"))
local PodeComecarDesastre = ServerStorage:WaitForChild("PodeComecarDesastre")
local DesastreFinalizado = ServerStorage:WaitForChild("DesastreFinalizado")

-- Trava de segurança para impedir desastres empilhados
local desastreEmAndamento = false

PodeComecarDesastre.Event:Connect(function(mensagem)
	if mensagem and not desastreEmAndamento then
		desastreEmAndamento = true
		print("Iniciando contagem regressiva para o desastre...")

		-- Tempo de preparação para os jogadores se posicionarem
		task.wait(15)

		-- Chama o módulo para escolher e spawnar o desastre
		local modeloClonado = DesastresService.EscolherDesastre()

		if modeloClonado then
			print("Desastre ativo no mapa!")
			
			-- Tempo de duração do desastre
			task.wait(50)

			-- Limpeza do mapa
			if modeloClonado and modeloClonado.Parent then
				modeloClonado:Destroy()
			end

			print("Desastre encerrado e removido do jogo.")
		else
			warn("FALHA: O módulo DesastresService não retornou um modelo válido!")
		end

		-- Notifica o sistema principal que a rodada acabou
		DesastreFinalizado:Fire(true)
		desastreEmAndamento = false
	end
end)
