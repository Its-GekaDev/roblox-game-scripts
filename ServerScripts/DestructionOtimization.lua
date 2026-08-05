--[[
    Description: Optimizes destruction physics by handling debris cleanup automatically.
    Disables heavy properties (CanTouch, CastShadow) on unanchored loose parts and fades 
    them out over time using TweenService to save server performance.
--]]

local PhysicsService = game:GetService("PhysicsService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")

-- CONFIGURAÇÕES
local TEMPO_PARA_SUMIR = 4
local DURACAO_DO_FADE = 1.0
local GRUPO_COLISAO = "Detritos"
local TAG_IGNORAR = "NaoDestruir"

pcall(function()
	PhysicsService:RegisterCollisionGroup(GRUPO_COLISAO)
end)
pcall(function()
	PhysicsService:CollisionGroupSetCollidable(GRUPO_COLISAO, GRUPO_COLISAO, false)
end)

local pecasEmProcesso = {}

local function deveIgnorar(instancia)
	local atual = instancia
	while atual and atual ~= workspace do
		if CollectionService:HasTag(atual, TAG_IGNORAR) then
			return true
		end
		atual = atual.Parent
	end
	return false
end

local function sumirComPeca(part)
	if pecasEmProcesso[part] then return end
	pecasEmProcesso[part] = true

	-- Otimizações instantâneas para salvar FPS
	part.CanTouch = false
	part.CanQuery = false
	part.CastShadow = false
	part.Material = Enum.Material.SmoothPlastic

	pcall(function()
		part.CollisionGroup = GRUPO_COLISAO
	end)

	task.wait(TEMPO_PARA_SUMIR)

	if not part or not part.Parent then 
		pecasEmProcesso[part] = nil
		return 
	end

	local info = TweenInfo.new(DURACAO_DO_FADE, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(part, info, {Transparency = 1})

	tween:Play()

	tween.Completed:Connect(function()
		if part and part.Parent then
			part:Destroy()
		end
		pecasEmProcesso[part] = nil
	end)
end

-- Função para checar se uma nova peça é um detrito solto
local function processarInstancia(descendente)
	if descendente:IsA("BasePart") and not descendente.Anchored then
		if not deveIgnorar(descendente) then
			if not descendente:FindFirstAncestorOfClass("Model") or not descendente:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
				
				-- Aguarda 0.1s para ter certeza de que as juntas/welds carregaram antes de checar
				task.defer(function()
					if descendente and descendente.Parent and #descendente:GetJoints() == 0 then
						sumirComPeca(descendente)
					end
				end)
			end
		end
	end
end

-- EVENTO: Roda instantaneamente APENAS quando algo novo nasce no jogo (Sem lag de loop)
workspace.DescendantAdded:Connect(processarInstancia)
