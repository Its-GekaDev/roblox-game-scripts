--[[
    Description: Fires a RemoteEvent from ReplicatedStorage to notify the client 
    upon joining the game, allowing local UI elements to be enabled properly.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remoteEvent = ReplicatedStorage:WaitForChild("JogadorEntrouNoJogo")

Players.PlayerAdded:Connect(function(player)
	print("O jogador " .. player.Name .. " entrou no jogo!")
	
	-- Passa o parâmetro 'player' para o FireClient funcionar corretamente
	remoteEvent:FireClient(player)
end)
