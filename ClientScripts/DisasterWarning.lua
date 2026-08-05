--[[
    Description: LocalScript that listens for disaster alert events from the server.
    Animates a top notification banner using TweenService (Back/Quad easing styles)
    and plays audio feedback when a new disaster strikes.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RemoteEvent = ReplicatedStorage:WaitForChild("AvisoDesastre")

local screenGui = script.Parent
local frame = screenGui:WaitForChild("Frame")
local textLabel = frame:WaitForChild("TextoAviso")
local soundHeart = screenGui:WaitForChild("SoundHeart")

-- Configuração das posições da UI
local posicaoEscondido = UDim2.new(0.5, 0, -0.2, 0) 
local posicaoVisivel = UDim2.new(0.5, 0, 0.05, 0)   

frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = posicaoEscondido

-- Configuração do movimento suave (Estilo mola na entrada, suave na saída)
local infoTweenIn = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local infoTweenOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Variável para guardar o Tween atual e evitar conflitos de animação
local tweenAtual = nil

RemoteEvent.OnClientEvent:Connect(function(nomeDoDesastre)
	-- Cancela qualquer animação anterior que ainda esteja rodando
	if tweenAtual then
		tweenAtual:Cancel()
	end

	-- Trata o parâmetro caso venha como Tabela, Instância ou String
	local nomeTexto = "DESASTRE"
	if typeof(nomeDoDesastre) == "Instance" then
		nomeTexto = nomeDoDesastre.Name
	elseif typeof(nomeDoDesastre) == "table" then
		nomeTexto = nomeDoDesastre.Name or nomeDoDesastre.Nome or nomeDoDesastre[1] or "DESASTRE"
	elseif typeof(nomeDoDesastre) == "string" then
		nomeTexto = nomeDoDesastre
	end

	textLabel.Text = string.upper(nomeTexto) .. " IS LOOSE ON THE ISLAND!"

	frame.Visible = true 

	-- 1. Animação para DESCER o aviso
	tweenAtual = TweenService:Create(frame, infoTweenIn, {Position = posicaoVisivel})
	tweenAtual:Play()
	
	if soundHeart then
		soundHeart:Play()
	end

	-- Tempo em que a notificação permanece visível
	task.wait(5)

	-- 2. Animação para SUBIR e esconder o aviso
	tweenAtual = TweenService:Create(frame, infoTweenOut, {Position = posicaoEscondido})
	tweenAtual:Play()
	
	-- CORREÇÃO CRÍTICA: Espera a animação de subida terminar ANTES de ocultar o Frame!
	tweenAtual.Completed:Wait()
	frame.Visible = false
end)
