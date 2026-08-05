---[[
    Description: LocalScript that manages the teleport announcement GUI and countdown animation.
    Handles side-banner entry using TweenService, syncs the 10-second teleport window visual display,
    and cleanly resets interface state upon expiration.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Referências de Comunicação com o Servidor
local RemoteEvent = ReplicatedStorage:WaitForChild("MapaCriadoGui")
local RemoteGuiBaixou = ReplicatedStorage:WaitForChild("TeleporteBaixou")
local RemoteGuiSaiu = ReplicatedStorage:WaitForChild("TeleporteSaiu")

-- Referências de UI
local screenGui = script.Parent 
local teleporteGui = PlayerGui:WaitForChild("TeleporteGui")
local interfaceTeleporte = teleporteGui:WaitForChild("InterfacePrincipalTeleporte")

local frame = screenGui:WaitForChild("Frame")
local textLabel = frame:WaitForChild("TextoTeleporte")
local sound = screenGui:WaitForChild("SoundGui")

-- Garantir estado inicial
interfaceTeleporte.Visible = false

-- Posições da Animação (Slide Lateral)
local posicaoEscondido = UDim2.new(-0.3, 0, 0.4, 0) 
local posicaoVisivel   = UDim2.new(0.01, 0, 0.4, 0)   

frame.AnchorPoint = Vector2.new(0, 0)
frame.Position = posicaoEscondido

-- Configurações do Tween
local infoTweenIn = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local infoTweenOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local executando = false

RemoteEvent.OnClientEvent:Connect(function()
	if executando then return end
	executando = true

	frame.Visible = true 
	
	-- Animação de Entrada
	local tweenEntrar = TweenService:Create(frame, infoTweenIn, {Position = posicaoVisivel})
	tweenEntrar:Play()
	
	if sound then
		sound:Play()
	end

	-- Exibe os botões de confirmação do teleporte
	interfaceTeleporte.Visible = true

	-- Notifica o servidor que o cliente iniciou a janela visual
	RemoteGuiBaixou:FireServer()

	-- Contagem Regressiva Visual de 10 segundos
	for i = 10, 1, -1 do
		textLabel.Text = "Teleporte Liberado!! " .. i .. "s"
		task.wait(1)
	end

	-- Notifica o servidor que a janela expirou no cliente
	RemoteGuiSaiu:FireServer()

	-- Oculta os botões e faz o banner recolher
	interfaceTeleporte.Visible = false

	local tweenSair = TweenService:Create(frame, infoTweenOut, {Position = posicaoEscondido})
	tweenSair:Play()
	tweenSair.Completed:Wait()

	frame.Visible = false
	executando = false
end)
