--[[
    Description: LocalScript that toggles the Music Playlist interface (MusicPlaylistGUI) on and off.
    Updates the UI state, changes the button text and background color dynamically, 
    and handles touch/click inputs securely.
--]]

local Players = game:GetService("Players")

local button = script.Parent
local player = Players.LocalPlayer

-- Aguarda o PlayerGui e a Interface carregarem com segurança
local playerGui = player:WaitForChild("PlayerGui")
local musicGUI = playerGui:WaitForChild("MusicPlaylistGUI")
local guiContainer = musicGUI:WaitForChild("MainContainer")

-- Definição das Cores de Estado
local COR_VERDE = Color3.fromRGB(46, 204, 113)
local COR_VERMELHA = Color3.fromRGB(231, 76, 60)

-- Estado Inicial: Começa fechado (Vermelho)
guiContainer.Visible = false
button.BackgroundColor3 = COR_VERMELHA
button.Text = "Música: FECHADO"

local function alternarPlaylist()
	-- Inverte a visibilidade do container principal
	guiContainer.Visible = not guiContainer.Visible

	if guiContainer.Visible then
		-- Estado: ABERTO (Verde)
		button.BackgroundColor3 = COR_VERDE
		button.Text = "Música: ABERTO"
	else
		-- Estado: FECHADO (Vermelho)
		button.BackgroundColor3 = COR_VERMELHA
		button.Text = "Música: FECHADO"
	end
end

-- CONEXÃO DO EVENTO (Corrigido: Garante que o botão responda aos cliques)
button.Activated:Connect(alternarPlaylist)
end

-- Conecta a função ao evento de clique do botão
button.Activated:Connect(alternarPlaylist)
