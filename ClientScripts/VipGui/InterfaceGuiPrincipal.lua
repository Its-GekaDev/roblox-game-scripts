--[[
    Description: LocalScript that manages VIP GUI slide animations using TweenService.
    Listens to a server RemoteEvent to slide in the GUI with audio feedback, 
    and handles smooth slide-out dismissal on close button activation.
--]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local button = script.Parent
local frame = button.Parent

-- Busca segura do RemoteEvent no ReplicatedStorage
local remoteVip = ReplicatedStorage:WaitForChild("GuiVipAtivar")

-- Referências dos Sons (Com tratamento de busca segura)
local soundOpen = frame:WaitForChild("GuiSound", 5)
local soundClose = frame:WaitForChild("GuiLeaveSound", 5)

-- Configurações da Animação
local TEMPO_ANIMACAO = 0.4
local tweenInfoAbre = TweenInfo.new(TEMPO_ANIMACAO, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local tweenInfoFecha = TweenInfo.new(TEMPO_ANIMACAO, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)

-- Captura a posição original definida no Studio para preservar o design
local posicaoOriginal = frame.Position
local posicaoEscondido = UDim2.new(posicaoOriginal.X.Scale, posicaoOriginal.X.Offset, 1.5, 0)

-- Estado inicial seguro
frame.Position = posicaoEscondido
frame.Visible = false

-- Variável para cancelar o Tween anterior se o usuário clicar rápido demais
local tweenAtual = nil

local function abrirMenu()
	if soundOpen then soundOpen:Play() end

	-- Cancela qualquer animação em andamento (ex: se estava fechando)
	if tweenAtual then tweenAtual:Cancel() end

	frame.Position = posicaoEscondido
	frame.Visible = true

	tweenAtual = TweenService:Create(frame, tweenInfoAbre, {Position = posicaoOriginal})
	tweenAtual:Play()
end

local function fecharMenu()
	if soundClose then soundClose:Play() end

	-- Cancela qualquer animação em andamento (ex: se estava abrindo)
	if tweenAtual then tweenAtual:Cancel() end

	tweenAtual = TweenService:Create(frame, tweenInfoFecha, {Position = posicaoEscondido})
	tweenAtual:Play()

	-- Aguarda exatamente o tempo da animação sem criar conexões de evento residuais
	task.wait(TEMPO_ANIMACAO)

	-- Garante que o Visible só desliga se o menu continuar na posição escondida
	if frame.Position == posicaoEscondido then
		frame.Visible = false
	end
end

-- Eventos
remoteVip.OnClientEvent:Connect(abrirMenu)
button.Activated:Connect(fecharMenu)
