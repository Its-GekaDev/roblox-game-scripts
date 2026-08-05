--[[
    Description: [Deprecated / Unused] Dynamic weather and lighting manager for a rain disaster event. 
    Darkens environment settings, generates random thunder/lightning effects using Lighting and Atmosphere, 
    and distributes flashlights to all active players. Automatically restores default lighting and strips 
    flashlights upon disaster completion.
--]]

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local PlayersService = game:GetService("Players")

local ChuvaAviso = ReplicatedStorage:WaitForChild("ChuvaStart")
local DesastreFinalizado = ServerStorage:WaitForChild("DesastreFinalizado")
local Lanterna = ReplicatedStorage:WaitForChild("Flashlight")

local tempestadeAtiva = false 

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if not atmosphere then
	atmosphere = Instance.new("Atmosphere")
	atmosphere.Parent = Lighting
end

-- =========================================================
-- FUNÇÃO 1: ATIVAR A TEMPESTADE
-- =========================================================
local function iniciarTempestade()
	if tempestadeAtiva then return end 
	tempestadeAtiva = true

	-- Iluminação Escura
	Lighting.ClockTime = 14
	Lighting.Brightness = 0.15
	Lighting.OutdoorAmbient = Color3.fromRGB(30, 35, 45)
	Lighting.Ambient = Color3.fromRGB(25, 25, 30)
	Lighting.ShadowSoftness = 1
	Lighting.GlobalShadows = true

	-- Neblina
	Lighting.FogColor = Color3.fromRGB(20, 23, 28)
	Lighting.FogStart = 10
	Lighting.FogEnd = 180

	-- Atmosfera densa
	atmosphere.Density = 0.8
	atmosphere.Color = Color3.fromRGB(25, 28, 35)
	atmosphere.Decay = Color3.fromRGB(15, 15, 20)
	atmosphere.Haze = 3

	-- Loop de relâmpagos
	task.spawn(function()
		while tempestadeAtiva do
			task.wait(math.random(8, 22))

			if not tempestadeAtiva then break end

			local originalAmbient = Lighting.OutdoorAmbient
			local originalBrightness = Lighting.Brightness

			-- Clarão 1
			Lighting.Brightness = 6
			Lighting.OutdoorAmbient = Color3.fromRGB(240, 245, 255)
			task.wait(0.08)

			Lighting.Brightness = originalBrightness
			Lighting.OutdoorAmbient = originalAmbient
			task.wait(0.05)

			if not tempestadeAtiva then break end

			-- Clarão 2
			Lighting.Brightness = 3.5
			Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 230)
			task.wait(0.12)

			Lighting.Brightness = originalBrightness
			Lighting.OutdoorAmbient = originalAmbient
		end
	end)
end

-- =========================================================
-- FUNÇÃO 2: PARAR A TEMPESTADE
-- =========================================================
local function pararTempestade()
	tempestadeAtiva = false 

	Lighting.ClockTime = 14.5
	Lighting.Brightness = 2 
	Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70) 
	Lighting.Ambient = Color3.fromRGB(180, 180, 180) 
	Lighting.ShadowSoftness = 0.2
	Lighting.GlobalShadows = true

	Lighting.FogStart = 0
	Lighting.FogEnd = 100000 

	atmosphere.Density = 0.25 
	atmosphere.Haze = 0
	atmosphere.Color = Color3.fromRGB(199, 199, 199)
	atmosphere.Decay = Color3.fromRGB(104, 112, 124)
end

-- =========================================================
-- CONEXÕES DOS EVENTOS
-- =========================================================

-- Supondo que ChuvaAviso seja uma BoolValue no ReplicatedStorage
ChuvaAviso.Changed:Connect(function(novoValor)
	if novoValor == true then
		iniciarTempestade()

		for _, jogador in ipairs(PlayersService:GetPlayers()) do
			local backpack = jogador:FindFirstChild("Backpack")
			local personagem = jogador.Character

			if backpack then
				local temNaMochila = backpack:FindFirstChild("Flashlight")
				local temNaMao = personagem and personagem:FindFirstChild("Flashlight")

				if not temNaMochila and not temNaMao then
					local lanternaNova = Lanterna:Clone()
					lanternaNova.Parent = backpack
				end
			end
		end
	end
end)

DesastreFinalizado.Event:Connect(function(mensagem)
	if mensagem == true then
		pararTempestade()

		for _, jogador in ipairs(PlayersService:GetPlayers()) do
			local backpack = jogador:FindFirstChild("Backpack")
			local personagem = jogador.Character

			if backpack then
				local temNaMochila = backpack:FindFirstChild("Flashlight")
				if temNaMochila then
					temNaMochila:Destroy()
				end
			end

			if personagem then
				local temNaMao = personagem:FindFirstChild("Flashlight")
				if temNaMao then
					temNaMao:Destroy()
				end
			end
		end
	end
end)
