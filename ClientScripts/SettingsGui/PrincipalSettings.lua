--[[
    Description: LocalScript that manages the popup animation for the NPC dialogue / settings GUI.
    Listens to both RemoteEvents (Server-to-Client) and BindableEvents (Client-to-Client) to trigger 
    a smooth scale-up opening animation using TweenService.
--]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Comunicação com o servidor e com outros scripts locais
local remoteEvent = ReplicatedStorage:WaitForChild("GuiConfigAtivar")
local bindableEvent = ReplicatedStorage:WaitForChild("GuiConfigAtivarBindable")

local frame = script.Parent

-- Configurações da Animação
local tempoAnimacao = 0.4
local tweenInfo = TweenInfo.new(tempoAnimacao, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Armazena o tamanho original definido no Studio
local tamanhoOriginal = frame.Size

-- Variável para guardar o Tween atual e evitar conflitos de animação
local tweenAtual = nil

-- Função centralizada para abrir a GUI com efeito de escala
local function abrirGui()
	-- Se a janela já estiver 100% aberta, ignora para não reiniciar o efeito
	if frame.Visible and frame.Size == tamanhoOriginal then return end

	-- Cancela qualquer animação de fechamento/abertura que esteja acontecendo no momento
	if tweenAtual then
		tweenAtual:Cancel()
	end

	-- Reseta a interface para o estado inicial (invisível e do tamanho zero)
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Visible = true

	-- Anima do tamanho zero até o tamanho original do Studio
	tweenAtual = TweenService:Create(frame, tweenInfo, {Size = tamanhoOriginal})
	tweenAtual:Play()
end

-- Ambas as vias de acionamento chamam a mesma função (Código limpo e sustentável)
remoteEvent.OnClientEvent:Connect(abrirGui)
bindableEvent.Event:Connect(abrirGui)
