--[[
    Description: LocalScript that handles client-side Store GUI display.
    Listens to a RemoteEvent to display the store interface when triggered by the server
    (e.g., via ProximityPrompt) and handles the close button action to hide the UI.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local closeButton = script.Parent
local mainFrame = closeButton.Parent

local remoteAbrirLoja = ReplicatedStorage:WaitForChild("AbrirLoja")

-- Função para abrir a loja quando acionada pelo servidor
local function abrirLoja()
	mainFrame.Visible = true
end

-- Função para fechar a loja quando o jogador clica no botão de fechar
local function fecharLoja()
	mainFrame.Visible = false
end

-- Conexão dos Eventos
remoteAbrirLoja.OnClientEvent:Connect(abrirLoja)
closeButton.Activated:Connect(fecharLoja)
