--[[
    Description: LocalScript that manages the News NPC interface (NewsNpcGUI).
    Listens to a RemoteEvent to open the GUI when interacting with the NPC, 
    and handles the close button action to hide the interface.
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local closeButton = script.Parent
local player = Players.LocalPlayer

-- Espera o PlayerGui e a interface carregarem com segurança no cliente
local playerGui = player:WaitForChild("PlayerGui")
local newsGui = playerGui:WaitForChild("NewsNpcGUI")
local mainInterface = newsGui:WaitForChild("InterfacePrincipal")

local remoteAbrir = ReplicatedStorage:WaitForChild("AbrirNewsGui")

-- O botão fecha a interface
local function fecharInterface()
	mainInterface.Visible = false
end

-- O evento do servidor abre a interface
local function abrirInterface()
	mainInterface.Visible = true
end

closeButton.Activated:Connect(fecharInterface)
remoteAbrir.OnClientEvent:Connect(abrirInterface)
