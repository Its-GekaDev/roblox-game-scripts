--[[
    Description: LocalScript that toggles a low-spec / performance mode ("Potato Mode").
    Dynamically strips textures, particle emitters, cast shadows, and terrain visual features 
    client-side to drastically increase FPS on low-end hardware, with state restoration support.
--]]

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Terrain = Workspace:WaitForChild("Terrain")

local framePotato = script.Parent
local botaoToggle = framePotato:WaitForChild("Botao") 

-- Esconde botões legados se existirem
local botaoNao = framePotato:FindFirstChild("Não")
if botaoNao then
	botaoNao.Visible = false
end

-- Definição das Cores de Estado
local COR_VERDE = Color3.fromRGB(46, 204, 113)
local COR_VERMELHA = Color3.fromRGB(231, 76, 60)

-- Cache de Estados Originais
local texturasOriginais = {}
local materiaisOriginais = {}
local sombrasOriginais = {}

local conexaoNovasInstancias = nil
local ativo = false

-- Configuração Visual do Botão
botaoToggle.BackgroundColor3 = COR_VERMELHA
botaoToggle.Text = "Modo Batata: DESATIVADO"

-- Cache da Iluminação
local efeitosIluminacao = {}
for _, efeito in ipairs(Lighting:GetChildren()) do
	if efeito:IsA("PostEffect") or efeito:IsA("BloomEffect") or efeito:IsA("BlurEffect") or efeito:IsA("DepthOfFieldEffect") or efeito:IsA("SunRaysEffect") then
		efeitosIluminacao[efeito] = efeito.Enabled
	end
end

-- Cache de Propriedades da Água
local ondasTamanhoOriginal = Terrain and Terrain.WaterWaveSize or 0
local ondasVelocidadeOriginal = Terrain and Terrain.WaterWaveSpeed or 0
local reflexoOriginal = Terrain and Terrain.WaterReflectance or 0
local transparenciaOriginal = Terrain and Terrain.WaterTransparency or 0

-- Aplica a redução visual por objeto
local function espremerFisicaEDetalhe(objeto)
	local modelo = objeto:FindFirstAncestorOfClass("Model")
	if modelo and modelo:FindFirstChildOfClass("Humanoid") then
		return
	end

	if objeto:IsA("Decal") or objeto:IsA("Texture") then
		if not texturasOriginais[objeto] then texturasOriginais[objeto] = objeto.Texture end
		objeto.Texture = ""

	elseif objeto:IsA("ParticleEmitter") or objeto:IsA("Smoke") or objeto:IsA("Fire") or objeto:IsA("Sparkles") or objeto:IsA("Light") then
		objeto.Enabled = false

	elseif objeto:IsA("BasePart") then
		if not materiaisOriginais[objeto] then
			materiaisOriginais[objeto] = objeto.Material
			sombrasOriginais[objeto] = objeto.CastShadow
		end

		objeto.Material = Enum.Material.SmoothPlastic
		objeto.CastShadow = false

		if objeto:IsA("MeshPart") then
			if not texturasOriginais[objeto] then
				texturasOriginais[objeto] = objeto.TextureID
			end
			objeto.TextureID = ""
		end
	end
end

-- Restaura as propriedades originais do objeto
local function restaurarObjeto(objeto)
	if objeto:IsA("Decal") or objeto:IsA("Texture") then
		if texturasOriginais[objeto] then 
			objeto.Texture = texturasOriginais[objeto] 
			texturasOriginais[objeto] = nil
		end

	elseif objeto:IsA("ParticleEmitter") or objeto:IsA("Smoke") or objeto:IsA("Fire") or objeto:IsA("Sparkles") or objeto:IsA("Light") then
		objeto.Enabled = true

	elseif objeto:IsA("BasePart") then
		if materiaisOriginais[objeto] then
			objeto.Material = materiaisOriginais[objeto]
			objeto.CastShadow = sombrasOriginais[objeto]
			materiaisOriginais[objeto] = nil
			sombrasOriginais[objeto] = nil
		end

		if objeto:IsA("MeshPart") and texturasOriginais[objeto] then
			objeto.TextureID = texturasOriginais[objeto]
			texturasOriginais[objeto] = nil
		end
	end
end

-- Função de alternância (Toggle)
local function alternarModoBatata()
	ativo = not ativo

	if ativo then
		-- ATIVA O MODO BATATA
		botaoToggle.Text = "Modo Batata: ATIVADO"
		botaoToggle.BackgroundColor3 = COR_VERDE

		for _, descendente in ipairs(Workspace:GetDescendants()) do
			espremerFisicaEDetalhe(descendente)
		end

		if not conexaoNovasInstancias then
			conexaoNovasInstancias = Workspace.DescendantAdded:Connect(espremerFisicaEDetalhe)
		end

		for efeito, _ in pairs(efeitosIluminacao) do 
			efeito.Enabled = false 
		end

		if Terrain then
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 0
		end
	else
		-- DESATIVA E RESTAURA
		botaoToggle.Text = "Modo Batata: DESATIVADO"
		botaoToggle.BackgroundColor3 = COR_VERMELHA

		if conexaoNovasInstancias then
			conexaoNovasInstancias:Disconnect()
			conexaoNovasInstancias = nil
		end

		for _, descendente in ipairs(Workspace:GetDescendants()) do
			restaurarObjeto(descendente)
		end

		for efeito, estadoOriginal in pairs(efeitosIluminacao) do 
			efeito.Enabled = estadoOriginal 
		end

		if Terrain then
			Terrain.WaterWaveSize = ondasTamanhoOriginal
			Terrain.WaterWaveSpeed = ondasVelocidadeOriginal
			Terrain.WaterReflectance = reflexoOriginal
			Terrain.WaterTransparency = transparenciaOriginal
		end
	end
end

botaoToggle.Activated:Connect(alternarModoBatata)
