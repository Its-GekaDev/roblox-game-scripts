--[[
    Description: LocalScript that handles the smooth closing animation for the Settings / NPC GUI.
    Scales the Frame down to zero using TweenService, restores its original size property upon completion,
    and includes debounce protection against click spam.
--]]

local TweenService = game:GetService("TweenService")

local button = script.Parent
local frame = button.Parent

-- Configurações da animação de fechamento
local tempoAnimacao = 0.3
local tweenInfo = TweenInfo.new(tempoAnimacao, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Armazena o tamanho original definido no Studio para reuso futuro
local tamanhoOriginal = frame.Size

-- Trava para evitar múltiplos cliques durante a animação
local isClosing = false

button.Activated:Connect(function()
	if isClosing or not frame.Visible then return end
	isClosing = true

	-- Cria a animação de encolhimento (escala até zero)
	local tween = TweenService:Create(frame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
	tween:Play()

	-- Espera a animação terminar sem criar vazamento de memória (sem :Connect)
	tween.Completed:Wait()

	-- Oculta o frame e restaura a propriedade de tamanho original
	frame.Visible = false
	frame.Size = tamanhoOriginal

	isClosing = false
end)
