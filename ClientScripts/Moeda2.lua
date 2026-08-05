--[[
    Description: Client-side coin pickup handler using CollectionService tags. 
    Provides instant visual feedback by hiding the coin and disabling visual effects locally upon touch, 
    then fires a RemoteEvent to the server to safely grant the reward.
--]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local EventoColetarMoeda = ReplicatedStorage:WaitForChild("EventoColetarMoeda")

-- Tabela local para guardar quais moedas ESTE jogador já pegou
local moedasColetadas = {}

local function registrarMoedaLocal(moeda)
	if not moeda:IsA("BasePart") then return end

	moeda.Touched:Connect(function(hit)
		-- Verifica se quem tocou na moeda foi o personagem deste jogador local
		local character = LocalPlayer.Character
		if not character or not hit:IsDescendantOf(character) then return end

		-- Se o jogador local já pegou essa moeda, ignora
		if moedasColetadas[moeda] then return end

		-- Marca como coletada localmente
		moedasColetadas[moeda] = true

		-- ESCONDE A MOEDA APENAS PARA ESTE JOGADOR
		moeda.Transparency = 1
		moeda.CanCollide = false

		-- Se a moeda tiver efeitos visuais ou GUI/Luz dentro, esconde também
		for _, filho in moeda:GetChildren() do
			if filho:IsA("ParticleEmitter") or filho:IsA("Light") or filho:IsA("BillboardGui") then
				filho.Enabled = false
			end
		end

		-- Avisa o servidor para creditar os +5 no leaderstats
		EventoColetarMoeda:FireServer(moeda)
	end)
end

-- Registra moedas com a Tag "Moeda"
for _, moeda in CollectionService:GetTagged("Moeda") do
	task.spawn(registrarMoedaLocal, moeda)
end

CollectionService:GetInstanceAddedSignal("Moeda"):Connect(registrarMoedaLocal)
