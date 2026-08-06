--[[
    Description: Shared ModuleScript that manages map selection and spawning logic.
    Picks a random map from the catalog, clones the target model into Workspace, 
    and returns both the cloned Instance and designated spawn CFrame.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local MapService = {}

-- Gerador de aleatoriedade do Luau moderno
local rng = Random.new()

-- Catálogo de configurações (Armazena nomes em vez de instâncias diretas)
local catalogMapas = {
	{
		Nome = "MapaCasaClassica",
		ModeloNome = "MapaCasaClassica",
		SpawnPosicao = CFrame.new(-46.545, 13866.477, 502.707),
	},
	{
		Nome = "MapaPostoGasolina",
		ModeloNome = "MapaPostoGasolina",
		SpawnPosicao = CFrame.new(-26.105, 13846.646, 507.663),
	},
	{
		Nome = "MapaAeroporto",
		ModeloNome = "MapaAeroporto",
		SpawnPosicao = CFrame.new(-44.575, 13901.78, 511.862),
	},
	{
		Nome = "IlhaDeAreia",
		ModeloNome = "IlhaDeAreia",
		SpawnPosicao = CFrame.new(-36.395, 13844.627, 445.558),
	},
	{
		Nome = "MapaCasaNeve",
		ModeloNome = "MapaCasaNeve",
		SpawnPosicao = CFrame.new(-30.519, 13853.383, 451.391),
	},
	{
		Nome = "TorreMapa",
		ModeloNome = "TorreMapa",
		SpawnPosicao = CFrame.new(-24.519, 13882.026, 454.643),
	},
	{
		Nome = "MapaCasteloMedieval",
		ModeloNome = "MapaCasteloMedieval",
		SpawnPosicao = CFrame.new(25.81, 13905.858, 483.252),
	},
	{
		Nome = "JJSmapa",
		ModeloNome = "JJSMapa",
		SpawnPosicao = CFrame.new(-505.973, 13942.864, 421.336),
	},
}

function MapService.EscolherMapa()
	local pastaMapas = ReplicatedStorage:WaitForChild("Mapas", 5)
	if not pastaMapas then
		warn("[MAP SERVICE] Pasta ReplicatedStorage.Mapas não encontrada!")
		return nil, nil
	end

	-- Sorteio aleatório moderno
	local indiceAleatorio = rng:NextInteger(1, #catalogMapas)
	local dadosMapa = catalogMapas[indiceAleatorio]

	local modeloOriginal = pastaMapas:FindFirstChild(dadosMapa.ModeloNome)
	if not modeloOriginal then
		warn("[MAP SERVICE] Modelo do mapa não encontrado em ReplicatedStorage.Mapas: " .. tostring(dadosMapa.ModeloNome))
		return nil, nil
	end

	print("[MAP SERVICE] Mapa escolhido com sucesso: " .. dadosMapa.Nome)

	local mapaClonado = modeloOriginal:Clone()
	mapaClonado.Parent = Workspace

	-- Retorna o mapa instanciado no Workspace e a CFrame de Spawn
	return mapaClonado, dadosMapa.SpawnPosicao
end

return MapService
