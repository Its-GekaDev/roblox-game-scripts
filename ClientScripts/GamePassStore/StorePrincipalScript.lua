--[[
    Description: LocalScript that manages sliding UI transitions for NPC dialogue and main menus.
    Handles smooth slide-in and slide-out animations from off-screen using TweenService, 
    plays open/close audio cues, and listens to both RemoteEvents and BindableEvents.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- Serviços e Eventos de Comunicação
local remoteAbre = ReplicatedStorage:WaitForChild("GuiAtivar")
local bindableAbre = ReplicatedStorage:WaitForChild("GuiAtivarBindable")

-- Elementos da Interface
local buttonClose = script.Parent
local frame = buttonClose.Parent

local soundOpen = frame:WaitForChild("GuiSound")
local soundClose = frame:WaitForChild("GuiLeaveSound")

-- Configurações da Animação
local tempoAnimacao = 0.4
local tweenInfoAbre = TweenInfo.new(tempoAnimacao, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local tweenInfoFecha = TweenInfo.new(tempoAnimacao, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)

-- Posições da Interface
local posicaoOriginal = UDim2.new(0.5, 0, 0.5, 0)  -- Centro da tela
local posicaoEscondido = UDim2.new(0.5, 0, 1.5, 0)  -- Abaixo do rodapé (Fora da tela)

-- Ponto de Ancoragem Centralizado
frame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Controle de Concorrência
local isAnimating = false

-- Função Centralizada para ABRIR o Menu
local function abrirMenu()
	if frame.Visible and frame.Position == posicaoOriginal then return end

	if soundOpen then
		soundOpen:Play()
	end

	-- Prepara a posição inicial fora da tela antes de exibir
	frame.Position = posicaoEscondido
	frame.Visible = true

	-- Anima o slide subindo até o centro
	local tweenPosicao = TweenService:Create(frame, tweenInfoAbre, {Position = posicaoOriginal})
	tweenPosicao:Play()
end

-- Função para FECHAR o Menu (Acionada pelo botão)
local function fecharMenu()
	if isAnimating or not frame.Visible then return end
	isAnimating = true

	if soundClose then
		soundClose:Play()
	end

	-- Anima o slide descendo para fora da tela
	local tweenPosicao = TweenService:Create(frame, tweenInfoFecha, {Position = posicaoEscondido})
	tweenPosicao:Play()

	-- Espera o término do movimento sem criar vazamentos de memória (Sem :Connect)
	tweenPosicao.Completed:Wait()

	frame.Visible = false
	isAnimating = false
end

-- Conexão dos Eventos
buttonClose.Activated:Connect(fecharMenu)

remoteAbre.OnClientEvent:Connect(abrirMenu)
bindableAbre.Event:Connect(abrirMenu)
